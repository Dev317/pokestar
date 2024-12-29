defmodule Pokestar.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :winner_id, references(:pokemons, on_delete: :nothing)
      add :player_2_id, references(:pokemons, on_delete: :nothing)
      add :player_1_id, references(:pokemons, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:winner_id])
    create index(:matches, [:player_2_id])
    create index(:matches, [:player_1_id])
  end
end
