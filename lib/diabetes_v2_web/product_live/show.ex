defmodule DiabetesV2Web.ProductLive.Show do
  use DiabetesV2Web, :live_view

  alias DiabetesV2.Products.Product

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Product Details
        <:subtitle>View the details of the product record.</:subtitle>
        <:actions>
          <.button variant="primary" navigate={~p"/products/#{@product}/edit"}>
            Edit
          </.button>
          <.button variant="primary" navigate={~p"/products"}>
            Back
          </.button>
        </:actions>
      </.header>

      <div class="space-y-6">
        <!-- 🧩 Basic Information -->
        <details
          {if @open_sections["basic"], do: [open: true], else: []}
          class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800"
        >
          <summary
            class="font-semibold cursor-pointer mb-2 text-zinc-900 dark:text-zinc-100"
            phx-click="toggle_section"
            phx-value-section="basic"
          >
            🧩 Basic Information
          </summary>
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-3">
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Id</label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.id}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">Name</label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.name}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Main Type
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {(@product.main_type && @product.main_type.name) || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Sub Type
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {(@product.sub_type && @product.sub_type.name) || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Category
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {(@product.category && @product.category.name) || "N/A"}
              </p>
            </div>
          </div>
          <div class="mt-4">
            <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
              Description
            </label>
            <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
              {@product.description || "N/A"}
            </p>
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Serving (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.serving_g || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Serving Description
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.serving_descr || "N/A"}
              </p>
            </div>
          </div>
        </details>
        
    <!-- 🍞 Macronutrients -->
        <details
          {if @open_sections["macros"], do: [open: true], else: []}
          class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800"
        >
          <summary
            class="font-semibold cursor-pointer mb-2 text-zinc-900 dark:text-zinc-100"
            phx-click="toggle_section"
            phx-value-section="macros"
          >
            🍞 Macronutrients
          </summary>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-3">
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Calories (kcal)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.calories_kcal || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Carbs (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.carbs_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Fibre (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.fibre_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Starch (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.starch_g || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Sugars (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.sugars_g || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Sugar Alcohol (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.sugar_alcohol_g || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Protein (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.protein_g || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Fat (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.fat_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Monounsaturated (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.mono_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Polyunsaturated (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.poly_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Saturated (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.sat_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Trans (g)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.trans_g || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Cholesterol (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.cholesterol_mg || "N/A"}
              </p>
            </div>
          </div>
        </details>
        
    <!-- 🧂 Minerals -->
        <details
          {if @open_sections["minerals"], do: [open: true], else: []}
          class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800"
        >
          <summary
            class="font-semibold cursor-pointer mb-2 text-zinc-900 dark:text-zinc-100"
            phx-click="toggle_section"
            phx-value-section="minerals"
          >
            🧂 Minerals
          </summary>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-3">
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Calcium (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.calcium_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Iron (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.iron_mg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Magnesium (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.magnesium_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Phosphorus (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.phosphorus_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Potassium (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.potassium_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Sodium (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.sodium_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Zinc (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.zinc_mg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Copper (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.copper_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Selenium (µg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.selenium_mcg || "N/A"}
              </p>
            </div>
          </div>
        </details>
        
    <!-- 🍊 Vitamins -->
        <details
          {if @open_sections["vitamins"], do: [open: true], else: []}
          class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800"
        >
          <summary
            class="font-semibold cursor-pointer mb-2 text-zinc-900 dark:text-zinc-100"
            phx-click="toggle_section"
            phx-value-section="vitamins"
          >
            🍊 Vitamins
          </summary>
          <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mt-3">
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Vitamin A (µg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_a_retinol_mcg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B1 Thiamin (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_b1_thiamin_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B2 Riboflavin (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_b2_riboflavin_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B3 Niacin (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_b3_niacin_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B5 Pantothenic Acid (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.v_b5_mg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B6 (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.v_b6_mg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B9 Folate (µg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_b9_folate_mcg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                B12 (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_b12_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Vitamin C (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.v_c_ascorbic_acid_mg || "N/A"}
              </p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Vitamin D (µg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.v_d_mcg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Vitamin E (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.v_e_mg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Vitamin K (µg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">{@product.v_k_mcg || "N/A"}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Choline (mg)
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.choline_mg || "N/A"}
              </p>
            </div>
          </div>
        </details>
        
    <!-- ⚙️ Miscellaneous -->
        <details
          {if @open_sections["misc"], do: [open: true], else: []}
          class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800"
        >
          <summary
            class="font-semibold cursor-pointer mb-2 text-zinc-900 dark:text-zinc-100"
            phx-click="toggle_section"
            phx-value-section="misc"
          >
            ⚙️ Miscellaneous
          </summary>
          <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mt-3">
            <div>
              <label class="block text-sm font-medium text-zinc-700 dark:text-zinc-300">
                Glycemic Index
              </label>
              <p class="mt-1 text-sm text-zinc-900 dark:text-zinc-100">
                {@product.glycemic_index || "N/A"}
              </p>
            </div>
          </div>
        </details>
      </div>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Product Details")
      |> assign(:open_sections, %{
        "basic" => true,
        "macros" => false,
        "minerals" => false,
        "vitamins" => false,
        "misc" => false
      })

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product =
      Ash.get!(Product, id,
        load: [:main_type, :sub_type, :category],
        actor: socket.assigns.current_user
      )

    {:noreply, assign(socket, :product, product)}
  end

  @impl true
  def handle_event("toggle_section", %{"section" => section}, socket) do
    open_sections =
      Map.put(socket.assigns.open_sections, section, !socket.assigns.open_sections[section])

    {:noreply, assign(socket, :open_sections, open_sections)}
  end
end
