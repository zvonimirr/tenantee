defmodule TenanteeWeb.Swagger.Rent do
  @moduledoc """
  Swagger schema for Rent
  """
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      swagger_path :mark_as_paid do
        post("/api/rent/{id}/mark-as-paid")
        summary("Mark rent as paid")

        parameters do
          id(:path, :integer, "Rent ID", required: true)
        end

        response(200, "Rent marked as paid", Schema.ref(:Rent))
      end

      swagger_path :mark_as_unpaid do
        post("/api/rent/{id}/mark-as-unpaid")
        summary("Mark rent as unpaid")

        parameters do
          id(:path, :integer, "Rent ID", required: true)
        end

        response(200, "Rent marked as unpaid", Schema.ref(:Rent))
      end

      def swagger_definitions do
        %{
          Rent:
            swagger_schema do
              title("Rent")
              description("Rent")

              properties do
                id(:integer, "ID", required: true)
                due_date(:string, "Due Date", required: true)
                paid(:boolean, "Paid", required: true)
              end
            end
        }
      end
    end
  end
end
