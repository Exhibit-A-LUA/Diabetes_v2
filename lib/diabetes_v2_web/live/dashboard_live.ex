defmodule DiabetesV2Web.DashboardLive do
  use DiabetesV2Web, :live_view

  alias DiabetesV2.Products.{ProductMainType, ProductSubType, ProductCategory}

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> load_stats()}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-7xl px-4 py-8">
      <.header>
        Diabetes V2 Dashboard
        <:subtitle>Product Management System</:subtitle>
      </.header>

      <div class="mt-10 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3">
        <!-- Product Main Types Card -->
        <.dashboard_card
          title="Product Main Types"
          description="Manage product main type categories"
          count={@main_type_count}
          path={~p"/product_main_types"}
          active={true}
        />
        
    <!-- Product Sub Types Card -->
        <.dashboard_card
          title="Product Sub Types"
          description="Manage product sub type categories"
          count={@sub_type_count}
          path={~p"/product_sub_types"}
          active={true}
        />
        
    <!-- Product Categories Card -->
        <.dashboard_card
          title="Product Categories"
          description="Manage product categories"
          count={@category_count}
          path={~p"/product_categories"}
          active={true}
        />
        
    <!-- Products Card -->
        <.dashboard_card
          title="Products"
          description="Manage all products"
          count={0}
          path="#"
          active={false}
        />
        
    <!-- Product Aliases Card -->
        <.dashboard_card
          title="Product Aliases"
          description="Manage alternative product names"
          count={0}
          path="#"
          active={false}
        />
        
    <!-- Ingredients Card -->
        <.dashboard_card
          title="Ingredients"
          description="Manage product ingredients"
          count={0}
          path="#"
          active={false}
        />
      </div>
    </div>
    """
  end

  defp dashboard_card(assigns) do
    ~H"""
    <div class={[
      "relative overflow-hidden rounded-lg border p-6 shadow-sm transition-all hover:shadow-md",
      if(@active,
        do: "border-zinc-300 bg-white hover:border-zinc-400",
        else: "border-zinc-200 bg-zinc-50"
      )
    ]}>
      <div class="flex items-start justify-between">
        <div class="flex-1">
          <h3 class={[
            "text-lg font-semibold",
            if(@active, do: "text-zinc-900", else: "text-zinc-400")
          ]}>
            {@title}
          </h3>
          <p class={[
            "mt-1 text-sm",
            if(@active, do: "text-zinc-600", else: "text-zinc-400")
          ]}>
            {@description}
          </p>
        </div>
        <%= if @active do %>
          <span class="inline-flex items-center rounded-full bg-blue-100 px-3 py-1 text-sm font-medium text-blue-800">
            {@count}
          </span>
        <% else %>
          <span class="inline-flex items-center rounded-full bg-zinc-200 px-3 py-1 text-sm font-medium text-zinc-500">
            Soon
          </span>
        <% end %>
      </div>

      <%= if @active do %>
        <.link
          navigate={@path}
          class="mt-4 inline-flex items-center text-sm font-medium text-blue-600 hover:text-blue-700"
        >
          View all
          <svg class="ml-1 h-4 w-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
          </svg>
        </.link>
      <% else %>
        <p class="mt-4 text-sm text-zinc-400">Coming soon...</p>
      <% end %>
    </div>
    """
  end

  defp load_stats(socket) do
    # Load counts for each resource
    main_type_count = Ash.count!(ProductMainType, actor: socket.assigns.current_user)
    sub_type_count = Ash.count!(ProductSubType, actor: socket.assigns.current_user)
    category_count = Ash.count!(ProductCategory, actor: socket.assigns.current_user)

    socket
    |> assign(main_type_count: main_type_count)
    |> assign(sub_type_count: sub_type_count)
    |> assign(category_count: category_count)
  end
end
