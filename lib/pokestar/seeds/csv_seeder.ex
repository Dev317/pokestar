defmodule Pokestar.Seeds.CsvSeeder do
  alias Pokestar.Repo
  alias Pokestar.Battle.Pokemon

  def seed_from_csv(file_path, insert_fn) do
    file_path
    |> File.stream!()
    |> CSV.decode([headers: true])
    |> Enum.each(&insert_fn.(&1))
  end

  def insert_pokemon({:ok, %{"name" => name, "type_1" => type_1, "type_2" => type_2}}) do
    attrs = %{
      name: name,
      type_1: type_1
        |> String.downcase()
        |> String.to_atom(),
      type_2: case type_2 == "" do
        true -> nil
        false -> type_2
          |> String.downcase()
          |> String.to_atom()
      end
    }

    %Pokemon{}
    |> Pokemon.changeset(attrs)
    |> Repo.insert!(
      on_conflict: {:replace, [:type_1, :type_2, :updated_at]},
      conflict_target: [:name]
    )
  end

  def insert_pokemon({:error, reason}) do
    IO.puts("Error processing data: #{inspect(reason)}")
  end
end
