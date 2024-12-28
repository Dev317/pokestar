defmodule PokestarWeb.PokemonLive.Show do
  use PokestarWeb, :live_view

  alias Pokestar.Battle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pokemon, Battle.get_pokemon!(id))}
  end

  defp page_title(:show), do: "Show Pokemon"
  defp page_title(:edit), do: "Edit Pokemon"
end
