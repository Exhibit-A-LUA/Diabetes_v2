defmodule DiabetesV2.Products.ProductSubType do
  use Ash.Resource,
    otp_app: :diabetes_v2,
    domain: DiabetesV2.Products,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
    end

    attribute :description, :string do
      allow_nil?(false)
    end

    timestamps()
  end

  actions do
    defaults([:read, :destroy, create: [:*], update: [:*]])
  end

  postgres do
    table("product_sub_types")
    repo(DiabetesV2.Repo)
  end

  identities do
    identity(:unique_name, [:name])
  end
end
