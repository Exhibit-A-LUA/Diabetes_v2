defmodule DiabetesV2.Products.ProductMainType do
  use Ash.Resource,
    otp_app: :diabetes_v2,
    domain: DiabetesV2.Products,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key(:id)
    attribute(:name, :string)
    attribute(:description, :string)
    timestamps()
  end

  actions do
    defaults([:read, :destroy, create: [], update: []])
  end

  postgres do
    table("product_main_types")
    repo(DiabetesV2.Repo)
  end
end
