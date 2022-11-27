defmodule TenanteeWeb.PreferencesController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Preferences
  alias Tenantee.Preferences
  import Tenantee.Utils.Error, only: [respond: 3]

  def list(conn, _params) do
    with preferences <- Preferences.get_preferences() do
      render(conn, "show.json", preferences: preferences)
    end
  end

  def set(conn, %{
        "name" => name,
        "value" => value
      }) do
    case Preferences.set_preference(name, value) do
      {:ok, preference} ->
        render(conn, "show.json", %{preference: preference})

      {:error, _changeset} ->
        respond(conn, :unprocessable_entity, "Invalid preference name")
    end
  end
end
