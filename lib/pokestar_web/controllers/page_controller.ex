defmodule PokestarWeb.PageController do
  use PokestarWeb, :controller

  def home(conn, _params) do
    redirect(conn, to: "/pokemons")
  end
end
