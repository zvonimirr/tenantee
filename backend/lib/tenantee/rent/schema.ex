defmodule Tenantee.Rent.Schema do
  @moduledoc """
  This module defines the schema for the rent table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Tenant.Schema, as: Tenant
  alias Tenantee.Property.Schema, as: Property

  schema "rent" do
    field :due_date, :date, default: Date.utc_today()
    field :paid, :boolean, default: false

    belongs_to :tenant, Tenant
    belongs_to :property, Property
  end

  def changeset(rent, attrs) do
    rent
    |> cast(attrs, [:due_date, :paid, :tenant_id, :property_id])
    |> validate_required([:due_date, :paid, :tenant_id, :property_id])
  end
end
