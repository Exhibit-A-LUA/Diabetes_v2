defmodule DiabetesV2Web.ProductLive.Index do
  use DiabetesV2Web, :live_view
  ## Required for Ash.Query.filter/2 in Ash 3.0
  @compile {:no_warn_underscore, Ash.Query}
  import Ash.Query

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

      <div class="mb-4 flex items-center">
        <.form for={@search_form} phx-change="search">
          <input
            type="text"
            name="query"
            value={@search_query}
            placeholder="Search products by name..."
            phx-debounce="300"
            class="border rounded px-3 py-1 mr-2 w-64"
          />
        </.form>
        <.button
          variant="primary"
          phx-click="clear_search"
          disabled={@search_query == ""}
        >
          Clear
        </.button>

        <div :if={@loading} class="ml-2">...</div>
      </div>

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

        <:action :let={{_id, product}}>
          <.link
            phx-click={JS.push("delete", value: %{id: product.id}) |> hide("##{product.id}")}
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

  def mount(_params, _session, socket) do
    offset = 0
    limit = 50
    query = ""

    page = fetch_page(socket.assigns[:current_user], query, offset, limit)

    {:ok,
     socket
     |> assign(:page_title, "Listing Products")
     |> assign_new(:current_user, fn -> nil end)
     |> assign(:offset, offset)
     |> assign(:limit, limit)
     |> assign(:search_query, query)
     |> assign(:search_form, to_form(%{}, as: :search))
     |> assign(:has_more, page.more?)
     |> assign(:loading, false)
     |> stream(:products, page.results, reset: true)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    socket = assign(socket, :loading, true)
    new_offset = 0
    page = fetch_page(socket.assigns.current_user, query, new_offset, socket.assigns.limit)
    socket = socket |> stream(:products, page.results, reset: true)

    {:noreply,
     socket
     |> assign(:loading, false)
     |> assign(:search_query, query)
     |> assign(:offset, new_offset)
     |> assign(:has_more, page.more?)}
  end

  def handle_event("clear_search", _params, socket) do
    handle_event("search", %{"query" => ""}, socket)
  end

  def handle_event("next_page", _params, socket) do
    new_offset = socket.assigns.offset + socket.assigns.limit

    page =
      fetch_page(
        socket.assigns.current_user,
        socket.assigns.search_query,
        new_offset,
        socket.assigns.limit
      )

    {:noreply,
     socket
     |> assign(:offset, new_offset)
     |> assign(:has_more, page.more?)
     |> stream(:products, page.results, reset: true)}
  end

  def handle_event("previous_page", _params, socket) do
    new_offset = max(socket.assigns.offset - socket.assigns.limit, 0)

    page =
      fetch_page(
        socket.assigns.current_user,
        socket.assigns.search_query,
        new_offset,
        socket.assigns.limit
      )

    {:noreply,
     socket
     |> assign(:offset, new_offset)
     |> assign(:has_more, page.more?)
     |> stream(:products, page.results, reset: true)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    product = Ash.get!(DiabetesV2.Products.Product, id, actor: socket.assigns.current_user)
    Ash.destroy!(product, actor: socket.assigns.current_user)

    page =
      fetch_page(
        socket.assigns.current_user,
        socket.assigns.search_query,
        socket.assigns.offset,
        socket.assigns.limit
      )

    {:noreply,
     socket
     |> stream_delete(:products, product)
     |> assign(:has_more, page.more?)
     |> stream(:products, page.results, reset: true)}
  end

  defp fetch_page(actor, query, offset, limit) do
    base =
      DiabetesV2.Products.Product
      |> Ash.Query.for_read(:with_types)

    query =
      if query == "" || query == nil do
        base
      else
        escaped = String.replace(query, "%", "\\%")
        filter(base, name: [ilike: "%#{escaped}%"])
      end

    Ash.read!(query,
      page: [limit: limit, offset: offset],
      actor: actor
    )
  end
end
