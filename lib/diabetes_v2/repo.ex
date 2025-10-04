defmodule DiabetesV2.Repo do
  use Ecto.Repo,
    otp_app: :diabetes_v2,
    adapter: Ecto.Adapters.Postgres
end
