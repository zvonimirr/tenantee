defmodule Tenantee.Entity.Expense do
  @moduledoc """
  Helper functions for expenses.
  """
  alias Tenantee.Config
  alias Tenantee.Repo
  alias Tenantee.Schema.Expense, as: Schema
  import Ecto.Query, only: [from: 2]

  @doc """
  Gets all expenses that were paid this month by the landlord, sums them up and returns the total.
  """
  @spec get_loss() :: {:ok, Money.t()} | {:error, String.t()}
  def get_loss() do
    currency = Config.get(:currency, nil)

    {:ok, start_date} =
      Date.utc_today() |> Date.beginning_of_month() |> DateTime.new(~T[00:00:00])

    {:ok, end_date} =
      Date.utc_today() |> Date.end_of_month() |> DateTime.new(~T[23:59:59])

    result =
      from(e in Schema,
        select: fragment("SUM(amount)"),
        where:
          fragment(
            "? BETWEEN ? AND ?",
            e.updated_at,
            type(^start_date, :utc_datetime_usec),
            type(^end_date, :utc_datetime_usec)
          ) and
            is_nil(e.tenant_id) and
            e.paid == true
      )
      |> Repo.one()

    do_get_loss(result, currency)
  end

  @doc """
  Creates a new expense.
  """
  @spec create(map()) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.error()}
  def create(attrs) do
    attrs =
      Map.update(attrs, :tenant_id, "landlord", fn v ->
        if v == "landlord", do: nil, else: v
      end)

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
  Deletes an expense by ID.
  """
  @spec delete(integer()) :: :ok | {:error, String.t()}
  def delete(id) do
    with {:ok, expense} <- get(id),
         {:ok, _} <- Repo.delete(expense) do
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

  defp do_get_loss(_, nil), do: {:error, "Could not calculate loss"}
  defp do_get_loss(nil, currency), do: {:ok, Money.new(0, currency)}
  defp do_get_loss({_currency, amount}, currency), do: {:ok, Money.new(amount, currency)}
end
