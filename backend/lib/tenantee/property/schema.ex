defmodule Tenantee.Property.Schema do
  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Tenant.Schema, as: Tenant

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :location, :string
    field :price, :float
    field :currency, :string

    many_to_many :tenants, Tenant,
      join_through: "property_tenants",
      join_keys: [property_id: :id, tenant_id: :id]

    timestamps()
  end

  def add_tenant(property, tenant) do
    property
    |> change()
    |> put_assoc(:tenants, [tenant | property.tenants])
  end

  def changeset(property, attrs) do
    property
    |> cast(attrs, [:name, :description, :location, :price, :currency])
    |> cast_assoc(:tenants)
    |> validate_required([:name, :location, :price, :currency])
  end
end
