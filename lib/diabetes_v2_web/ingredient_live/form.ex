defmodule DiabetesV2Web.IngredientLive.Form do
  use DiabetesV2Web, :live_view

  import DiabetesV2Web.ParamHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage ingredient records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="ingredient-form"
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:product_id]} type="text" label="Prod Id" />
        <.input field={@form[:ingredient_product_id]} type="text" label="Ingred Id" />
        <.input field={@form[:grams]} type="number" step="any" label="Grams" />
        <.input field={@form[:weight_description]} type="text" label="Descr" />
        <.input field={@form[:is_included]} type="checkbox" label="Included?" />
        <.input field={@form[:options]} type="text" label="Opts" />
        <.button phx-disable-with="Saving..." variant="primary">Save Ingredient</.button>
        <.button navigate={return_path(@return_to, @ingredient)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    ingredient =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(DiabetesV2.Products.Ingredient, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(ingredient), do: "New", else: "Edit"
    page_title = action <> " " <> "Ingredient"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(ingredient: ingredient)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"ingredient" => ingredient_params}, socket) do
    ingredient_params = transform_empty_strings(ingredient_params)

    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, ingredient_params))}
  end

  def handle_event("save", %{"ingredient" => ingredient_params}, socket) do
    ingredient_params = transform_empty_strings(ingredient_params)

    case AshPhoenix.Form.submit(socket.assigns.form, params: ingredient_params) do
      {:ok, ingredient} ->
        notify_parent({:saved, ingredient})

        socket =
          socket
          |> put_flash(:info, "Ingredient #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, ingredient))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{ingredient: ingredient}} = socket) do
    form =
      if ingredient do
        AshPhoenix.Form.for_update(ingredient, :update,
          as: "ingredient",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(DiabetesV2.Products.Ingredient, :create,
          as: "ingredient",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _ingredient), do: ~p"/ingredients"
  defp return_path("show", ingredient), do: ~p"/ingredients/#{ingredient.id}"
end
