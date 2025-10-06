defmodule DiabetesV2Web.ProductSubTypeLive.Show do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product sub type {@product_sub_type.id}
        <:subtitle>This is a product_sub_type record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/product_sub_types"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/product_sub_types/#{@product_sub_type}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit Product sub type
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@product_sub_type.id}</:item>
        <:item title="Name">{@product_sub_type.name}</:item>
        <:item title="Description">{@product_sub_type.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Product sub type")
     |> assign(
       :product_sub_type,
       Ash.get!(DiabetesV2.Products.ProductSubType, id, actor: socket.assigns.current_user)
     )}
  end
end
