defmodule Pokestar.BattleFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Pokestar.Battle` context.
  """

  @doc """
  Generate a pokemon.
  """
  def pokemon_fixture(attrs \\ %{}) do
    {:ok, pokemon} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type_1: "some type_1",
        type_2: "some type_2"
      })
      |> Pokestar.Battle.create_pokemon()

    pokemon
  end
end
