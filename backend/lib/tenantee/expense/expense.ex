defmodule Tenantee.Expense do
  @moduledoc """
  This module contains all the necessary functions for managing expenses.
  """

  import Ecto.Query
  alias Tenantee.Repo
  alias Tenantee.Expense.Schema

  @doc """
  Creates a new expense.
  """
  def create_expense(property_id, attrs) do
    with {:ok, expense} <-
           %Schema{}
           |> Schema.changeset(Map.merge(attrs, %{property_id: property_id}))
           |> Repo.insert() do
      {:ok, expense}
    end
  end

  @doc """
  Gets an expense by ID.
  """
  def get_expense(expense_id) do
    case Repo.get(Schema, expense_id) do
      nil -> {:error, :not_found}
      expense -> {:ok, expense}
    end
  end

  @doc """
  Updates an expense.
  """
  def update_expense(expense_id, attrs) do
    with {:ok, expense} <- get_expense(expense_id),
         {:ok, expense} <-
           expense
           |> Schema.changeset(attrs)
           |> Repo.update() do
      {:ok, expense}
    end
  end

  @doc """
  Deletes an existing expense.
  """
  def delete_expense(expense_id) do
    with {affected_rows, nil} <-
           from(e in Schema, where: e.id == ^expense_id)
           |> Repo.delete_all() do
      if affected_rows > 0, do: {:ok, :deleted}, else: {:error, :not_found}
    end
  end
end
