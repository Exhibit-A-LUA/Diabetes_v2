defmodule DiabetesV2Web.ProductAliasLive.Index do
  use DiabetesV2Web, :live_view

  alias DiabetesV2.Products.ProductAlias

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product Aliases
        <:subtitle>Products and their alternative names</:subtitle>
        <:actions>
          <.button variant="primary" navigate={~p"/product_aliases/new"}>
            <.icon name="hero-plus" /> New Alias
          </.button>
        </:actions>
      </.header>

      <div class="mt-8 space-y-6">
        <%= for {product, aliases} <- @products_with_aliases do %>
          <div class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800">
            <div class="flex items-start justify-between mb-3">
              <div>
                <h3 class="text-lg font-semibold text-zinc-900 dark:text-zinc-100">
                  {product.name}
                </h3>
                <p class="text-sm text-zinc-600 dark:text-zinc-400">
                  ID: {product.id}
                </p>
              </div>
              <.button navigate={~p"/product_aliases/new?product_id=#{product.id}"}>
                Add Alias
              </.button>
            </div>

            <div class="space-y-2">
              <%= for alias <- aliases do %>
                <div class="flex items-center justify-between p-3 bg-zinc-50 dark:bg-zinc-900 rounded">
                  <div class="flex items-center gap-3">
                    <span class="text-sm font-medium text-zinc-900 dark:text-zinc-100">
                      {alias.name}
                    </span>
                  </div>
                  <div class="flex gap-2">
                    <.link
                      navigate={~p"/product_aliases/#{alias.id}/edit"}
                      class="text-sm text-blue-600 hover:text-blue-700 dark:text-blue-400"
                    >
                      Edit
                    </.link>
                    <.link
                      phx-click={JS.push("delete", value: %{id: alias.id})}
                      data-confirm="Are you sure you want to delete this alias?"
                      class="text-sm text-red-600 hover:text-red-700 dark:text-red-400"
                    >
                      Delete
                    </.link>
                  </div>
                </div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Product Aliases")
     |> assign_new(:current_user, fn -> nil end)
     |> load_products_with_aliases()}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product_alias = Ash.get!(ProductAlias, id, actor: socket.assigns.current_user)
    Ash.destroy!(product_alias, actor: socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, "Alias deleted successfully")
     |> load_products_with_aliases()}
  end

  defp load_products_with_aliases(socket) do
    # Load all aliases with their products
    aliases =
      Ash.read!(ProductAlias,
        load: [:product],
        actor: socket.assigns.current_user
      )

    # Group by product
    products_with_aliases =
      aliases
      |> Enum.group_by(& &1.product)
      |> Enum.sort_by(fn {product, _aliases} -> product.name end)

    assign(socket, :products_with_aliases, products_with_aliases)
  end
end
