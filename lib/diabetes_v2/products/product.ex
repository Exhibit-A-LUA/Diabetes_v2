defmodule DiabetesV2.Products.Product do
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

    attribute(:serving_g, :float)
    attribute(:serving_descr, :string)
    attribute(:calories_kcal, :float)
    attribute(:carbs_g, :float)
    attribute(:fibre_g, :float)
    attribute(:starch_g, :float)
    attribute(:sugars_g, :float)
    attribute(:sugar_alcohol_g, :float)
    attribute(:protein_g, :float)
    attribute(:fat_g, :float)
    attribute(:mono_g, :float)
    attribute(:trans_g, :float)
    attribute(:poly_g, :float)
    attribute(:sat_g, :float)
    attribute(:cholesterol_mg, :float)
    attribute(:glycemic_index, :float)
    attribute(:calcium_mg, :float)
    attribute(:iron_mg, :float)
    attribute(:magnesium_mg, :float)
    attribute(:phosphorus_mg, :float)
    attribute(:potassium_mg, :float)
    attribute(:sodium_mg, :float)
    attribute(:zinc_mg, :float)
    attribute(:copper_mg, :float)
    attribute(:selenium_mcg, :float)
    attribute(:choline_mg, :float)
    attribute(:v_a_retinol_mcg, :float)
    timestamps()
  end

  relationships do
    belongs_to :main_type, DiabetesV2.Products.ProductMainType do
      allow_nil?(false)
    end

    belongs_to :sub_type, DiabetesV2.Products.ProductSubType do
      allow_nil?(false)
    end

    belongs_to :category, DiabetesV2.Products.ProductCategory do
      allow_nil?(false)
    end

    has_many :aliases, DiabetesV2.Products.ProductAlias, destination_attribute: :product_id
  end

  actions do
    defaults([:read, :destroy, create: [], update: []])
  end

  postgres do
    table("products")
    repo(DiabetesV2.Repo)
  end

  identities do
    identity :unique_name, [:name]
  end
end
