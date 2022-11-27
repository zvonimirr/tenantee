defmodule TenanteeWeb.PreferencesControllerTest do
  use TenanteeWeb.ConnCase
  alias Tenantee.Repo
  alias Tenantee.Preferences.Schema

  describe "GET /api/preferences" do
    test "returns all preferences", %{conn: conn} do
      %Schema{}
      |> Schema.changeset(%{
        name: :default_currency,
        value: "USD"
      })
      |> Repo.insert!()

      conn = get(conn, "/api/preferences")
      assert json_response(conn, 200)["properties"] != []
    end
  end
end
