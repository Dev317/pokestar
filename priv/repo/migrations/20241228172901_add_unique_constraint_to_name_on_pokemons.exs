defmodule Pokestar.Repo.Migrations.AddUniqueConstraintToNameOnPokemons do
  use Ecto.Migration

  def change do
    create unique_index(:pokemons, [:name])
  end
end
