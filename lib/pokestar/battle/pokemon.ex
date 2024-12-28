defmodule Pokestar.Battle.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset
  alias Pokestar.Enums.Battle.PokemonSchema

  schema "pokemons" do
    field :name, :string
    field :type_1, Ecto.Enum, values: PokemonSchema.pokemon_type_enum()
    field :type_2, Ecto.Enum, values: PokemonSchema.pokemon_type_enum()

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pokemon, attrs) do
    pokemon
    |> cast(attrs, [:name, :type_1, :type_2])
    |> validate_required([:name, :type_1])
    |> validate_inclusion(:type_1, PokemonSchema.pokemon_type_enum())
  end
end
