defmodule Pokestar.Repo.Migrations.CreatePokemonEnumType do
  use Ecto.Migration

  def up do
    execute("""
    CREATE TYPE pokemon_type AS ENUM (
      'grass', 'fire', 'water', 'bug', 'normal',
      'poison', 'electric', 'ground', 'fairy', 'fighting',
      'psychic', 'rock', 'ghost', 'ice', 'dragon',
      'dark', 'steel', 'flying'
    );
    """)
  end

  def down do
    execute("""
    DROP TYPE pokemon_type;
    """)
  end
end
