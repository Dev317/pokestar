defmodule Pokestar.Enums.Battle.PokemonSchema do
  use Ecto.Schema

  def pokemon_type_enum do
    [
      :grass, :fire, :water, :bug, :normal,
      :poison, :electric, :ground, :fairy, :fighting,
      :psychic, :rock, :ghost, :ice, :dragon,
      :dark, :steel, :flying
    ]
  end

  schema "pokemons" do
    embeds_one :embed, Embed do
      field :type_1, Ecto.Enum, values: [
          :grass, :fire, :water, :bug, :normal,
          :poison, :electric, :ground, :fairy, :fighting,
          :psychic, :rock, :ghost, :ice, :dragon,
          :dark, :steel, :flying
        ]
      field :type_2, Ecto.Enum, values: [
          :grass, :fire, :water, :bug, :normal,
          :poison, :electric, :ground, :fairy, :fighting,
          :psychic, :rock, :ghost, :ice, :dragon,
          :dark, :steel, :flying
        ]
    end
  end
end
