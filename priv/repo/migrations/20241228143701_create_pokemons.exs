defmodule Pokestar.Repo.Migrations.CreatePokemons do
  use Ecto.Migration

  def change do
    create table(:pokemons) do
      add :name, :string
      add :type_1, :string
      add :type_2, :string

      timestamps(type: :utc_datetime)
    end
  end
end
