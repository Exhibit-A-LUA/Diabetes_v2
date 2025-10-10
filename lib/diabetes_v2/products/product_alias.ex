defmodule DiabetesV2.Products.ProductAlias do
  use Ash.Resource,
    otp_app: :diabetes_v2,
    domain: DiabetesV2.Products,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key(:id)

    attribute(:product_id, :integer)

    attribute :name, :string do
      allow_nil?(false)
    end

    timestamps()
  end

  relationships do
    belongs_to :product, DiabetesV2.Products.Product do
      allow_nil?(false)
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:name, :product_id])
    end

    update :update do
      accept([:name, :product_id])
    end

    # Special seed action that allows setting ID
    create :seed do
      accept([:name, :product_id])

      argument :id, :integer do
        allow_nil?(false)
      end

      change(set_attribute(:id, arg(:id)))
    end
  end

  postgres do
    table("product_aliases")
    repo(DiabetesV2.Repo)
  end

  identities do
    identity(:unique_name, [:name])
  end
end
