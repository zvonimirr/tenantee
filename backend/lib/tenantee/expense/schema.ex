defmodule Tenantee.Expense.Schema do
  @moduledoc """
  This module defines the schema for the expenses table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Property.Schema, as: Property

  schema "expenses" do
    field :amount, Money.Ecto.Composite.Type
    field :description, :string, default: ""
    belongs_to :property, Property, foreign_key: :property_id

    timestamps()
  end

  def changeset(expense, attrs) do
    expense
    |> cast(attrs, [:amount, :description, :property_id])
    |> cast_assoc(:property)
    |> validate_required([:amount, :property_id])
  end
end
