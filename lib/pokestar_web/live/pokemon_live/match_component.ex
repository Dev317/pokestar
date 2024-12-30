defmodule PokestarWeb.PokemonLive.MatchComponent do
  use PokestarWeb, :live_component

  alias Pokestar.Battle

  @impl true
  def render(assigns) do
    ~H"""
    <div class="battle max-w-3xl mx-auto mt-10 p-6 bg-gray-50 rounded-lg shadow-md">
      <h1 class="text-2xl font-bold text-center mb-4">
        Live Match #{@match.id}
      </h1>

      <div class="flex justify-between items-center">
        <div class="pokemon-details text-center p-4 w-1/3 bg-white border border-gray-200 rounded-lg shadow-lg">
          <img src={~p"/images/pokemon/#{@player_1.name <> ".png"}"}
            alt={@player_1.name}
            class="w-24 h-24 mx-auto rounded-full mb-4"
          />
          <h2 class="text-xl font-semibold">{@player_1.name}</h2>
          <p class="text-sm text-gray-500">Type_1: {@player_1.type_1}</p>
          <p class="text-sm text-gray-500">Type_2: {@player_1.type_2}</p>
          <.button
            phx-target={@myself}
            phx-click="vote_player_1"
            class="mt-4 px-4 py-2 bg-blue-500 text-white font-semibold rounded hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400">
            Vote
          </.button>
        </div>

        <div class="vs">VS</div>

        <div class="pokemon-details text-center p-4 w-1/3 bg-white border border-gray-200 rounded-lg shadow-lg">
          <img src={~p"/images/pokemon/#{@player_2.name <> ".png"}"}
            alt={@player_2.name}
            class="w-24 h-24 mx-auto rounded-full mb-4"
          />
          <h2 class="text-xl font-semibold">{@player_2.name}</h2>
          <p class="text-sm text-gray-500">Type_1: {@player_2.type_1}</p>
          <p class="text-sm text-gray-500">Type_2: {@player_2.type_2}</p>
          <.button
            phx-target={@myself}
            phx-click="vote_player_2"
            class="mt-4 px-4 py-2 bg-red-500 text-white font-semibold rounded hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-blue-400">
            Vote
          </.button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("vote_player_1", %{"value" => ""}, socket) do
    Battle.update_match(socket.assigns.match, %{winner_id: socket.assigns.player_1.id})
    player_2 = Battle.get_random_pokemon(socket.assigns.player_1.id)
    new_match = Battle.create_live_match(socket.assigns.player_1.id, player_2.id)
    message =  %{
      player_1: socket.assigns.player_1,
      player_2: player_2,
      match: new_match
    }
    notify_parent({:updated_match, message})
    {:noreply,
      socket
      |> put_flash(:info, "Vote winner #{socket.assigns.player_1.name} successfully!")
      |> push_patch(to: socket.assigns.patch)
    }
  end

  @impl true
  def handle_event("vote_player_2", %{"value" => ""}, socket) do
    Battle.update_match(socket.assigns.match, %{winner_id: socket.assigns.player_2.id})
    player_1 = Battle.get_random_pokemon(socket.assigns.player_2.id)
    new_match = Battle.create_live_match(player_1.id, socket.assigns.player_2.id)
    message =  %{
      player_1: player_1,
      player_2: socket.assigns.player_2,
      match: new_match
    }
    notify_parent({:updated_match, message})
    {:noreply,
      socket
        |> put_flash(:info, "Vote winner #{socket.assigns.player_2.name} successfully!")
        |> push_patch(to: socket.assigns.patch)
    }
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
