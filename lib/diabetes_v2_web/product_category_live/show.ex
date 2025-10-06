defmodule DiabetesV2Web.ProductCategoryLive.Show do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product category {@product_category.id}
        <:subtitle>This is a product_category record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/product_categories"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/product_categories/#{@product_category}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit Product category
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@product_category.id}</:item>
        <:item title="Name">{@product_category.name}</:item>
        <:item title="Description">{@product_category.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Product category")
     |> assign(
       :product_category,
       Ash.get!(DiabetesV2.Products.ProductCategory, id, actor: socket.assigns.current_user)
     )}
  end
end
