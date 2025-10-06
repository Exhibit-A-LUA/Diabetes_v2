defmodule DiabetesV2Web.ProductMainTypeLive.Index do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Product main types
        <:actions>
          <.button variant="primary" navigate={~p"/product_main_types/new"}>
            <.icon name="hero-plus" /> New Product main type
          </.button>
        </:actions>
      </.header>

      <.table
        id="product_main_types"
        rows={@streams.product_main_types}
        row_click={
          fn {_id, product_main_type} -> JS.navigate(~p"/product_main_types/#{product_main_type}") end
        }
      >
        <:col :let={{_id, product_main_type}} label="Id">{product_main_type.id}</:col>
        <:col :let={{_id, product_main_type}} label="Name">{product_main_type.name}</:col>
        <:col :let={{_id, product_main_type}} label="Description">
          {product_main_type.description}
        </:col>

        <:action :let={{_id, product_main_type}}>
          <div class="sr-only">
            <.link navigate={~p"/product_main_types/#{product_main_type}"}>Show</.link>
          </div>

          <.link navigate={~p"/product_main_types/#{product_main_type}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, product_main_type}}>
          <.link
            phx-click={JS.push("delete", value: %{id: product_main_type.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Product main types")
     |> assign_new(:current_user, fn -> nil end)
     |> stream(
       :product_main_types,
       Ash.read!(DiabetesV2.Products.ProductMainType, actor: socket.assigns[:current_user])
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product_main_type =
      Ash.get!(DiabetesV2.Products.ProductMainType, id, actor: socket.assigns.current_user)

    Ash.destroy!(product_main_type, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :product_main_types, product_main_type)}
  end
end
