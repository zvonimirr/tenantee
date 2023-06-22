defmodule Tenantee.Schema.Rent do
  @moduledoc """
  Rent Ecto Schema.
  """
  alias Tenantee.Schema.{Tenant, Property}
  alias Tenantee.Cldr

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  An amount of money that is due on a certain date.
  Can be paid or unpaid, and belongs to a tenant and a property.
  """

  @type t :: %__MODULE__{
          id: integer(),
          amount: Money.t(),
          due_date: Date.t(),
          paid: boolean(),
          tenant: Tenant.t(),
          tenant_id: integer(),
          property: Property.t(),
          property_id: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "rents" do
    field :amount, Money.Ecto.Composite.Type
    field :due_date, :date
    field :paid, :boolean, default: false

    belongs_to(:tenant, Tenant)
    belongs_to(:property, Property)

    timestamps()
  end

  def changeset(rent, attrs) do
    rent
    |> cast(attrs, [:amount, :due_date, :paid, :tenant_id, :property_id])
    |> validate_required([:amount, :due_date, :tenant_id, :property_id])
    |> validate_change(:amount, Cldr.validate_amount(0))
    |> assoc_constraint(:tenant)
    |> assoc_constraint(:property)
  end
end
