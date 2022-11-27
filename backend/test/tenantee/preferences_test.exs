defmodule Tenantee.PreferencesTest do
  use Tenantee.DataCase
  alias Tenantee.Preferences
  alias Tenantee.Preferences.Schema

  describe "get all preferences" do
    test "returns all preferences" do
      [default_currency] = Preferences.get_preferences()

      assert default_currency.name == :default_currency
      assert default_currency.value == "USD"
    end
  end

  describe "get preference by name" do
    test "found" do
      {:ok, preference} = Preferences.get_preference("default_currency")

      assert preference.name == :default_currency
      assert preference.value == "USD"
    end

    test "not found" do
      {:ok, preference} = Preferences.get_preference("open_exchange_app_id")

      assert preference == nil
    end
  end

  describe "set preference" do
    test "insert" do
      Preferences.set_preference("open_exchange_app_id", "123")
      {:ok, preference} = Preferences.get_preference("open_exchange_app_id")

      assert preference.name == :open_exchange_app_id
      assert preference.value == "123"
    end

    test "update" do
      Preferences.set_preference("default_currency", "EUR")
      {:ok, preference} = Preferences.get_preference("default_currency")

      assert preference.name == :default_currency
      assert preference.value == "EUR"
    end
  end
end
