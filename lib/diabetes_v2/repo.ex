# defmodule DiabetesV2.Repo do
#   use Ecto.Repo,
#     otp_app: :diabetes_v2,
#     adapter: Ecto.Adapters.Postgres
# end
defmodule DiabetesV2.Repo do
  use AshPostgres.Repo,
    otp_app: :diabetes_v2

  def installed_extensions do
    ["ash-functions", "citext"]
  end

  def min_pg_version do
    %Version{major: 16, minor: 10, patch: 0}
  end
end
