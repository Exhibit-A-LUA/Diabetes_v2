defmodule DiabetesV2Web.IngredientLive.Index do
  use DiabetesV2Web, :live_view

  alias DiabetesV2.Products.Ingredient

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Ingredients
        <:subtitle>Products with Ingredient</:subtitle>
        <:actions>
          <.button variant="primary" navigate={~p"/ingredients/new"}>
            <.icon name="hero-plus" /> New Ingredient
          </.button>
        </:actions>
      </.header>

      <div class="mb-4 flex items-center">
        <.form for={@search_form} phx-change="search">
          <input
            type="text"
            name="query"
            value={@search_query}
            placeholder="Search products with ingredients..."
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
                <div class={[
                  "relative flex items-center justify-between p-3 rounded-lg border transition",
                  ingredient.is_included &&
                    "bg-green-50 dark:bg-green-900/20 border-green-200 dark:border-green-800",
                  !ingredient.is_included &&
                    "bg-zinc-100 dark:bg-zinc-900/50 border-zinc-300 dark:border-zinc-700 opacity-80 scale-[0.95]"
                ]}>
                  <!-- Left-corner EXCLUDED ribbon -->
                  <%= if !ingredient.is_included do %>
                    <div class="absolute top-0 left-0 overflow-hidden w-20 h-20 pointer-events-none">
                      <div class="absolute transform -rotate-45 bg-gradient-to-r from-red-600 to-red-400 text-white text-[10px] font-semibold text-center shadow-md py-[1px] px-0 w-32 -left-10 top-3">
                        EXCLUDED
                      </div>
                    </div>
                  <% end %>

                  <div class="flex flex-col gap-1">
                    <span class={[
                      "text-sm font-medium",
                      (ingredient.is_included &&
                         "text-zinc-900 dark:text-zinc-100") ||
                        "text-zinc-500 dark:text-zinc-400 line-through"
                    ]}>
                      Ingredient: {(ingredient.ingredient_product &&
                                      ingredient.ingredient_product.name) || "—"}
                    </span>
                    <span class="text-sm text-zinc-600 dark:text-zinc-400">
                      Grams: {ingredient.grams} ({ingredient.weight_description || "-"}),
                      Options: {ingredient.options || "-"}
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
     |> assign(:search_query, "")
     |> assign(:search_form, to_form(%{}))
     |> assign(:loading, false)
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

  @impl true
  def handle_event("search", %{"query" => query}, socket) do
    {:noreply,
     socket
     |> assign(:search_query, query)
     |> load_products_with_ingredients(query)}
  end

  @impl true
  def handle_event("clear_search", _params, socket) do
    {:noreply,
     socket
     |> assign(:search_query, "")
     |> load_products_with_ingredients("")}
  end

  defp load_products_with_ingredients(socket, query \\ "") do
    ingredients =
      Ash.read!(Ingredient,
        load: [:product, :ingredient_product],
        actor: socket.assigns.current_user
      )
      |> Enum.filter(fn ingredient ->
        if query == "" do
          true
        else
          product_name = ingredient.product.name
          String.contains?(String.downcase(product_name), String.downcase(query))
        end
      end)

    products_with_ingredients =
      ingredients
      |> Enum.group_by(& &1.product)
      |> Enum.sort_by(fn {product, _ingredients} -> product.name end)

    assign(socket, :products_with_ingredients, products_with_ingredients)
  end
end
