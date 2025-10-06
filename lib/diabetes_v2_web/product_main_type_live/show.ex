defmodule DiabetesV2Web.ProductMainTypeLive.Show do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product main type {@product_main_type.id}
        <:subtitle>This is a product_main_type record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/product_main_types"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/product_main_types/#{@product_main_type}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit Product main type
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@product_main_type.id}</:item>
        <:item title="Name">{@product_main_type.name}</:item>
        <:item title="Description">{@product_main_type.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Product main type")
     |> assign(
       :product_main_type,
       Ash.get!(DiabetesV2.Products.ProductMainType, id, actor: socket.assigns.current_user)
     )}
  end
end
