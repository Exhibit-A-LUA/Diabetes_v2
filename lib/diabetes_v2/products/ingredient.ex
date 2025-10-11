defmodule DiabetesV2.Products.Ingredient do
  use Ash.Resource,
    otp_app: :diabetes_v2,
    domain: DiabetesV2.Products,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key(:id)

    attribute(:product_id, :integer) do
      allow_nil?(false)
    end

    attribute(:ingredient_product_id, :integer) do
      allow_nil?(false)
    end

    attribute :grams, :float do
      allow_nil?(false)
    end

    attribute(:weight_description, :string)

    attribute(:is_included, :boolean) do
      default(true)
      allow_nil?(false)
    end

    attribute(:options, :string)

    timestamps()
  end

  relationships do
    belongs_to :product, DiabetesV2.Products.Product do
      define_attribute?(false)
    end

    belongs_to :ingredient_product, DiabetesV2.Products.Product do
      define_attribute?(false)
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([
        :product_id,
        :ingredient_product_id,
        :grams,
        :weight_description,
        :is_included,
        :options
      ])
    end

    update :update do
      accept([
        :product_id,
        :ingredient_product_id,
        :grams,
        :weight_description,
        :is_included,
        :options
      ])
    end

    # Special seed action that allows setting ID
    create :seed do
      accept([
        :product_id,
        :ingredient_product_id,
        :grams,
        :weight_description,
        :is_included,
        :options
      ])

      argument :id, :integer do
        allow_nil?(false)
      end

      change(set_attribute(:id, arg(:id)))
    end
  end

  postgres do
    table("ingredients")
    repo(DiabetesV2.Repo)
  end
end
