defmodule DiabetesV2Web.ProductSubTypeLive.Form do
  use DiabetesV2Web, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage product_sub_type records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="product_sub_type-form"
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />
        <.button phx-disable-with="Saving..." variant="primary">Save Product sub type</.button>
        <.button navigate={return_path(@return_to, @product_sub_type)}>Cancel</.button>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    product_sub_type =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(DiabetesV2.Products.ProductSubType, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(product_sub_type), do: "New", else: "Edit"
    page_title = action <> " " <> "Product sub type"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(product_sub_type: product_sub_type)
     |> assign(:page_title, page_title)
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("validate", %{"product_sub_type" => product_sub_type_params}, socket) do
    {:noreply,
     assign(socket, form: AshPhoenix.Form.validate(socket.assigns.form, product_sub_type_params))}
  end

  def handle_event("save", %{"product_sub_type" => product_sub_type_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: product_sub_type_params) do
      {:ok, product_sub_type} ->
        notify_parent({:saved, product_sub_type})

        socket =
          socket
          |> put_flash(:info, "Product sub type #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, product_sub_type))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp assign_form(%{assigns: %{product_sub_type: product_sub_type}} = socket) do
    form =
      if product_sub_type do
        AshPhoenix.Form.for_update(product_sub_type, :update,
          as: "product_sub_type",
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(DiabetesV2.Products.ProductSubType, :create,
          as: "product_sub_type",
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  defp return_path("index", _product_sub_type), do: ~p"/product_sub_types"
  defp return_path("show", product_sub_type), do: ~p"/product_sub_types/#{product_sub_type.id}"
end
