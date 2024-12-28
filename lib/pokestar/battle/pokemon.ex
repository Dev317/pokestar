defmodule Pokestar.Battle.Pokemon do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pokemons" do
    field :name, :string
    field :type_1, :string
    field :type_2, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pokemon, attrs) do
    pokemon
    |> cast(attrs, [:name, :type_1, :type_2])
    |> validate_required([:name, :type_1, :type_2])
  end
end
