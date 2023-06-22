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
  Gets an expense by ID.
  """
  @spec get(integer()) :: {:ok, Schema.t()} | {:error, String.t()}
  def get(id) do
    case Repo.get(Schema, id) do
      nil -> {:error, "Expense not found"}
      expense -> {:ok, expense}
    end
  end

  @doc """
  Marks an expense as paid.
  """
  @spec pay(integer()) :: :ok | {:error, Ecto.Changeset.error()}
  def pay(id) do
    with {:ok, expense} <- get(id),
         changeset <- Schema.changeset(expense, %{paid: true}),
         {:ok, _} <- Repo.update(changeset) do
      :ok
    end
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
