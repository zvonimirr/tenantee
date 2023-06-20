defmodule Tenantee.Schema.Rent do
  @moduledoc """
  Rent Ecto Schema.
  """
  alias Tenantee.Schema.Tenant

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  An amount of money that is due on a certain date.
  Can be paid or unpaid, and belongs to a tenant.
  """

  @type t :: %__MODULE__{
          id: integer(),
          amount: Money.t(),
          due_date: Date.t(),
          paid: boolean(),
          tenant: Tenant.t(),
          tenant_id: integer(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "rents" do
    field :amount, Money.Ecto.Composite.Type
    field :due_date, :date
    field :paid, :boolean, default: false

    belongs_to(:tenant, Tenant)

    timestamps()
  end

  def changeset(rent, attrs) do
    rent
    |> cast(attrs, [:amount, :due_date, :paid, :tenant_id])
    |> validate_required([:amount, :due_date, :tenant_id])
    |> validate_change(:amount, fn :amount, amount ->
      min = Money.new(0, amount.currency)

      case Money.compare(amount, min) do
        :gt -> []
        _ -> [amount: "must be greater than 0"]
      end
    end)
    |> assoc_constraint(:tenant)
  end
end
