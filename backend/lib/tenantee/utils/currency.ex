defmodule Tenantee.Utils.Currency do
  @moduledoc """
  This module provides utility functions for working with currencies.
  """
  alias Tenantee.Preferences
  alias Money.ExchangeRates.Retriever

  @doc """
  Checks if the given currency is valid.
  """
  def valid?(currency) do
    currencies = Cldr.known_currencies() |> Enum.map(&Atom.to_string(&1))

    if currency in currencies do
      :ok
    else
      {:error, "Invalid currency"}
    end
  end

  # coveralls-ignore-start
  # Don't want to waste my App quota on testing

  @doc """
  Convert the given amount to the default currency.
  """
  def convert(%{
        amount: amount,
        currency: old_currency
      }) do
    with money <- Money.new(amount, old_currency),
         {:ok, app_id} <- Preferences.get_preference("open_exchange_app_id"),
         {:ok, config} <- get_retreiver_config(app_id),
         Retriever.reconfigure(config),
         {:ok, %{value: currency}} <- Preferences.get_preference("default_currency", "USD"),
         :ok <- valid?(currency),
         {:ok, money} <- Money.to_currency(money, currency) do
      money
    else
      _error -> Money.new(amount, old_currency)
    end
  end

  defp get_retreiver_config(app_id) do
    if not is_nil(app_id) and Map.has_key?(app_id, :value) do
      {:ok,
       %Money.ExchangeRates.Config{
         retrieve_every: :never,
         api_module: Money.ExchangeRates.OpenExchangeRates,
         callback_module: Money.ExchangeRates.Callback,
         log_levels: %{failure: :warn, info: :info, success: nil},
         preload_historic_rates: nil,
         retriever_options: %{
           app_id: app_id.value,
           url: "https://openexchangerates.org/api"
         },
         cache_module: Money.ExchangeRates.Cache.Ets,
         verify_peer: true
       }}
    else
      {:error, "Open Exchange App ID is not set"}
    end
  end

  # coveralls-ignore-stop
end
