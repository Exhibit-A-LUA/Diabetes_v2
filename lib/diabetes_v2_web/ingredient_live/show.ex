defmodule DiabetesV2Web.IngredientLive.Show do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Ingredient {@ingredient.id}
        <:subtitle>This is a ingredient record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/ingredients"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/ingredients/#{@ingredient}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit Ingredient
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@ingredient.id}</:item>
        <:item title="Prod Id">{@ingredient.product_id}</:item>
        <:item title="Ingred Id">{@ingredient.ingredient_product_id}</:item>
        <:item title="Grams">{@ingredient.grams}</:item>
        <:item title="Descr">{@ingredient.weight_description}</:item>
        <:item title="Incl">{@ingredient.is_included}</:item>
        <:item title="Opts">{@ingredient.options}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Ingredient")
     |> assign(
       :ingredient,
       Ash.get!(DiabetesV2.Products.Ingredient, id, actor: socket.assigns.current_user)
     )}
  end
end
