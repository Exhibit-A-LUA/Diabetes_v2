defmodule DiabetesV2Web.IngredientLive.Index do
  use DiabetesV2Web, :live_view

  alias DiabetesV2.Products.Ingredient

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Ingredients
        <:subtitle>Products and their ingredient compositions</:subtitle>
        <:actions>
          <.button variant="primary" navigate={~p"/ingredients/new"}>
            <.icon name="hero-plus" /> New Ingredient
          </.button>
        </:actions>
      </.header>

      <div class="mt-8 space-y-6">
        <%= for {product, ingredients} <- @products_with_ingredients do %>
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
              <.button navigate={~p"/ingredients/new?product_id=#{product.id}"}>
                Add Ingredient
              </.button>
            </div>

            <div class="space-y-2">
              <%= for ingredient <- ingredients do %>
                <div class="flex items-center justify-between p-3 bg-zinc-50 dark:bg-zinc-900 rounded">
                  <div class="flex flex-col gap-1">
                    <span class="text-sm font-medium text-zinc-900 dark:text-zinc-100">
                      Ingredient Product ID: {ingredient.ingredient_product_id}
                    </span>
                    <span class="text-sm text-zinc-600 dark:text-zinc-400">
                      Grams: {ingredient.grams}, Description: {ingredient.weight_description || "-"}, Included: {ingredient.is_included}
                    </span>
                  </div>
                  <div class="flex gap-2">
                    <.link
                      navigate={~p"/ingredients/#{ingredient.id}/edit"}
                      class="text-sm text-blue-600 hover:text-blue-700 dark:text-blue-400"
                    >
                      Edit
                    </.link>
                    <.link
                      phx-click={JS.push("delete", value: %{id: ingredient.id})}
                      data-confirm="Are you sure you want to delete this ingredient?"
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
     |> assign(:page_title, "Ingredients")
     |> assign_new(:current_user, fn -> nil end)
     |> load_products_with_ingredients()}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ingredient =
      Ash.get!(Ingredient, id, actor: socket.assigns.current_user)

    Ash.destroy!(ingredient, actor: socket.assigns.current_user)

    {:noreply,
     socket
     |> put_flash(:info, "Ingredient deleted successfully")
     |> load_products_with_ingredients()}
  end

  defp load_products_with_ingredients(socket) do
    # Load all ingredients with their products
    ingredients =
      Ash.read!(Ingredient,
        load: [:product],
        actor: socket.assigns.current_user
      )

    # Group by product
    products_with_ingredients =
      ingredients
      |> Enum.group_by(& &1.product)
      |> Enum.sort_by(fn {product, _ingredients} -> product.name end)

    assign(socket, :products_with_ingredients, products_with_ingredients)
  end
end
