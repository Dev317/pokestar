defmodule Pokestar.Repo do
  use Ecto.Repo,
    otp_app: :pokestar,
    adapter: Ecto.Adapters.Postgres
end
