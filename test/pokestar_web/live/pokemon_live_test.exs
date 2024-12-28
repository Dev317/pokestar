defmodule PokestarWeb.PokemonLiveTest do
  use PokestarWeb.ConnCase

  import Phoenix.LiveViewTest
  import Pokestar.BattleFixtures

  @create_attrs %{name: "some name", type_1: "some type_1", type_2: "some type_2"}
  @update_attrs %{name: "some updated name", type_1: "some updated type_1", type_2: "some updated type_2"}
  @invalid_attrs %{name: nil, type_1: nil, type_2: nil}

  defp create_pokemon(_) do
    pokemon = pokemon_fixture()
    %{pokemon: pokemon}
  end

  describe "Index" do
    setup [:create_pokemon]

    test "lists all pokemons", %{conn: conn, pokemon: pokemon} do
      {:ok, _index_live, html} = live(conn, ~p"/pokemons")

      assert html =~ "Listing Pokemons"
      assert html =~ pokemon.name
    end

    test "saves new pokemon", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pokemons")

      assert index_live |> element("a", "New Pokemon") |> render_click() =~
               "New Pokemon"

      assert_patch(index_live, ~p"/pokemons/new")

      assert index_live
             |> form("#pokemon-form", pokemon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pokemon-form", pokemon: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pokemons")

      html = render(index_live)
      assert html =~ "Pokemon created successfully"
      assert html =~ "some name"
    end

    test "updates pokemon in listing", %{conn: conn, pokemon: pokemon} do
      {:ok, index_live, _html} = live(conn, ~p"/pokemons")

      assert index_live |> element("#pokemons-#{pokemon.id} a", "Edit") |> render_click() =~
               "Edit Pokemon"

      assert_patch(index_live, ~p"/pokemons/#{pokemon}/edit")

      assert index_live
             |> form("#pokemon-form", pokemon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#pokemon-form", pokemon: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/pokemons")

      html = render(index_live)
      assert html =~ "Pokemon updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes pokemon in listing", %{conn: conn, pokemon: pokemon} do
      {:ok, index_live, _html} = live(conn, ~p"/pokemons")

      assert index_live |> element("#pokemons-#{pokemon.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pokemons-#{pokemon.id}")
    end
  end

  describe "Show" do
    setup [:create_pokemon]

    test "displays pokemon", %{conn: conn, pokemon: pokemon} do
      {:ok, _show_live, html} = live(conn, ~p"/pokemons/#{pokemon}")

      assert html =~ "Show Pokemon"
      assert html =~ pokemon.name
    end

    test "updates pokemon within modal", %{conn: conn, pokemon: pokemon} do
      {:ok, show_live, _html} = live(conn, ~p"/pokemons/#{pokemon}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Pokemon"

      assert_patch(show_live, ~p"/pokemons/#{pokemon}/show/edit")

      assert show_live
             |> form("#pokemon-form", pokemon: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#pokemon-form", pokemon: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/pokemons/#{pokemon}")

      html = render(show_live)
      assert html =~ "Pokemon updated successfully"
      assert html =~ "some updated name"
    end
  end
end
