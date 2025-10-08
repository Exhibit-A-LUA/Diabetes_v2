defmodule DiabetesV2.Products.Product do
  use Ash.Resource,
    otp_app: :diabetes_v2,
    domain: DiabetesV2.Products,
    data_layer: AshPostgres.DataLayer

  attributes do
    integer_primary_key(:id)

    # Keep these manual definitions
    attribute(:main_type_id, :integer) do
      allow_nil?(false)
    end

    attribute(:sub_type_id, :integer) do
      allow_nil?(false)
    end

    attribute(:category_id, :integer) do
      allow_nil?(false)
    end

    attribute :name, :string do
      allow_nil?(false)
    end

    attribute(:description, :string)
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
    attribute(:v_b9_folate_mcg, :float)
    attribute(:v_b1_thiamin_mg, :float)
    attribute(:v_b2_riboflavin_mg, :float)
    attribute(:v_b3_niacin_mg, :float)
    attribute(:v_b5_mg, :float)
    attribute(:v_b6_mg, :float)
    attribute(:v_b12_mg, :float)
    attribute(:v_c_ascorbic_acid_mg, :float)
    attribute(:v_d_mcg, :float)
    attribute(:v_k_mcg, :float)
    attribute(:v_e_mg, :float)
    timestamps()
  end

  relationships do
    # Remove attribute_writable? - we're managing the attribute manually
    belongs_to :main_type, DiabetesV2.Products.ProductMainType do
      # Don't auto-create the attribute
      define_attribute?(false)
    end

    belongs_to :sub_type, DiabetesV2.Products.ProductSubType do
      define_attribute?(false)
    end

    belongs_to :category, DiabetesV2.Products.ProductCategory do
      define_attribute?(false)
    end

    has_many :aliases, DiabetesV2.Products.ProductAlias, destination_attribute: :product_id
    has_many :ingredients, DiabetesV2.Products.Ingredient, destination_attribute: :product_id

    has_many :used_in, DiabetesV2.Products.Ingredient,
      destination_attribute: :ingredient_product_id
  end

  actions do
    defaults([:destroy])

    read :read do
      primary?(true)
    end

    read :with_types do
      prepare(build(load: [:main_type, :sub_type, :category]))
      pagination(offset?: true, default_limit: 50)
    end

    create :create do
      accept([
        :name,
        :description,
        :serving_g,
        :serving_descr,
        :calories_kcal,
        :carbs_g,
        :fibre_g,
        :starch_g,
        :sugars_g,
        :sugar_alcohol_g,
        :protein_g,
        :fat_g,
        :mono_g,
        :trans_g,
        :poly_g,
        :sat_g,
        :cholesterol_mg,
        :glycemic_index,
        :calcium_mg,
        :iron_mg,
        :magnesium_mg,
        :phosphorus_mg,
        :potassium_mg,
        :sodium_mg,
        :zinc_mg,
        :copper_mg,
        :selenium_mcg,
        :choline_mg,
        :v_a_retinol_mcg,
        :v_b9_folate_mcg,
        :v_b1_thiamin_mg,
        :v_b2_riboflavin_mg,
        :v_b3_niacin_mg,
        :v_b5_mg,
        :v_b6_mg,
        :v_b12_mg,
        :v_c_ascorbic_acid_mg,
        :v_d_mcg,
        :v_k_mcg,
        :v_e_mg,
        :main_type_id,
        :sub_type_id,
        :category_id
      ])
    end

    create :seed do
      accept([
        :name,
        :description,
        :serving_g,
        :serving_descr,
        :calories_kcal,
        :carbs_g,
        :fibre_g,
        :starch_g,
        :sugars_g,
        :sugar_alcohol_g,
        :protein_g,
        :fat_g,
        :mono_g,
        :trans_g,
        :poly_g,
        :sat_g,
        :cholesterol_mg,
        :glycemic_index,
        :calcium_mg,
        :iron_mg,
        :magnesium_mg,
        :phosphorus_mg,
        :potassium_mg,
        :sodium_mg,
        :zinc_mg,
        :copper_mg,
        :selenium_mcg,
        :choline_mg,
        :v_a_retinol_mcg,
        :v_b9_folate_mcg,
        :v_b1_thiamin_mg,
        :v_b2_riboflavin_mg,
        :v_b3_niacin_mg,
        :v_b5_mg,
        :v_b6_mg,
        :v_b12_mg,
        :v_c_ascorbic_acid_mg,
        :v_d_mcg,
        :v_k_mcg,
        :v_e_mg,
        :main_type_id,
        :sub_type_id,
        :category_id
      ])

      argument :id, :integer do
        allow_nil?(false)
      end

      change(set_attribute(:id, arg(:id)))
    end

    update :update do
      accept([
        :name,
        :description,
        :serving_g,
        :serving_descr,
        :calories_kcal,
        :carbs_g,
        :fibre_g,
        :starch_g,
        :sugars_g,
        :sugar_alcohol_g,
        :protein_g,
        :fat_g,
        :mono_g,
        :trans_g,
        :poly_g,
        :sat_g,
        :cholesterol_mg,
        :glycemic_index,
        :calcium_mg,
        :iron_mg,
        :magnesium_mg,
        :phosphorus_mg,
        :potassium_mg,
        :sodium_mg,
        :zinc_mg,
        :copper_mg,
        :selenium_mcg,
        :choline_mg,
        :v_a_retinol_mcg,
        :v_b9_folate_mcg,
        :v_b1_thiamin_mg,
        :v_b2_riboflavin_mg,
        :v_b3_niacin_mg,
        :v_b5_mg,
        :v_b6_mg,
        :v_b12_mg,
        :v_c_ascorbic_acid_mg,
        :v_d_mcg,
        :v_k_mcg,
        :v_e_mg,
        :main_type_id,
        :sub_type_id,
        :category_id
      ])
    end
  end

  postgres do
    table("products")
    repo(DiabetesV2.Repo)
  end

  identities do
    identity(:unique_name, [:name])
  end
end
