defmodule TenanteeWeb.Swagger.Preferences do
  @moduledoc """
  Swagger schema for Preferences
  """
  use PhoenixSwagger

  defmacro __using__(_opts) do
    quote do
      use PhoenixSwagger

      swagger_path :list do
        get("/api/preferences")
        summary("List all preferences")

        response(200, "List of preferences", Schema.ref(:PreferenceList))
      end

      swagger_path :set do
        put("/api/preferences")
        summary("Set preference")

        parameters do
          preference(:body, Schema.ref(:Preference), "Preference to set", required: true)
        end

        response(200, "Preference set", Schema.ref(:Preference))
        response(422, "Invalid preference name")
      end

      def swagger_definitions do
        %{
          Preference:
            swagger_schema do
              title("Preference")
              description("A preference")

              properties do
                name(:string, "The name of the preference", required: true)
                value(:string, "The value of the preference", required: true)
              end
            end,
          PreferenceList:
            swagger_schema do
              title("Preference list")
              description("A list of preferences")

              properties do
                preferences(:array, "The list of preferences", items: Schema.ref(:Preference))
              end
            end
        }
      end
    end
  end
end
