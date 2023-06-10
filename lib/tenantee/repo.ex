defmodule Tenantee.Repo do
  use Ecto.Repo,
    otp_app: :tenantee,
    adapter: Ecto.Adapters.Postgres
end
