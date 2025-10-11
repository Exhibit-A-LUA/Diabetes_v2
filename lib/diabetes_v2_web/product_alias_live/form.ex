defmodule DiabetesV2Web.ProductAliasLive.Form do
  use DiabetesV2Web, :live_view

  import DiabetesV2Web.ParamHelpers

  import Ash.Query

  alias DiabetesV2.Products.{ProductAlias, Product}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Add an alternative name for a product</:subtitle>
      </.header>

      <.form
        for={@form}
        id="product_alias-form"
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <%= if is_nil(@selected_product) do %>
          <div class="space-y-2">
            <!-- Search input -->
            <input
              type="text"
              name="search"
              label="Search Products"
              placeholder="Type to filter products..."
              value={@product_search}
              phx-change="filter_products"
              phx-debounce="300"
              value={@product_search}
            />
            
    <!-- Product select -->
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
            <span class="text-sm text-zinc-600 dark:text-zinc-400">Adding alias for:</span>
            <span class="ml-2 font-semibold">{@selected_product.name}</span>
          </div>
        <% end %>
        <!-- Alias name -->
        <.input field={@form[:name]} type="text" label="Alias Name" />

        <div class="flex justify-end gap-4 pt-6">
          <.button phx-disable-with="Saving..." variant="primary">
            Save Alias
          </.button>
          <.button navigate={return_path(@return_to, @product_alias)}>Cancel</.button>
        </div>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    product_alias =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(ProductAlias, id, actor: socket.assigns.current_user, load: [:product])
      end

    product_id = params["product_id"]

    selected_product =
      if product_id do
        Ash.get!(Product, product_id, actor: socket.assigns.current_user)
      else
        product_alias && product_alias.product
      end

    action = if is_nil(product_alias), do: "New", else: "Edit"
    page_title = action <> " Product Alias"

    newsocket =
      socket
      |> assign(:return_to, return_to(params["return_to"]))
      |> assign(:product_alias, product_alias)
      |> assign(:selected_product, selected_product)
      |> assign(:page_title, page_title)
      |> assign(:product_search, "")
      |> assign(:filtered_products, load_products(socket, ""))

    {:ok, assign_form(newsocket)}
  end

  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"product_alias" => product_alias_params}, socket) do
    params = normalize_form_params(product_alias_params)
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: to_form(form))}
  end

  @impl true
  def handle_event("save", params, socket) do
    product_alias_params = params["product_alias"] || params
    transformed_params = normalize_form_params(product_alias_params)

    # Add this: Include product_id if we have a selected_product
    final_params =
      if socket.assigns[:selected_product] && is_nil(transformed_params["product_id"]) do
        Map.put(transformed_params, "product_id", socket.assigns.selected_product.id)
      else
        transformed_params
      end

    case AshPhoenix.Form.submit(socket.assigns.form, params: final_params) do
      {:ok, product_alias} ->
        if socket.parent_pid, do: notify_parent({:saved, product_alias})

        socket =
          socket
          |> put_flash(:info, "Product alias saved successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, product_alias))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  @impl true
  def handle_event("filter_products", %{"search" => query}, socket) do
    products =
      DiabetesV2.Products.Product
      |> filter(name: [ilike: "%#{query}%"])
      |> Ash.read!(actor: socket.assigns.current_user)

    {:noreply,
     socket
     |> assign(:filtered_products, Enum.map(products, &{&1.name, &1.id}))
     |> assign(:product_search, query)}
  end

  # --------------------------
  # Helpers
  # --------------------------

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
    product_alias = Map.get(socket.assigns, :product_alias)
    selected_product = Map.get(socket.assigns, :selected_product)

    form =
      if product_alias do
        AshPhoenix.Form.for_update(product_alias, :update,
          as: "product_alias",
          domain: DiabetesV2.Products,
          actor: socket.assigns.current_user
        )
      else
        base_form =
          AshPhoenix.Form.for_create(ProductAlias, :create,
            as: "product_alias",
            domain: DiabetesV2.Products,
            actor: socket.assigns.current_user
          )

        # If we have a selected_product, pre-fill the product_id
        if selected_product do
          AshPhoenix.Form.validate(base_form, %{"product_id" => selected_product.id})
        else
          base_form
        end
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _product_alias), do: ~p"/product_aliases"
end
