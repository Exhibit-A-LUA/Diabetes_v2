defmodule DiabetesV2.Products.Seeds do
  NimbleCSV.define(MyParser, separator: ",", escape: "\"")

  alias DiabetesV2.Products.{
    ProductMainType,
    ProductSubType,
    ProductCategory,
    Product,
    ProductAlias,
    Ingredient
  }

  def seed_all! do
    seed_main_types!()
    seed_sub_types!()
    seed_categories!()
    seed_products!()
    seed_product_aliases!()
    seed_ingredients!()
    IO.puts("\n✓ All product seeds complete!")
  end

  def seed_main_types! do
    IO.puts("Seeding product_main_types...")

    Ash.bulk_destroy!(Ash.read!(ProductMainType), :destroy, %{}, return_errors?: true)

    data =
      File.stream!("priv/repo/product_main_types.csv")
      |> MyParser.parse_stream()
      |> Enum.map(fn [id, name, description] ->
        %{
          id: String.to_integer(id),
          name: String.trim(name),
          description: String.trim(description)
        }
      end)

    result =
      Ash.bulk_create(data, ProductMainType, :seed,
        domain: DiabetesV2.Products,
        return_errors?: true,
        return_records?: true
      )

    IO.puts("✓ Created #{length(result.records)} main types")
    if result.errors != [], do: IO.inspect(result.errors)
  end

  def seed_sub_types! do
    IO.puts("\nSeeding product_sub_types...")

    Ash.bulk_destroy!(Ash.read!(ProductSubType), :destroy, %{}, return_errors?: true)

    data =
      File.stream!("priv/repo/product_sub_types.csv")
      |> MyParser.parse_stream()
      |> Enum.map(fn [id, name, description] ->
        %{
          id: String.to_integer(id),
          name: String.trim(name),
          description: String.trim(description)
        }
      end)

    result =
      Ash.bulk_create(data, ProductSubType, :seed,
        domain: DiabetesV2.Products,
        return_errors?: true,
        return_records?: true
      )

    IO.puts("✓ Created #{length(result.records)} sub types")
    if result.errors != [], do: IO.inspect(result.errors)
  end

  def seed_categories! do
    IO.puts("\nSeeding product_categories...")

    Ash.bulk_destroy!(Ash.read!(ProductCategory), :destroy, %{}, return_errors?: true)

    data =
      File.stream!("priv/repo/product_categories.csv")
      |> MyParser.parse_stream()
      |> Enum.map(fn [id, name, description] ->
        %{
          id: String.to_integer(id),
          name: String.trim(name),
          description: String.trim(description)
        }
      end)

    result =
      Ash.bulk_create(data, ProductCategory, :seed,
        domain: DiabetesV2.Products,
        return_errors?: true,
        return_records?: true
      )

    IO.puts("✓ Created #{length(result.records)} categories")
    if result.errors != [], do: IO.inspect(result.errors)
  end

  def seed_products! do
    IO.puts("\nSeeding products...")

    # Use raw SQL to truncate instead of bulk_destroy
    DiabetesV2.Repo.query!("TRUNCATE TABLE products RESTART IDENTITY CASCADE")

    # Ash.bulk_destroy!(Ash.read!(Product), :destroy, %{}, return_errors?: true)

    # Load lookup tables once and create name -> id maps
    main_type_map = build_name_to_id_map(ProductMainType)
    sub_type_map = build_name_to_id_map(ProductSubType)
    category_map = build_name_to_id_map(ProductCategory)

    data =
      File.stream!("priv/repo/products.csv")
      |> MyParser.parse_stream()
      # NOTE: Changed order!
      |> Enum.map(fn [
                       id,
                       main_type_name,
                       sub_type_name,
                       category_name,
                       description,
                       name,
                       serving_g,
                       serving_descr,
                       calories_kcal,
                       carbs_g,
                       fibre_g,
                       starch_g,
                       sugars_g,
                       sugar_alcohol_g,
                       protein_g,
                       fat_g,
                       mono_g,
                       trans_g,
                       poly_g,
                       sat_g,
                       cholesterol_mg,
                       calcium_mg,
                       iron_mg,
                       magnesium_mg,
                       phosphorus_mg,
                       potassium_mg,
                       sodium_mg,
                       zinc_mg,
                       copper_mg,
                       selenium_mcg,
                       v_b9_folate_mcg,
                       v_a_retinol_mcg,
                       v_b1_thiamin_mg,
                       v_b2_riboflavin_mg,
                       v_b3_niacin_mg,
                       v_b5_mg,
                       v_b6_mg,
                       v_b12_mg,
                       v_c_ascorbic_acid_mg,
                       v_d_mcg,
                       v_k_mcg,
                       v_e_mg,
                       choline_mg,
                       glycemic_index
                     ] ->
        %{
          id: String.to_integer(id),
          name: String.trim(name),
          main_type_id: get_id_from_map(main_type_map, main_type_name, "ProductMainType"),
          sub_type_id: get_id_from_map(sub_type_map, sub_type_name, "ProductSubType"),
          category_id: get_id_from_map(category_map, category_name, "ProductCategory"),
          description: String.trim(description),
          serving_g: parse_float(serving_g),
          serving_descr: String.trim(serving_descr),
          calories_kcal: parse_float(calories_kcal),
          carbs_g: parse_float(carbs_g),
          fibre_g: parse_float(fibre_g),
          starch_g: parse_float(starch_g),
          sugars_g: parse_float(sugars_g),
          sugar_alcohol_g: parse_float(sugar_alcohol_g),
          protein_g: parse_float(protein_g),
          fat_g: parse_float(fat_g),
          mono_g: parse_float(mono_g),
          trans_g: parse_float(trans_g),
          poly_g: parse_float(poly_g),
          sat_g: parse_float(sat_g),
          cholesterol_mg: parse_float(cholesterol_mg),
          calcium_mg: parse_float(calcium_mg),
          iron_mg: parse_float(iron_mg),
          magnesium_mg: parse_float(magnesium_mg),
          phosphorus_mg: parse_float(phosphorus_mg),
          potassium_mg: parse_float(potassium_mg),
          sodium_mg: parse_float(sodium_mg),
          zinc_mg: parse_float(zinc_mg),
          copper_mg: parse_float(copper_mg),
          selenium_mcg: parse_float(selenium_mcg),
          v_b9_folate_mcg: parse_float(v_b9_folate_mcg),
          v_a_retinol_mcg: parse_float(v_a_retinol_mcg),
          v_b1_thiamin_mg: parse_float(v_b1_thiamin_mg),
          v_b2_riboflavin_mg: parse_float(v_b2_riboflavin_mg),
          v_b3_niacin_mg: parse_float(v_b3_niacin_mg),
          v_b5_mg: parse_float(v_b5_mg),
          v_b6_mg: parse_float(v_b6_mg),
          v_b12_mg: parse_float(v_b12_mg),
          v_c_ascorbic_acid_mg: parse_float(v_c_ascorbic_acid_mg),
          v_d_mcg: parse_float(v_d_mcg),
          v_k_mcg: parse_float(v_k_mcg),
          v_e_mg: parse_float(v_e_mg),
          choline_mg: parse_float(choline_mg),
          glycemic_index: parse_float(glycemic_index)
        }
      end)

    result =
      Ash.bulk_create(data, Product, :seed,
        domain: DiabetesV2.Products,
        return_errors?: true,
        return_records?: true
      )

    IO.puts("✓ Created #{length(result.records)} products")
    if result.errors != [], do: IO.inspect(result.errors)
  end

  # Helper to build name -> id map from a resource
  defp build_name_to_id_map(module) do
    module
    |> Ash.read!()
    |> Enum.map(&{&1.name, &1.id})
    |> Map.new()
  end

  # Helper to get ID from the cached map
  defp get_id_from_map(map, name, resource_name) do
    trimmed_name = String.trim(name)

    case Map.get(map, trimmed_name) do
      nil -> raise "No #{resource_name} found with name: '#{trimmed_name}'"
      id -> id
    end
  end

  # Helper to parse floats, handling empty strings
  defp parse_float(""), do: 0.0

  defp parse_float(value) when is_binary(value) do
    case Float.parse(value) do
      {float, _} -> float
      :error -> 0.0
    end
  end

  defp parse_float(value), do: value

  def seed_product_aliases! do
    IO.puts("\nSeeding product_aliases...")

    # Use raw SQL to truncate instead of bulk_destroy
    DiabetesV2.Repo.query!("TRUNCATE TABLE product_aliases RESTART IDENTITY CASCADE")

    # Load lookup tables once and create name -> id maps
    product_map = build_name_to_id_map(Product)

    data =
      File.stream!("priv/repo/product_aliases.csv")
      |> MyParser.parse_stream()
      |> Enum.map(fn [id, product, alias] ->
        %{
          id: String.to_integer(id),
          product_id: get_id_from_map(product_map, product, "Product"),
          name: String.trim(alias)
        }
      end)

    result =
      Ash.bulk_create(data, ProductAlias, :seed,
        domain: DiabetesV2.Products,
        return_errors?: true,
        return_records?: true
      )

    IO.puts("✓ Created #{length(result.records)} aliases")
    if result.errors != [], do: IO.inspect(result.errors)
  end

  # Helper to parse booleans
  def parse_boolean("yes"), do: true
  def parse_boolean("no"), do: false
  # fallback in case of unexpected values
  def parse_boolean(_), do: nil

  def seed_ingredients! do
    IO.puts("\nSeeding ingredients...")
    # Use raw SQL to truncate instead of bulk_destroy
    DiabetesV2.Repo.query!("TRUNCATE TABLE ingredients RESTART IDENTITY CASCADE")

    # Load lookup tables once and create name -> id maps
    product_map = build_name_to_id_map(Product)
    # ADD THIS
    alias_map = build_alias_to_product_id_map()

    data =
      File.stream!("priv/repo/ingredients.csv")
      |> MyParser.parse_stream()
      |> Enum.map(fn [id, _recipe_num, product, ingredient, options, grams, included] ->
        %{
          id: String.to_integer(id),
          product_id: get_id_from_map(product_map, product, "Product"),
          ingredient_product_id:
            get_id_with_alias_fallback(product_map, alias_map, ingredient, "Ingredient"),
          grams: parse_float(grams),
          weight_description: "",
          is_included: parse_boolean(included),
          options: String.trim(options)
        }
      end)

    result =
      Ash.bulk_create(data, Ingredient, :seed,
        domain: DiabetesV2.Products,
        return_errors?: true,
        return_records?: true
      )

    IO.puts("✓ Created #{length(result.records)} ingredients")
    if result.errors != [], do: IO.inspect(result.errors)
  end

  # Build a map of alias name -> product_id
  defp build_alias_to_product_id_map do
    ProductAlias
    |> Ash.read!()
    |> Enum.map(&{&1.name, &1.id})
    |> Map.new()
  end

  # Get ID from product map, or fall back to alias map
  defp get_id_with_alias_fallback(product_map, alias_map, name, context) do
    name = String.trim(name)

    case Map.get(product_map, name) do
      nil ->
        # Not found in products, check aliases
        case Map.get(alias_map, name) do
          nil ->
            IO.puts("⚠️  #{context} '#{name}' not found in products or aliases")
            nil

          product_id ->
            IO.puts("✓ Found '#{name}' in aliases, mapped to product_id #{product_id}")
            product_id
        end

      product_id ->
        # Found in products directly
        product_id
    end
  end
end
