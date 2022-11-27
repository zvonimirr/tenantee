defmodule TenanteeWeb.PreferencesController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Preferences
  alias Tenantee.Preferences

  def list(conn, _params) do
    with preferences <- Preferences.get_preferences() do
      render(conn, "show.json", preferences: preferences)
    end
  end
end
