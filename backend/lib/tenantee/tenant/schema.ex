defmodule Tenantee.Tenant.Schema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Property.Schema, as: Property

  schema "tenants" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string, default: ""
    field :email, :string, default: ""

    many_to_many :properties, Property,
      join_through: "property_tenants",
      join_keys: [property_id: :id, tenant_id: :id]

    timestamps()
  end

  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:first_name, :last_name, :phone, :email])
    |> validate_required([:first_name, :last_name])
  end
end
