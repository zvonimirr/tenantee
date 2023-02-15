defmodule Tenantee.Tenant.Schema do
  @moduledoc """
  This module defines the schema for the tenants table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Property.Schema, as: Property
  alias Tenantee.Tenant.Communication.Schema, as: Communication

  schema "tenants" do
    field :first_name, :string
    field :last_name, :string

    many_to_many :properties, Property,
      join_through: "property_tenants",
      join_keys: [property_id: :id, tenant_id: :id]

    has_many :communications, Communication, foreign_key: :tenant_id, on_delete: :delete_all

    timestamps()
  end

  def changeset(tenant, attrs) do
    tenant
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end
