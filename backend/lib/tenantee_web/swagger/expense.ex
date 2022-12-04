defmodule TenanteeWeb.Swagger.Expense do
  @moduledoc """
  Swagger schema for Expense
  """
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      swagger_path :add do
        post("/api/expenses/{id}")
        summary("Add a new expense")

        parameters do
          id(:path, :integer, "Property ID", required: true)
          amount(:body, :float, "Amount", required: true)
          description(:body, :string, "Description")
        end

        response(200, "Expense created", Schema.ref(:Expense))
        response(422, "Invalid request")
      end

      swagger_path :monthly do
        get("/api/expenses/monthly")
        summary("Get monthly expenses")

        response(200, "Monthly expenses", Schema.ref(:ExpenseList))
      end

      swagger_path :find do
        get("/api/expenses/{id}")
        summary("Find expense by ID")

        parameters do
          id(:path, :integer, "Expense ID", required: true)
        end

        response(200, "Expense found", Schema.ref(:Expense))
        response(404, "Expense not found")
      end

      swagger_path :update do
        patch("/api/expenses/{id}")
        summary("Update an expense")

        parameters do
          id(:path, :integer, "Expense ID", required: true)
          amount(:body, :float, "Amount", required: true)
          description(:body, :string, "Description")
        end

        response(200, "Expense updated", Schema.ref(:Expense))
        response(422, "Could not update expense")
      end

      swagger_path :delete_by_id do
        delete("/api/expenses/{id}")
        summary("Delete an expense")

        parameters do
          id(:path, :integer, "Expense ID", required: true)
        end

        response(204, "Expense deleted")
        response(404, "Expense not found")
      end

      def swagger_definitions do
        %{
          Expense:
            swagger_schema do
              title("Expense")
              description("An expense")

              properties do
                id(:integer, "The expense id", required: true)
                amount(Schema.ref(:Price), "The amount of the expense", required: true)
                description(:string, "The description of the expense")
                date(:string, "The date of the expense", required: true)

                property(Schema.ref(:Property), "The property the expense belongs to",
                  required: true
                )
              end
            end,
          ExpenseList:
            swagger_schema do
              title("Expense List")
              description("A list of expenses")

              properties do
                expenses(:array, "The list of expenses", items: Schema.ref(:Expense))
              end
            end
        }
      end
    end
  end
end
