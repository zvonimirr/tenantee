defmodule Tenantee.Property.Schema do
  @moduledoc """
  This module defines the schema for the properties table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Tenant.Schema, as: Tenant

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :location, :string
    field :price, Money.Ecto.Composite.Type

    many_to_many :tenants, Tenant,
      join_through: "property_tenants",
      join_keys: [property_id: :id, tenant_id: :id],
      on_replace: :delete

    timestamps()
  end

  def add_tenant(property, tenant) do
    property
    |> change()
    |> put_assoc(:tenants, [tenant | property.tenants])
  end

  def remove_tenant(property, tenant) do
    property
    |> change()
    |> put_assoc(:tenants, property.tenants -- [tenant])
  end

  def changeset(property, attrs) do
    property
    |> cast(attrs, [:name, :description, :location, :price])
    |> cast_assoc(:tenants)
    |> validate_required([:name, :location, :price])
  end
end
