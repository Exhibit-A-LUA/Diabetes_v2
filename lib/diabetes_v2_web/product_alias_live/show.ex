defmodule DiabetesV2Web.ProductAliasLive.Show do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product alias {@product_alias.id}
        <:subtitle>This is a product_alias record from your database.</:subtitle>

        <:actions>
          <.button navigate={~p"/product_aliases"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/product_aliases/#{@product_alias}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit Product alias
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Id">{@product_alias.id}</:item>
        <:item title="Name">{@product_alias.name}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Product alias")
     |> assign(
       :product_alias,
       Ash.get!(DiabetesV2.Products.ProductAlias, id, actor: socket.assigns.current_user)
     )}
  end
end
