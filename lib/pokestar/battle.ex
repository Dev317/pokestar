defmodule Pokestar.Battle do
  @moduledoc """
  The Battle context.
  """

  import Ecto.Query, warn: false
  alias Pokestar.Repo

  alias Pokestar.Battle.Pokemon
  alias Pokestar.Battle.Match

  @doc """
  Returns the list of pokemons.

  ## Examples

      iex> list_pokemons()
      [%Pokemon{}, ...]

  """
  def list_pokemons do
    Repo.all(Pokemon)

    # pokemons
    # |>Enum.map(fn pokemon ->
    #   win_rate = player_win_rate(pokemon.id)
    #   Map.put(pokemon, :win_rate, win_rate)
    # end)
    # |> Enum.sort_by(fn pokemon -> pokemon.win_rate end, :desc)
  end

  @doc """
  Gets a single pokemon.

  Raises `Ecto.NoResultsError` if the Pokemon does not exist.

  ## Examples

      iex> get_pokemon!(123)
      %Pokemon{}

      iex> get_pokemon!(456)
      ** (Ecto.NoResultsError)

  """
  def get_pokemon!(id), do: Repo.get!(Pokemon, id)

  @doc """
  Creates a pokemon.

  ## Examples

      iex> create_pokemon(%{field: value})
      {:ok, %Pokemon{}}

      iex> create_pokemon(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_pokemon(attrs \\ %{}) do
    %Pokemon{}
    |> Pokemon.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a pokemon.

  ## Examples

      iex> update_pokemon(pokemon, %{field: new_value})
      {:ok, %Pokemon{}}

      iex> update_pokemon(pokemon, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_pokemon(%Pokemon{} = pokemon, attrs) do
    pokemon
    |> Pokemon.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a pokemon.

  ## Examples

      iex> delete_pokemon(pokemon)
      {:ok, %Pokemon{}}

      iex> delete_pokemon(pokemon)
      {:error, %Ecto.Changeset{}}

  """
  def delete_pokemon(%Pokemon{} = pokemon) do
    Repo.delete(pokemon)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pokemon changes.

  ## Examples

      iex> change_pokemon(pokemon)
      %Ecto.Changeset{data: %Pokemon{}}

  """
  def change_pokemon(%Pokemon{} = pokemon, attrs \\ %{}) do
    Pokemon.changeset(pokemon, attrs)
  end

  def create_match(attrs \\ %{}) do
    %Match{}
    |> Match.changeset(attrs)
    |> Repo.insert()
  end

  def update_match(match, attrs) do
    match
    |> Match.changeset(attrs)
    |> Repo.update()
  end

  def get_match!(id), do: Repo.get!(Match, id)

  def get_random_pokemon(excluded_id \\ nil) do
    Pokemon
    |> Repo.all()
    |> case do
      query when excluded_id != nil -> Enum.filter(query, fn pokemon -> pokemon.id != excluded_id end)
      query -> query
    end
    |> Enum.random()
  end

  def create_live_match(player_1_id, player_2_id) do
    case create_match(%{
      player_1_id: player_1_id,
      player_2_id: player_2_id
    }) do
      {:ok, match} -> match
      {:error, _reason} -> nil
    end
  end

  def player_win_rate(player_id) do
    matches_won_query =
      from(m in Match,
        where: m.winner_id == ^player_id,
        select: count(m.id)
      )

    matches_won = Repo.one(matches_won_query)

    total_matches_query =
      from(m in Match,
        where: (m.player_1_id == ^player_id or m.player_2_id == ^player_id) and not is_nil(m.winner_id),
        select: count(m.id)
      )

    total_matches = Repo.one(total_matches_query)

    if total_matches > 0 do
      (matches_won / total_matches) * 100
    else
      0.0
    end
  end
end
