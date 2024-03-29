defmodule Tenantee.Schema.Expense do
  @moduledoc """
  Expense Ecto Schema.
  """
  alias Tenantee.Cldr
  alias Tenantee.Schema.{Property, Tenant}

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  An expense related to a property. It can be a bill, a repair, etc.
  In some cases, the expense is paid by the tenant, in others by the landlord.
  """

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          paid: boolean(),
          amount: Money.t(),
          property: Property.t(),
          tenant: Tenant.t() | nil,
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "expenses" do
    field :name, :string
    field :description, :string, default: ""
    field :paid, :boolean, default: false
    field :amount, Money.Ecto.Composite.Type

    belongs_to(:property, Property)
    belongs_to(:tenant, Tenant)

    timestamps()
  end

  def changeset(expense, attrs \\ %{}) do
    expense
    |> cast(attrs, [:name, :description, :amount, :property_id, :tenant_id, :paid])
    |> validate_required([:name, :amount, :property_id])
    |> validate_change(:amount, Cldr.validate_amount(0))
    |> assoc_constraint(:property)

    # TODO: while the tenant is not required, we should validate that the tenant
    # exists and is related to the property
  end
end
