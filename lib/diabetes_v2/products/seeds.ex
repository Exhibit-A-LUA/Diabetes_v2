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
    # TODO: Implement when resource is created
    IO.puts("  (not yet implemented)")
  end

  def seed_product_aliases! do
    IO.puts("\nSeeding product_aliases...")
    # TODO: Implement when resource is created
    IO.puts("  (not yet implemented)")
  end

  def seed_ingredients! do
    IO.puts("\nSeeding ingredients...")
    # TODO: Implement when resource is created
    IO.puts("  (not yet implemented)")
  end
end
