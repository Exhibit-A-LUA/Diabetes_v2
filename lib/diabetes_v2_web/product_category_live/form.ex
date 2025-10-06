defmodule DiabetesV2Web.ProductCategoryLive.Form do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage product_category records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="product_category-form"
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.button phx-disable-with="Saving..." variant="primary">Save Product category</.button>
        <.button navigate={return_path(@return_to, @product_category)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    product_category =
      case params["id"] do
        nil ->
          nil

        id ->
          Ash.get!(DiabetesV2.Products.ProductCategory, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(product_category), do: "New", else: "Edit"
    page_title = action <> " " <> "Product category"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(product_category: product_category)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"product_category" => product_category_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, product_category_params))}
  end

  def handle_event("save", %{"product_category" => product_category_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: product_category_params) do
      {:ok, product_category} ->
        notify_parent({:saved, product_category})

        socket =
          socket
          |> put_flash(:info, "Product category #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, product_category))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{product_category: product_category}} = socket) do
    form =
      if product_category do
        AshPhoenix.Form.for_update(product_category, :update,
          as: "product_category",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(DiabetesV2.Products.ProductCategory, :create,
          as: "product_category",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _product_category), do: ~p"/product_categories"
  defp return_path("show", product_category), do: ~p"/product_categories/#{product_category.id}"
end
