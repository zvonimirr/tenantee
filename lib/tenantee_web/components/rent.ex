defmodule TenanteeWeb.Components.Rent do
  @moduledoc """
  Provides UI components for the Rent context.
  """
  alias Tenantee.Cldr
  use Phoenix.Component
  import TenanteeWeb.CoreComponents

  @doc """
  Renders a rent list item.
  """
  attr :rent, :map, required: true

  def list_item(assigns) do
    ~H"""
    <div class={[
      "flex items-center gap-2 shadow-lg border border-gray-200 rounded-lg p-4 text-black font-semibold",
      @rent.paid && "bg-green-100",
      not @rent.paid && "bg-red-100"
    ]}>
      <p class={[@rent.paid && "line-through"]}>
        <%= Cldr.format_date(@rent.due_date) %> (<%= format_price(@rent.amount) %>)
      </p>
      <.button
        phx-click="pay_rent"
        phx-value-rent={@rent.id}
        class={[
          "disabled:opacity-50 disabled:cursor-not-allowed",
          @rent.paid && "bg-green-500",
          not @rent.paid && "bg-red-500 hover:bg-red-600"
        ]}
        disabled={@rent.paid}
      >
        <%= (@rent.paid && "Paid") || "Pay" %>
      </.button>
    </div>
    """
  end

  defp format_price(price) do
    with {:ok, formatted_price} <- Cldr.Money.to_string(price, symbol: true) do
      formatted_price
    end
  end
end
