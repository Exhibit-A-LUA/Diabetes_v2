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
      </.header>

      <.form
        for={@form}
        id="ingredient-form"
        phx-change="validate"
        phx-submit="save"
      >
        <%= if is_nil(@product_id) do %>
          <div class="space-y-2">
            <!-- Product search -->
            <input
              type="text"
              name="product_search"
              placeholder="Type to filter products..."
              value={@product_search}
              phx-change="filter_products"
              phx-debounce="300"
            />

            <.input
              field={@form[:product_id]}
              type="select"
              label="Product"
              options={@filtered_products}
              prompt="Select a product"
            />
          </div>
        <% else %>
          <div class="mb-4 p-4 bg-blue-50 dark:bg-blue-900/20 rounded">
            <span class="text-sm text-zinc-600 dark:text-zinc-400">Adding Ingredient for:</span>
            <span class="ml-2 font-semibold">{product_name_from_id(@product_id)}</span>
          </div>
        <% end %>
        <div class="space-y-2">
          <input
            type="text"
            name="ingredient_search"
            placeholder="Type to filter ingredients..."
            value={@ingredient_search}
            phx-change="filter_ingredients"
            phx-debounce="300"
          />

          <.input
            field={@form[:ingredient_product_id]}
            type="select"
            label="Ingredient"
            options={@filtered_ingredients}
            prompt="Select an ingredient"
          />
        </div>

        <.input field={@form[:grams]} type="number" step="any" label="Grams" />
        <.input field={@form[:weight_description]} type="text" label="Descr" />
        <.input field={@form[:is_included]} type="checkbox" label="Included?" />
        <.input field={@form[:options]} type="text" label="Opts" />
        <.button phx-disable-with="Saving..." variant="primary">Save Ingredient</.button>
        <.button navigate={return_path(@return_to, @ingredient)}>Cancel</.button>
      </.form>
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
        id -> Ash.get!(DiabetesV2.Products.Ingredient, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(ingredient), do: "New", else: "Edit"
    page_title = action <> " " <> "Ingredient"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(ingredient: ingredient)
     |> assign(:product_id, product_id)
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
      DiabetesV2.Products.Product
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
      DiabetesV2.Products.Product
      |> filter(name: [ilike: "%#{query}%"])
      |> Ash.read!(actor: socket.assigns.current_user)

    {:noreply,
     socket
     |> assign(:filtered_ingredients, Enum.map(ingredients, &{&1.name, &1.id}))
     |> assign(:ingredient_search, query)}
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

  defp assign_form(%{assigns: %{ingredient: ingredient}} = socket) do
    form =
      if ingredient do
        AshPhoenix.Form.for_update(ingredient, :update,
          as: "ingredient",
          actor: socket.assigns.current_user
        )
      else
        changes = %{}

        changes =
          if socket.assigns.product_id,
            do: Map.put(changes, :product_id, socket.assigns.product_id),
            else: changes

        AshPhoenix.Form.for_create(DiabetesV2.Products.Ingredient, :create,
          as: "ingredient",
          actor: socket.assigns.current_user,
          change: changes
        )
      end

    assign(socket, form: to_form(form))
  end

  defp product_name_from_id(nil), do: ""

  defp product_name_from_id(id) do
    case Ash.get(DiabetesV2.Products.Product, id, actor: nil) do
      product -> product.name
    end
  end

  defp return_path("index", _ingredient), do: ~p"/ingredients"
  defp return_path("show", ingredient), do: ~p"/ingredients/#{ingredient.id}"
end
