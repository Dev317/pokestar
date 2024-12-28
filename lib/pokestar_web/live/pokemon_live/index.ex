defmodule PokestarWeb.PokemonLive.Index do
  use PokestarWeb, :live_view

  alias Pokestar.Battle
  alias Pokestar.Battle.Pokemon

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :pokemons, Battle.list_pokemons())}
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
  def handle_event("delete", %{"id" => id}, socket) do
    pokemon = Battle.get_pokemon!(id)
    {:ok, _} = Battle.delete_pokemon(pokemon)

    {:noreply, stream_delete(socket, :pokemons, pokemon)}
  end
end
