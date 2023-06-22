defmodule Tenantee.Entity.Expense do
  @moduledoc """
  Helper functions for expenses.
  """
  alias Tenantee.Repo
  alias Tenantee.Schema.Expense, as: Schema

  @doc """
  Creates a new expense.
  """
  @spec create(map()) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.error()}
  def create(attrs) do
    Schema.changeset(%Schema{}, attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an expense to set the payer.
  If the payer is nil, the expense is calculated as
  being paid by the landlord.
  """
  @spec set_payer(Schema.t(), integer()) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.error()}
  def set_payer(expense, payer_id) do
    Schema.changeset(expense, %{tenant_id: payer_id})
    |> Repo.update()
  end
end
