# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     DiabetesV2.Repo.insert!(%DiabetesV2.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

NimbleCSV.define(MyParser, separator: ",", escape: "\"")

alias DiabetesV2.Products.ProductMainType

IO.puts("Clearing existing product_main_types...")
Ash.bulk_destroy!(Ash.read!(ProductMainType), :destroy, %{}, return_errors?: true)

IO.puts("Seeding product_main_types...")

# Parse CSV and prepare data
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

# Bulk create
# Use :seed action
result =
  Ash.bulk_create(data, ProductMainType, :seed,
    domain: DiabetesV2.Products,
    return_errors?: true,
    return_records?: true
  )

IO.puts("✓ Created #{length(result.records)} records")

if result.errors != [] do
  IO.puts("✗ Errors:")
  IO.inspect(result.errors)
end

IO.puts("Done!")
