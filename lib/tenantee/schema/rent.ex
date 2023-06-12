defmodule Tenantee.Schema.Rent do
  @moduledoc """
  Rent Ecto Schema.
  """
  alias Tenantee.Schema.Tenant

  use Ecto.Schema
  import Ecto.Changeset

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
