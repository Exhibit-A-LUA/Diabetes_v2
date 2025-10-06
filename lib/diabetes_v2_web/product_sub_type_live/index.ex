defmodule DiabetesV2Web.ProductSubTypeLive.Index do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Listing Product sub types
        <:actions>
          <.button variant="primary" navigate={~p"/product_sub_types/new"}>
            <.icon name="hero-plus" /> New Product sub type
          </.button>
        </:actions>
      </.header>

      <.table
        id="product_sub_types"
        rows={@streams.product_sub_types}
        row_click={
          fn {_id, product_sub_type} -> JS.navigate(~p"/product_sub_types/#{product_sub_type}") end
        }
      >
        <:col :let={{_id, product_sub_type}} label="Id">{product_sub_type.id}</:col>
        <:col :let={{_id, product_sub_type}} label="Name">{product_sub_type.name}</:col>
        <:col :let={{_id, product_sub_type}} label="Description">{product_sub_type.description}</:col>

        <:action :let={{_id, product_sub_type}}>
          <div class="sr-only">
            <.link navigate={~p"/product_sub_types/#{product_sub_type}"}>Show</.link>
          </div>

          <.link navigate={~p"/product_sub_types/#{product_sub_type}/edit"}>Edit</.link>
        </:action>

        <:action :let={{id, product_sub_type}}>
          <.link
            phx-click={JS.push("delete", value: %{id: product_sub_type.id}) |> hide("##{id}")}
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
     |> assign(:page_title, "Listing Product sub types")
     |> assign_new(:current_user, fn -> nil end)
     |> stream(
       :product_sub_types,
       Ash.read!(DiabetesV2.Products.ProductSubType, actor: socket.assigns[:current_user])
     )}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product_sub_type =
      Ash.get!(DiabetesV2.Products.ProductSubType, id, actor: socket.assigns.current_user)

    Ash.destroy!(product_sub_type, actor: socket.assigns.current_user)

    {:noreply, stream_delete(socket, :product_sub_types, product_sub_type)}
  end
end
