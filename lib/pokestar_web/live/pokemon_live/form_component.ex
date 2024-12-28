defmodule PokestarWeb.PokemonLive.FormComponent do
  use PokestarWeb, :live_component

  alias Pokestar.Battle
  alias Pokestar.Enums.Battle.PokemonSchema

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage pokemon records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="pokemon-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:type_1]}
          type="select"
          label="Type 1"
          options={Enum.map(PokemonSchema.pokemon_type_enum(), fn type -> {Atom.to_string(type), type} end)} 
        />
        <.input field={@form[:type_2]} 
          type="select" 
          label="Type 2" 
          options={
            [
              {"--", nil} | Enum.map(PokemonSchema.pokemon_type_enum(), fn type -> {Atom.to_string(type), type} end)
            ]
          }
        />
        <:actions>
          <.button phx-disable-with="Saving...">Save Pokemon</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{pokemon: pokemon} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Battle.change_pokemon(pokemon))
     end)}
  end

  @impl true
  def handle_event("validate", %{"pokemon" => pokemon_params}, socket) do
    changeset = Battle.change_pokemon(socket.assigns.pokemon, pokemon_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pokemon" => pokemon_params}, socket) do
    save_pokemon(socket, socket.assigns.action, pokemon_params)
  end

  defp save_pokemon(socket, :edit, pokemon_params) do
    case Battle.update_pokemon(socket.assigns.pokemon, pokemon_params) do
      {:ok, pokemon} ->
        notify_parent({:saved, pokemon})

        {:noreply,
         socket
         |> put_flash(:info, "Pokemon updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pokemon(socket, :new, pokemon_params) do
    case Battle.create_pokemon(pokemon_params) do
      {:ok, pokemon} ->
        notify_parent({:saved, pokemon})

        {:noreply,
         socket
         |> put_flash(:info, "Pokemon created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
