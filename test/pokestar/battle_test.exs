defmodule Pokestar.BattleTest do
  use Pokestar.DataCase

  alias Pokestar.Battle

  describe "pokemons" do
    alias Pokestar.Battle.Pokemon

    import Pokestar.BattleFixtures

    @invalid_attrs %{name: nil, type_1: nil, type_2: nil}

    test "list_pokemons/0 returns all pokemons" do
      pokemon = pokemon_fixture()
      assert Battle.list_pokemons() == [pokemon]
    end

    test "get_pokemon!/1 returns the pokemon with given id" do
      pokemon = pokemon_fixture()
      assert Battle.get_pokemon!(pokemon.id) == pokemon
    end

    test "create_pokemon/1 with valid data creates a pokemon" do
      valid_attrs = %{name: "some name", type_1: "some type_1", type_2: "some type_2"}

      assert {:ok, %Pokemon{} = pokemon} = Battle.create_pokemon(valid_attrs)
      assert pokemon.name == "some name"
      assert pokemon.type_1 == "some type_1"
      assert pokemon.type_2 == "some type_2"
    end

    test "create_pokemon/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Battle.create_pokemon(@invalid_attrs)
    end

    test "update_pokemon/2 with valid data updates the pokemon" do
      pokemon = pokemon_fixture()
      update_attrs = %{name: "some updated name", type_1: "some updated type_1", type_2: "some updated type_2"}

      assert {:ok, %Pokemon{} = pokemon} = Battle.update_pokemon(pokemon, update_attrs)
      assert pokemon.name == "some updated name"
      assert pokemon.type_1 == "some updated type_1"
      assert pokemon.type_2 == "some updated type_2"
    end

    test "update_pokemon/2 with invalid data returns error changeset" do
      pokemon = pokemon_fixture()
      assert {:error, %Ecto.Changeset{}} = Battle.update_pokemon(pokemon, @invalid_attrs)
      assert pokemon == Battle.get_pokemon!(pokemon.id)
    end

    test "delete_pokemon/1 deletes the pokemon" do
      pokemon = pokemon_fixture()
      assert {:ok, %Pokemon{}} = Battle.delete_pokemon(pokemon)
      assert_raise Ecto.NoResultsError, fn -> Battle.get_pokemon!(pokemon.id) end
    end

    test "change_pokemon/1 returns a pokemon changeset" do
      pokemon = pokemon_fixture()
      assert %Ecto.Changeset{} = Battle.change_pokemon(pokemon)
    end
  end
end
