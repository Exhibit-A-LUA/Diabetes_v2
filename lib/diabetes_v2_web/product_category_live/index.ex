defmodule DiabetesV2Web.ProductCategoryLive.Index do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Product categories
        <:actions>
          <.button variant="primary" navigate={~p"/product_categories/new"}>
            <.icon name="hero-plus" /> New Product category
          </.button>
        </:actions>
      </.header>

      <.table
        id="product_categories"
        rows={@streams.product_categories}
        row_click={
          fn {_id, product_category} -> JS.navigate(~p"/product_categories/#{product_category}") end
        }
      >
        <:col :let={{_id, product_category}} label="Id">{product_category.id}</:col>
        <:col :let={{_id, product_category}} label="Name">{product_category.name}</:col>
        <:col :let={{_id, product_category}} label="Description">{product_category.description}</:col>

        <:action :let={{_id, product_category}}>
          <div class="sr-only">
            <.link navigate={~p"/product_categories/#{product_category}"}>Show</.link>
          </div>

          <.link navigate={~p"/product_categories/#{product_category}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, product_category}}>
          <.link
            phx-click={JS.push("delete", value: %{id: product_category.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Product categories")
     |> assign_new(:current_user, fn -> nil end)
     |> stream(
       :product_categories,
       Ash.read!(DiabetesV2.Products.ProductCategory, actor: socket.assigns[:current_user])
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product_category =
      Ash.get!(DiabetesV2.Products.ProductCategory, id, actor: socket.assigns.current_user)

    Ash.destroy!(product_category, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :product_categories, product_category)}
  end
end
