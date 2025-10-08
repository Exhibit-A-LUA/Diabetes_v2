defmodule DiabetesV2Web.ProductLive.Index do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Products
        <:actions>
          <.button variant="primary" navigate={~p"/products/new"}>
            <.icon name="hero-plus" /> New Product
          </.button>
        </:actions>
      </.header>

      <.table
        id="products"
        rows={@streams.products}
        row_click={fn {_id, product} -> JS.navigate(~p"/products/#{product}") end}
      >
        <:col :let={{_id, product}} label="Id">{product.id}</:col>
        <:col :let={{_id, product}} label="Name">{product.name}</:col>
        <:col :let={{_id, product}} label="Main Type">
          {product.main_type && product.main_type.name}
        </:col>
        <:col :let={{_id, product}} label="Sub Type">
          {product.sub_type && product.sub_type.name}
        </:col>
        <:col :let={{_id, product}} label="Category">
          {product.category && product.category.name}
        </:col>

        <:action :let={{_id, product}}>
          <div class="sr-only">
            <.link navigate={~p"/products/#{product}"}>Show</.link>
          </div>

          <.link navigate={~p"/products/#{product}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, product}}>
          <.link
            phx-click={JS.push("delete", value: %{id: product.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
      <div class="mt-4 flex justify-between">
        <.button
          variant="primary"
          phx-click="previous_page"
          disabled={@offset == 0}
        >
          Previous
        </.button>
        <.button
          variant="primary"
          phx-click="next_page"
          disabled={not @has_more}
        >
          Next
        </.button>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    # Initialize pagination state
    offset = 0
    limit = 50

    # Fetch the initial page
    page_result =
      DiabetesV2.Products.Product
      |> Ash.Query.for_read(:with_types)
      |> Ash.read!(page: [limit: limit, offset: offset], actor: socket.assigns[:current_user])

    {:ok,
     socket
     |> assign(:page_title, "Listing Products")
     |> assign_new(:current_user, fn -> nil end)
     |> assign(:offset, offset)
     |> assign(:limit, limit)
     |> assign(:has_more, page_result.more?)
     |> stream(:products, page_result.results, reset: true)}
  end

  @impl true
  def handle_event("next_page", _params, socket) do
    # Calculate new offset
    new_offset = socket.assigns.offset + socket.assigns.limit

    # Fetch the next page
    page_result =
      DiabetesV2.Products.Product
      |> Ash.Query.for_read(:with_types)
      |> Ash.read!(
        page: [limit: socket.assigns.limit, offset: new_offset],
        actor: socket.assigns.current_user
      )

    {:noreply,
     socket
     |> assign(:offset, new_offset)
     |> assign(:has_more, page_result.more?)
     |> stream(:products, page_result.results, reset: true)}
  end

  @impl true
  def handle_event("previous_page", _params, socket) do
    # Calculate new offset (ensure it doesn't go negative)
    new_offset = max(socket.assigns.offset - socket.assigns.limit, 0)

    # Fetch the previous page
    page_result =
      DiabetesV2.Products.Product
      |> Ash.Query.for_read(:with_types)
      |> Ash.read!(
        page: [limit: socket.assigns.limit, offset: new_offset],
        actor: socket.assigns.current_user
      )

    {:noreply,
     socket
     |> assign(:offset, new_offset)
     |> assign(:has_more, page_result.more?)
     |> stream(:products, page_result.results, reset: true)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Ash.get!(DiabetesV2.Products.Product, id, actor: socket.assigns.current_user)
    Ash.destroy!(product, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
