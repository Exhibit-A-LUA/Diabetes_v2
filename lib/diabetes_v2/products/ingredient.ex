defmodule DiabetesV2.Products.Ingredient do
  use Ash.Resource,
    otp_app: :diabetes_v2,
    domain: DiabetesV2.Products,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key(:id)

    attribute :grams, :float do
      allow_nil?(false)
    end

    attribute(:weight_description, :string)

    attribute(:is_included, :boolean) do
      default true
      allow_nil? false
    end

    attribute(:options, :string)

    timestamps()
  end

  relationships do
    belongs_to :product, DiabetesV2.Products.Product do
      allow_nil?(false)
    end

    belongs_to :ingredient_product, DiabetesV2.Products.Product do
      allow_nil?(false)
    end
  end

  actions do
    defaults([:read, :destroy, create: [], update: []])
  end

  postgres do
    table("ingredients")
    repo(DiabetesV2.Repo)
  end
end
