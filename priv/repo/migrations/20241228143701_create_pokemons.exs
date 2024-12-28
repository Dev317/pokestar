defmodule Pokestar.Repo.Migrations.CreatePokemons do
  use Ecto.Migration

  def change do
    create table(:pokemons) do
      add :name, :string
      add :type_1, :pokemon_type, null: false
      add :type_2, :pokemon_type

      timestamps(type: :utc_datetime)
    end
  end
end
