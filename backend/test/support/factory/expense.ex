defmodule Tenantee.Factory.Expense do
  @moduledoc """
  Expense factory
  """
  alias Tenantee.Repo
  alias Tenantee.Expense.Schema
  import Money.Sigil

  def insert(property_id, attrs \\ []) do
    amount = Keyword.get(attrs, :amount, ~M[100.00]USD)
    description = Keyword.get(attrs, :description, "Expense description")

    %Schema{}
    |> Schema.changeset(%{
      property_id: property_id,
      amount: amount,
      description: description
    })
    |> Repo.insert!()
  end
end
