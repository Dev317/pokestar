defmodule PokestarWeb.PokemonLive.Index do
  use PokestarWeb, :live_view

  alias Pokestar.Battle
  alias Pokestar.Battle.Pokemon

  @impl true
  def mount(_params, _session, socket) do
    case connected?(socket) do
     true ->
      player_1 = Battle.get_random_pokemon()
      player_2 = Battle.get_random_pokemon(player_1.id)
      match = Battle.create_live_match(player_1.id, player_2.id)
      {:ok, socket
        |> assign(:match, match)
        |> assign(:player_1, player_1)
        |> assign(:player_2, player_2)
        |> assign(:page, "loaded")
        |> stream(:pokemons, Battle.list_pokemons())
      }
      false -> {:ok, assign(socket, page: "loading")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pokemon")
    |> assign(:pokemon, Battle.get_pokemon!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Pokemon")
    |> assign(:pokemon, %Pokemon{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pokemons")
    |> assign(:pokemon, nil)
  end

  @impl true
  def handle_info({PokestarWeb.PokemonLive.FormComponent, {:saved, pokemon}}, socket) do
    {:noreply, stream_insert(socket, :pokemons, pokemon)}
  end

  @impl true
  def handle_info({PokestarWeb.PokemonLive.MatchComponent, {:updated_match, msg}}, socket) do
    %{match: match, player_1: player_1, player_2: player_2} = msg
    updated_socket = socket
      |> assign(:match, match)
      |> assign(:player_1, player_1)
      |> assign(:player_2, player_2)
    {:noreply, updated_socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pokemon = Battle.get_pokemon!(id)
    {:ok, _} = Battle.delete_pokemon(pokemon)

    {:noreply, stream_delete(socket, :pokemons, pokemon)}
  end
end
