defmodule DiabetesV2.Products do
  use Ash.Domain,
    otp_app: :diabetes_v2

  resources do
    resource(DiabetesV2.Products.ProductMainType)
    resource(DiabetesV2.Products.ProductSubType)
    resource(DiabetesV2.Products.ProductCategory)
  end
end
