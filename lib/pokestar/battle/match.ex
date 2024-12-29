defmodule Pokestar.Battle.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do

    field :winner_id, :id
    field :player_2_id, :id
    field :player_1_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:player_1_id, :player_2_id, :winner_id])
    |> validate_required([])
  end
end
