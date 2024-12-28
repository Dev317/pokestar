# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Pokestar.Repo.insert!(%Pokestar.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Pokestar.Seeds.CsvSeeder

pokemon_file_path = "priv/repo/pokemons.csv"
CsvSeeder.seed_from_csv(pokemon_file_path, &CsvSeeder.insert_pokemon/1)

IO.puts("Pokemon seeding completed!")
