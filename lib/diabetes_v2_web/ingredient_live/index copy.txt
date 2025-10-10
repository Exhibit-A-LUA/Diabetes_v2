defmodule DiabetesV2Web.IngredientLive.Index do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Ingredients
        <:actions>
          <.button variant="primary" navigate={~p"/ingredients/new"}>
            <.icon name="hero-plus" /> New Ingredient
          </.button>
        </:actions>
      </.header>

      <.table
        id="ingredients"
        rows={@streams.ingredients}
        row_click={fn {_id, ingredient} -> JS.navigate(~p"/ingredients/#{ingredient}") end}
      >
        <:col :let={{_id, ingredient}} label="Id">{ingredient.id}</:col>
        <:col :let={{_id, ingredient}} label="Prod Id">{ingredient.product_id}</:col>
        <:col :let={{_id, ingredient}} label="Ingred Id">{ingredient.ingredient_product_id}</:col>
        <:col :let={{_id, ingredient}} label="Grams">{ingredient.grams}</:col>
        <:col :let={{_id, ingredient}} label="Descr">{ingredient.weight_description}</:col>
        <:col :let={{_id, ingredient}} label="Incl">{ingredient.is_included}</:col>
        <:col :let={{_id, ingredient}} label="Opts">{ingredient.options}</:col>

        <:action :let={{_id, ingredient}}>
          <div class="sr-only">
            <.link navigate={~p"/ingredients/#{ingredient}"}>Show</.link>
          </div>

          <.link navigate={~p"/ingredients/#{ingredient}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, ingredient}}>
          <.link
            phx-click={JS.push("delete", value: %{id: ingredient.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Ingredients")
     |> assign_new(:current_user, fn -> nil end)
     |> stream(
       :ingredients,
       Ash.read!(DiabetesV2.Products.Ingredient, actor: socket.assigns[:current_user])
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ingredient = Ash.get!(DiabetesV2.Products.Ingredient, id, actor: socket.assigns.current_user)
    Ash.destroy!(ingredient, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :ingredients, ingredient)}
  end
end
