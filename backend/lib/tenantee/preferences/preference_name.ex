defmodule Tenantee.Preferences.PreferenceName do
  use EctoEnum, type: :preference_name, enums: [:default_currency, :name, :open_exchange_app_id]
end
