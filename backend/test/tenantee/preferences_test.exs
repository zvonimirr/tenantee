defmodule Tenantee.PreferencesTest do
  use Tenantee.DataCase
  alias Tenantee.Preferences
  alias Tenantee.Preferences.Schema

  setup do
    %Schema{}
    |> Schema.changeset(%{name: "default_currency", value: "EUR"})
    |> Repo.insert!()

    :ok
  end

  describe "get all preferences" do
    test "returns all preferences" do
      [default_currency] = Preferences.get_preferences()

      assert default_currency.name == :default_currency
      assert default_currency.value == "EUR"
    end
  end

  describe "get preference by name" do
    test "found" do
      {:ok, preference} = Preferences.get_preference("default_currency")

      assert preference.name == :default_currency
      assert preference.value == "EUR"
    end

    test "not found" do
      {:ok, preference} = Preferences.get_preference("open_exchange_app_id")

      assert preference == nil
    end
  end

  test "set preference" do
    Preferences.set_preference("open_exchange_app_id", "123")
    {:ok, preference} = Preferences.get_preference("open_exchange_app_id")

    assert preference.name == :open_exchange_app_id
    assert preference.value == "123"
  end
end
