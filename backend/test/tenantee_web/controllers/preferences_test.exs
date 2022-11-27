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

  describe "PUT /api/preferences" do
    test "happy create path", %{conn: conn} do
      conn =
        put(conn, "/api/preferences", %{
          "name" => "name",
          "value" => "EUR"
        })

      assert json_response(conn, 200)["name"] == "name"
    end

    test "happy update path", %{conn: conn} do
      %Schema{}
      |> Schema.changeset(%{
        name: :default_currency,
        value: "USD"
      })
      |> Repo.insert!()

      conn =
        put(conn, "/api/preferences", %{
          "name" => "default_currency",
          "value" => "EUR"
        })

      assert json_response(conn, 200)["name"] == "default_currency"
    end

    test "invalid name", %{conn: conn} do
      conn =
        put(conn, "/api/preferences", %{
          "name" => "invalid",
          "value" => "EUR"
        })

      assert json_response(conn, 422)["message"] == "Invalid preference name"
    end
  end
end
