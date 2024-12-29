defmodule PokestarWeb.PokemonLive.MatchComponent do
  use PokestarWeb, :live_component

  @impl true
  def render(assigns) do
    ~H"""
    <div class="battle max-w-3xl mx-auto mt-10 p-6 bg-gray-50 rounded-lg shadow-md">
      <h1 class="text-2xl font-bold text-center mb-4">
        Live Match #{@match.id}
      </h1>

      <div class="flex justify-between items-center">
        <div class="pokemon-details text-center p-4 w-1/3 bg-white border border-gray-200 rounded-lg shadow-lg">
          <h2 class="text-xl font-semibold">{@player_1.name}</h2>
          <p class="text-sm text-gray-500">Type_1: {@player_1.type_1}</p>
          <p class="text-sm text-gray-500">Type_2: {@player_1.type_2}</p>
          <.button
            phx-click="vote"
            phx-value-winner="1"
            class="mt-4 px-4 py-2 bg-blue-500 text-white font-semibold rounded hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-400">
            Vote
          </.button>
        </div>

        <div class="vs">VS</div>

        <div class="pokemon-details text-center p-4 w-1/3 bg-white border border-gray-200 rounded-lg shadow-lg">
          <h2 class="text-xl font-semibold">{@player_2.name}</h2>
          <p class="text-sm text-gray-500">Type_1: {@player_2.type_1}</p>
          <p class="text-sm text-gray-500">Type_2: {@player_2.type_2}</p>
          <.button
            phx-click="vote"
            phx-value-winner="2"
            class="mt-4 px-4 py-2 bg-red-500 text-white font-semibold rounded hover:bg-red-600 focus:outline-none focus:ring-2 focus:ring-blue-400">
            Vote
          </.button>
        </div>
      </div>
    </div>
    """
  end
end
