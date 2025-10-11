defmodule DiabetesV2Web.IngredientLive.Form do
  use DiabetesV2Web, :live_view

  import DiabetesV2Web.ParamHelpers
  import Ash.Query

  alias DiabetesV2.Products.{Ingredient, Product}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage ingredient records in your database.</:subtitle>
        <:actions>
          <.button variant="primary" navigate={return_path(@return_to, @ingredient)}>
            Cancel
          </.button>
        </:actions>
      </.header>

      <div class="mt-6 space-y-6">
        <div class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-6 bg-white dark:bg-zinc-800">
          <.form
            for={@form}
            id="ingredient-form"
            phx-change="validate"
            phx-submit="save"
            class="space-y-4"
          >
            <!-- Product selection / display -->
            <%= if is_nil(@product_id) do %>
              <div class="space-y-2">
                <input
                  type="text"
                  name="product_search"
                  placeholder="Type to filter products..."
                  value={@product_search}
                  phx-change="filter_products"
                  phx-debounce="300"
                  class="w-full rounded border border-zinc-300 dark:border-zinc-600 p-2 bg-white dark:bg-zinc-700 text-zinc-900 dark:text-zinc-100"
                />

                <div class="border border-zinc-200 dark:border-zinc-700 rounded-md max-h-64 overflow-y-auto bg-white dark:bg-zinc-800">
                  <%= for {name, id} <- @filtered_products do %>
                    <div
                      phx-click="select_product"
                      phx-value-id={id}
                      class="cursor-pointer p-2 hover:bg-blue-50 dark:hover:bg-blue-900/20 flex justify-between items-center"
                    >
                      <span class="text-sm text-zinc-900 dark:text-zinc-100">{name}</span>
                      <span class="text-xs text-zinc-500 dark:text-zinc-400">ID: {id}</span>
                    </div>
                  <% end %>
                </div>
              </div>
            <% else %>
              <div class="mb-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded">
                <span class="text-sm text-zinc-600 dark:text-zinc-400">Adding Ingredient for:</span>
                <span class="ml-2 font-semibold">{product_name_from_id(@product_id)}</span>
              </div>
            <% end %>
            
    <!-- Ingredient selection -->
            <%= if is_nil(@ingredient_product_id) do %>
              <div class="space-y-2">
                <input
                  type="text"
                  name="ingredient_search"
                  placeholder="Type to filter ingredients..."
                  value={@ingredient_search}
                  phx-change="filter_ingredients"
                  phx-debounce="300"
                  class="w-full rounded border border-zinc-300 dark:border-zinc-600 p-2 bg-white dark:bg-zinc-700 text-zinc-900 dark:text-zinc-100"
                />

                <div class="border border-zinc-200 dark:border-zinc-700 rounded-md max-h-64 overflow-y-auto bg-white dark:bg-zinc-800">
                  <%= for {name, id} <- @filtered_ingredients do %>
                    <div
                      phx-click="select_ingredient"
                      phx-value-id={id}
                      class="cursor-pointer p-2 hover:bg-blue-50 dark:hover:bg-blue-900/20 flex justify-between items-center"
                    >
                      <span class="text-sm text-zinc-900 dark:text-zinc-100">{name}</span>
                      <span class="text-xs text-zinc-500 dark:text-zinc-400">ID: {id}</span>
                    </div>
                  <% end %>
                </div>
              </div>
            <% else %>
              <div class="mb-4 p-4 bg-green-50 dark:bg-green-900/20 rounded">
                <span class="text-sm text-zinc-600 dark:text-zinc-400">Selected Ingredient:</span>
                <span class="ml-2 font-semibold">{product_name_from_id(@ingredient_product_id)}</span>
              </div>
            <% end %>
            
    <!-- Other fields -->
            <div class="grid grid-cols-2 gap-4">
              <.input field={@form[:grams]} type="number" step="any" label="Grams" />
              <.input field={@form[:weight_description]} type="text" label="Description" />
            </div>

            <div class="flex items-center gap-6">
              <.input field={@form[:is_included]} type="checkbox" label="Included?" />
              <.input field={@form[:options]} type="text" label="Options" />
            </div>

            <div class="flex justify-end gap-4 pt-4">
              <.button phx-disable-with="Saving..." variant="primary">Save Ingredient</.button>
            </div>
          </.form>
        </div>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    product_id =
      case params["product_id"] do
        nil -> nil
        id -> String.to_integer(id)
      end

    ingredient =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(Ingredient, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(ingredient), do: "New", else: "Edit"
    page_title = action <> " " <> "Ingredient"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(ingredient: ingredient)
     |> assign(:product_id, product_id)
     |> assign(:ingredient_product_id, nil)
     |> assign(:page_title, page_title)
     |> assign(:product_search, "")
     |> assign(:ingredient_search, "")
     |> assign(:filtered_products, load_products(socket, ""))
     |> assign(:filtered_ingredients, load_products(socket, ""))
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"ingredient" => ingredient_params}, socket) do
    ingredient_params = transform_empty_strings(ingredient_params)

    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, ingredient_params))}
  end

  def handle_event("save", %{"ingredient" => ingredient_params}, socket) do
    ingredient_params =
      ingredient_params
      |> transform_empty_strings()
      |> Map.put_new("product_id", socket.assigns.product_id)
      |> Map.put_new("ingredient_product_id", socket.assigns.ingredient_product_id)

    case AshPhoenix.Form.submit(socket.assigns.form, params: ingredient_params) do
      {:ok, ingredient} ->
        notify_parent({:saved, ingredient})

        socket =
          socket
          |> put_flash(:info, "Ingredient #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, ingredient))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  @impl true
  def handle_event("filter_products", %{"product_search" => query}, socket) do
    products =
      Product
      |> filter(name: [ilike: "%#{query}%"])
      |> Ash.read!(actor: socket.assigns.current_user)

    {:noreply,
     socket
     |> assign(:filtered_products, Enum.map(products, &{&1.name, &1.id}))
     |> assign(:product_search, query)}
  end

  @impl true
  def handle_event("filter_ingredients", %{"ingredient_search" => query}, socket) do
    ingredients =
      Product
      |> filter(name: [ilike: "%#{query}%"])
      |> Ash.read!(actor: socket.assigns.current_user)

    {:noreply,
     socket
     |> assign(:filtered_ingredients, Enum.map(ingredients, &{&1.name, &1.id}))
     |> assign(:ingredient_search, query)}
  end

  # ---------------------------
  # Select Handlers
  # ---------------------------

  @impl true
  def handle_event("select_product", %{"id" => id}, socket) do
    product_id = String.to_integer(id)

    # Update form to prefill product_id if needed
    form =
      socket.assigns.form
      |> AshPhoenix.Form.validate(%{"product_id" => product_id})

    {:noreply,
     socket
     |> assign(:product_id, product_id)
     |> assign(:product_search, "")
     |> assign(:filtered_products, [])
     |> assign(:form, to_form(form))}
  end

  @impl true
  def handle_event("select_ingredient", %{"id" => id}, socket) do
    ingredient_product_id = String.to_integer(id)

    form =
      socket.assigns.form
      |> AshPhoenix.Form.validate(%{"ingredient_product_id" => ingredient_product_id})

    {:noreply,
     socket
     # Store it like product_id
     |> assign(:ingredient_product_id, ingredient_product_id)
     |> assign(:ingredient_search, "")
     |> assign(:filtered_ingredients, [])
     |> assign(:form, to_form(form))}
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp load_products(socket, query) do
    require Ash.Query
    pattern = "%" <> query <> "%"

    result =
      Product
      |> Ash.Query.filter(ilike(:name, ^pattern))
      |> Ash.read!(actor: socket.assigns.current_user)

    # Handle both cases: either a list or an Ash.Page struct
    products =
      case result do
        %Ash.Page.Offset{results: list} -> list
        %Ash.Page.Keyset{results: list} -> list
        list when is_list(list) -> list
      end

    Enum.map(products, &{&1.name, &1.id})
  end

  defp assign_form(socket) do
    ingredient = Map.get(socket.assigns, :ingredient)
    product_id = Map.get(socket.assigns, :product_id)

    form =
      if ingredient do
        # When editing an existing ingredient
        AshPhoenix.Form.for_update(ingredient, :update,
          as: "ingredient",
          domain: DiabetesV2.Products,
          actor: socket.assigns.current_user
        )
      else
        # When creating a new ingredient
        base_form =
          AshPhoenix.Form.for_create(Ingredient, :create,
            as: "ingredient",
            domain: DiabetesV2.Products,
            actor: socket.assigns.current_user
          )

        # Pre-fill product_id if we're adding an ingredient for a known product
        if product_id do
          AshPhoenix.Form.validate(base_form, %{"product_id" => product_id})
        else
          base_form
        end
      end

    assign(socket, form: to_form(form))
  end

  defp product_name_from_id(nil), do: ""

  defp product_name_from_id(id) do
    product = Ash.get!(Product, id, actor: nil)
    product.name
  end

  defp return_path("index", _ingredient), do: ~p"/ingredients"
  defp return_path("show", ingredient), do: ~p"/ingredients/#{ingredient.id}"
end
