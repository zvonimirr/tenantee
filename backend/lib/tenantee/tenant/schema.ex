defmodule Tenantee.Tenant.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string, default: ""
    field :email, :string, default: ""

    timestamps()
  end

  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:first_name, :last_name, :phone, :email])
    |> validate_required([:first_name, :last_name])
  end
end
