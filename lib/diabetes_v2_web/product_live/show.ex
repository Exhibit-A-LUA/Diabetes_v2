defmodule DiabetesV2Web.ProductLive.Show do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product {@product.id}
        <:subtitle>This is a product record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/products"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/products/#{@product}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Edit Product
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@product.id}</:item>
        <:item title="Name">{@product.name}</:item>
        <:item title="Main Type">{@product.main_type && @product.main_type.name}</:item>
        <:item title="Sub Type">{@product.sub_type && @product.sub_type.name}</:item>
        <:item title="Category">{@product.category && @product.category.name}</:item>
        <:item title="Description">{@product.description}</:item>
        <:item title="Serving (g)">{@product.serving_g}</:item>
        <:item title="Calories (kcal)">{@product.calories_kcal}</:item>
        <:item title="Carbs (g)">{@product.carbs_g}</:item>
        <:item title="Protein (g)">{@product.protein_g}</:item>
        <:item title="Fat (g)">{@product.fat_g}</:item>
        <:item title="Fibre (g)">{@product.fibre_g}</:item>
        <:item title="Cholesterol (mg)">{@product.cholesterol_mg}</:item>
        <:item title="Glycemic Index">{@product.glycemic_index}</:item>
      </.list>
    </Layouts.app>
    """
  end

  # @impl true
  # def mount(%{"id" => id}, _session, socket) do
  #   {:ok,
  #    socket
  #    |> assign(:page_title, "Show Product")
  #    |> assign(
  #      :product,
  #      Ash.get!(DiabetesV2.Products.Product, id, actor: socket.assigns.current_user)
  #    )}
  # end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    require Ash.Query

    product =
      DiabetesV2.Products.Product
      |> Ash.Query.for_read(:with_types)
      |> Ash.Query.filter(id == ^id)
      |> Ash.read_one!(actor: socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:page_title, "Show Product")
     |> assign(:product, product)}
  end
end
