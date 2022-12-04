defmodule TenanteeWeb.ExpenseController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Expense
  alias Tenantee.Expense
  import Tenantee.Utils.Error, only: [respond: 3]

  def add(
        conn,
        %{
          "id" => id,
          "amount" => %{
            "amount" => expense,
            "currency" => currency
          }
        } = params
      ) do
    with {:ok, amount} <- get_price(expense, currency),
         params <- Map.replace(params, "amount", amount),
         params <- Map.put_new(params, "property_id", id),
         params <- Map.delete(params, "id"),
         {:ok, expense} <- Expense.create_expense(params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{expense: expense})
    end
  end

  def add(conn, _params), do: respond(conn, :unprocessable_entity, "Invalid parameters")

  def find(conn, %{"id" => id}) do
    case Expense.get_expense(id) do
      {:ok, expense} ->
        conn
        |> render("show.json", %{expense: expense})

      {:error, _error} ->
        respond(conn, :not_found, "Expense not found")
    end
  end

  def update(
        conn,
        %{"id" => id, "amount" => %{"amount" => expense, "currency" => currency}} = params
      ) do
    with {:ok, amount} <- get_price(expense, currency),
         params <- Map.replace(params, "amount", amount),
         {:ok, expense} <- Expense.update_expense(id, params) do
      conn
      |> render("show.json", %{expense: expense})
    else
      {:error, :not_found} -> respond(conn, :not_found, "Expense not found")
      {:error, "Invalid price"} -> respond(conn, :unprocessable_entity, "Invalid price")
    end
  end

  def update(conn, _params), do: respond(conn, :unprocessable_entity, "Invalid parameters")

  def delete_by_id(conn, %{"id" => id}) do
    case Expense.delete_expense(id) do
      {:ok, :deleted} ->
        respond(conn, :ok, "Expense deleted")

      {:error, :not_found} ->
        respond(conn, :not_found, "Expense not found")
    end
  end

  def monthly(conn, _params),
    do: render(conn, "show.json", %{expenses: Expense.get_monthly_expenses()})

  defp get_price(price, currency) when is_binary(price) do
    case price |> Decimal.parse() do
      :error -> {:error, "Invalid price"}
      {price, _junk} -> {:ok, Money.from_float(Decimal.to_float(price), currency)}
    end
  end

  defp get_price(price, currency) when is_number(price) do
    if is_float(price) do
      {:ok, Money.from_float(price, currency)}
    else
      {:ok, Money.new(price, currency)}
    end
  end
end
