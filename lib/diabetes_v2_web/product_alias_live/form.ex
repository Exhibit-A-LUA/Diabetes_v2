defmodule DiabetesV2Web.ProductAliasLive.Form do
  use DiabetesV2Web, :live_view

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
        <.input
          field={@form[:product_id]}
          type="select"
          label="Product"
          options={@product_options}
          prompt="Select a product"
        />

        <.input field={@form[:name]} type="text" label="Alias Name" />

        <div class="flex justify-end gap-4 pt-6">
          <.button phx-disable-with="Saving..." variant="primary">
            Save Alias
          </.button>
          <.button navigate={return_path(@return_to, @product_alias)}>
            Cancel
          </.button>
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

    action = if is_nil(product_alias), do: "New", else: "Edit"
    page_title = action <> " Product Alias"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(product_alias: product_alias)
     |> assign(:page_title, page_title)
     |> load_product_options()
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"product_alias" => product_alias_params}, socket) do
    params = transform_empty_strings(product_alias_params)
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: to_form(form))}
  end

  def handle_event("save", params, socket) do
    product_alias_params = params["product_alias"] || params
    transformed_params = transform_empty_strings(product_alias_params)

    case AshPhoenix.Form.submit(socket.assigns.form, params: transformed_params) do
      {:ok, product_alias} ->
        if socket.parent_pid do
          notify_parent({:saved, product_alias})
        end

        socket =
          socket
          |> put_flash(:info, "Product alias saved successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, product_alias))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp load_product_options(socket) do
    product_options =
      Ash.read!(Product, actor: socket.assigns.current_user)
      |> Enum.map(&{&1.name, &1.id})
      |> Enum.sort()

    assign(socket, :product_options, product_options)
  end

  defp assign_form(%{assigns: %{product_alias: product_alias}} = socket) do
    form =
      if product_alias do
        AshPhoenix.Form.for_update(product_alias, :update,
          as: "product_alias",
          domain: DiabetesV2.Products,
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(ProductAlias, :create,
          as: "product_alias",
          domain: DiabetesV2.Products,
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp transform_empty_strings(params) when is_map(params) do
    Enum.reduce(params, %{}, fn {key, value}, acc ->
      Map.put(acc, key, if(value == "", do: nil, else: value))
    end)
  end

  defp return_path("index", _product_alias), do: ~p"/product_aliases"
  defp return_path("show", product_alias), do: ~p"/product_aliases/#{product_alias.id}"
end
