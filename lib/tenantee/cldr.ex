defmodule Tenantee.Cldr do
  @moduledoc """
  This module is used to configure the Cldr library.
  """
  use Cldr,
    locales: ["en"],
    default_locale: "en",
    providers: [Cldr.Number, Cldr.Calendar, Cldr.DateTime, Money]

  def format_date(date) do
    case Tenantee.Cldr.Date.to_string(date) do
      {:ok, formatted_date} -> formatted_date
      _error -> "Invalid date"
    end
  end

  def format_price(price) do
    with {:ok, formatted_price} <-
           Tenantee.Cldr.Money.to_string(price, symbol: true, no_fraction_if_integer: true) do
      formatted_price
    end
  end

  def pluralize(singular, plural, count) do
    if count == 1 do
      singular
    else
      plural
    end
  end

  def validate_amount(min) do
    fn :amount, amount ->
      min_m = Money.new(min, amount.currency)

      case Money.compare(amount, min_m) do
        :gt -> []
        _ -> [amount: "must be greater than #{min}"]
      end
    end
  end
end
