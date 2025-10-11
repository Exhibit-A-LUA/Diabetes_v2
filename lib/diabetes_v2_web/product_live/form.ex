defmodule DiabetesV2Web.ProductLive.Form do
  use DiabetesV2Web, :live_view

  import DiabetesV2Web.ParamHelpers

  alias DiabetesV2.Products.{Product, ProductMainType, ProductSubType, ProductCategory}

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage product records in your database.</:subtitle>
      </.header>

      <.form
        for={@form}
        id="product-form"
        phx-change="validate"
        phx-submit="save"
        class="space-y-6"
      >
        <!-- 🧩 Basic Info -->
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
            <.input
              field={@form[:name]}
              type="text"
              label="Name"
            />
            <.input
              field={@form[:main_type_id]}
              type="select"
              label="Main Type"
              options={@main_type_options}
              prompt="Select a main type"
            />
            <.input
              field={@form[:sub_type_id]}
              type="select"
              label="Sub Type"
              options={@sub_type_options}
              prompt="Select a sub type"
            />
            <.input
              field={@form[:category_id]}
              type="select"
              label="Category"
              options={@category_options}
              prompt="Select a category"
            />
          </div>
          <div class="mt-4">
            <.input field={@form[:description]} type="textarea" label="Description" />
          </div>
          <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mt-4">
            <.input field={@form[:serving_g]} type="number" label="Serving (g)" step="0.01" />
            <.input field={@form[:serving_descr]} type="text" label="Serving Description" />
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
            <.input field={@form[:calories_kcal]} type="number" label="Calories (kcal)" step="0.01" />
            <.input field={@form[:carbs_g]} type="number" label="Carbs (g)" step="0.01" />
            <.input field={@form[:fibre_g]} type="number" label="Fibre (g)" step="0.01" />
            <.input field={@form[:starch_g]} type="number" label="Starch (g)" step="0.01" />
            <.input field={@form[:sugars_g]} type="number" label="Sugars (g)" step="0.01" />
            <.input
              field={@form[:sugar_alcohol_g]}
              type="number"
              label="Sugar Alcohol (g)"
              step="0.01"
            />
            <.input field={@form[:protein_g]} type="number" label="Protein (g)" step="0.01" />
            <.input field={@form[:fat_g]} type="number" label="Fat (g)" step="0.01" />
            <.input field={@form[:mono_g]} type="number" label="Monounsaturated (g)" step="0.01" />
            <.input field={@form[:poly_g]} type="number" label="Polyunsaturated (g)" step="0.01" />
            <.input field={@form[:sat_g]} type="number" label="Saturated (g)" step="0.01" />
            <.input field={@form[:trans_g]} type="number" label="Trans (g)" step="0.01" />
            <.input field={@form[:cholesterol_mg]} type="number" label="Cholesterol (mg)" step="0.01" />
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
            <.input field={@form[:calcium_mg]} type="number" label="Calcium (mg)" step="0.01" />
            <.input field={@form[:iron_mg]} type="number" label="Iron (mg)" step="0.01" />
            <.input field={@form[:magnesium_mg]} type="number" label="Magnesium (mg)" step="0.01" />
            <.input field={@form[:phosphorus_mg]} type="number" label="Phosphorus (mg)" step="0.01" />
            <.input field={@form[:potassium_mg]} type="number" label="Potassium (mg)" step="0.01" />
            <.input field={@form[:sodium_mg]} type="number" label="Sodium (mg)" step="0.01" />
            <.input field={@form[:zinc_mg]} type="number" label="Zinc (mg)" step="0.01" />
            <.input field={@form[:copper_mg]} type="number" label="Copper (mg)" step="0.01" />
            <.input field={@form[:selenium_mcg]} type="number" label="Selenium (µg)" step="0.01" />
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
            <.input field={@form[:v_a_retinol_mcg]} type="number" label="Vitamin A (µg)" step="0.01" />
            <.input field={@form[:v_b1_thiamin_mg]} type="number" label="B1 Thiamin (mg)" step="0.01" />
            <.input
              field={@form[:v_b2_riboflavin_mg]}
              type="number"
              label="B2 Riboflavin (mg)"
              step="0.01"
            />
            <.input field={@form[:v_b3_niacin_mg]} type="number" label="B3 Niacin (mg)" step="0.01" />
            <.input
              field={@form[:v_b5_mg]}
              type="number"
              label="B5 Pantothenic Acid (mg)"
              step="0.01"
            />
            <.input field={@form[:v_b6_mg]} type="number" label="B6 (mg)" step="0.01" />
            <.input field={@form[:v_b9_folate_mcg]} type="number" label="B9 Folate (µg)" step="0.01" />
            <.input field={@form[:v_b12_mg]} type="number" label="B12 (mg)" step="0.01" />
            <.input
              field={@form[:v_c_ascorbic_acid_mg]}
              type="number"
              label="Vitamin C (mg)"
              step="0.01"
            />
            <.input field={@form[:v_d_mcg]} type="number" label="Vitamin D (µg)" step="0.01" />
            <.input field={@form[:v_e_mg]} type="number" label="Vitamin E (mg)" step="0.01" />
            <.input field={@form[:v_k_mcg]} type="number" label="Vitamin K (µg)" step="0.01" />
            <.input field={@form[:choline_mg]} type="number" label="Choline (mg)" step="0.01" />
          </div>
        </details>
        
    <!-- ⚙️ Misc -->
        <details
          {if @open_sections["miscellaneous"], do: [open: true], else: []}
          class="border border-zinc-200 dark:border-zinc-700 rounded-lg p-4 bg-white dark:bg-zinc-800"
        >
          <summary
            class="font-semibold cursor-pointer mb-2 text-zinc-900 dark:text-zinc-100"
            phx-click="toggle_section"
            phx-value-section="miscellaneous"
          >
            ⚙️ Miscellaneous
          </summary>
          <div class="grid grid-cols-2 md:grid-cols-3 gap-4 mt-3">
            <.input field={@form[:glycemic_index]} type="number" label="Glycemic Index" step="0.01" />
          </div>
        </details>
        
    <!-- 🖱️ Actions -->
        <div class="flex justify-end gap-4 pt-6">
          <.button phx-disable-with="Saving..." variant="primary">Save Product</.button>
          <.button navigate={return_path(@return_to, @product)}>Cancel</.button>
        </div>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    product =
      case params["id"] do
        nil -> nil
        id -> Ash.get!(Product, id, actor: socket.assigns.current_user)
      end

    action = if is_nil(product), do: "New", else: "Edit"
    page_title = action <> " " <> "Product"

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(product: product)
     |> assign(:page_title, page_title)
     |> assign(:open_sections, %{
       "basic" => true,
       "macros" => false,
       "minerals" => false,
       "vitamins" => false,
       "misc" => false
     })
     |> load_select_options()
     |> assign_form()}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("toggle_section", %{"section" => section}, socket) do
    current_state = socket.assigns.open_sections[section]
    new_state = Map.put(socket.assigns.open_sections, section, !current_state)
    {:noreply, assign(socket, :open_sections, new_state)}
  end

  @impl true
  def handle_event("validate", %{"product" => product_params}, socket) do
    params = normalize_form_params(product_params)
    form = AshPhoenix.Form.validate(socket.assigns.form, params)
    {:noreply, assign(socket, form: to_form(form))}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: product_params) do
      {:ok, product} ->
        notify_parent({:saved, product})

        socket =
          socket
          |> put_flash(:info, "Product #{socket.assigns.form.source.type}d successfully")
          |> push_navigate(to: return_path(socket.assigns.return_to, product))

        {:noreply, socket}

      {:error, form} ->
        {:noreply, assign(socket, form: form)}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp load_select_options(socket) do
    # Load all the options for select dropdowns
    main_type_options =
      Ash.read!(ProductMainType, actor: socket.assigns.current_user)
      |> Enum.map(&{&1.name, &1.id})

    sub_type_options =
      Ash.read!(ProductSubType, actor: socket.assigns.current_user)
      |> Enum.map(&{&1.name, &1.id})

    category_options =
      Ash.read!(ProductCategory, actor: socket.assigns.current_user)
      |> Enum.map(&{&1.name, &1.id})

    socket
    |> assign(:main_type_options, main_type_options)
    |> assign(:sub_type_options, sub_type_options)
    |> assign(:category_options, category_options)
  end

  defp assign_form(%{assigns: %{product: product}} = socket) do
    form =
      if product do
        AshPhoenix.Form.for_update(product, :update,
          as: "product",
          domain: DiabetesV2.Products,
          actor: socket.assigns.current_user
        )
      else
        AshPhoenix.Form.for_create(Product, :create,
          as: "product",
          domain: DiabetesV2.Products,
          actor: socket.assigns.current_user
        )
      end

    assign(socket, form: to_form(form))
  end

  # Helper to convert empty strings to nil
  # defp normalize_form_params(params) when is_map(params) do
  #   Enum.reduce(params, %{}, fn {key, value}, acc ->
  #     Map.put(acc, key, if(value == "", do: nil, else: value))
  #   end)
  # end

  defp return_path("index", _product), do: ~p"/products"
  defp return_path("show", product), do: ~p"/products/#{product.id}"
end
