defmodule TenanteeWeb.Components.Rent do
  @moduledoc """
  Provides UI components for the Rent context.
  """
  alias Phoenix.LiveView.JS
  alias Tenantee.Cldr
  use Phoenix.Component
  import TenanteeWeb.CoreComponents

  @doc """
  Renders a rent list item.
  """
  attr :rent, :map, required: true

  def list_item(assigns) do
    bgcolor = if assigns.rent.paid, do: "bg-green-500", else: "bg-red-500 hover:bg-red-500"

    class = [
      bgcolor,
      "disabled:opacity-50 disabled:cursor-not-allowed"
    ]

    assigns = assign(assigns, class: class |> Enum.join(" "))

    ~H"""
    <div class={[
      "flex items-center gap-2 shadow-lg border border-gray-200 rounded-lg p-4 text-black font-semibold",
      @rent.paid && "bg-green-100",
      not @rent.paid && "bg-red-100"
    ]}>
      <p class={[@rent.paid && "line-through"]}>
        <%= Cldr.format_date(@rent.due_date) %> (<%= Cldr.format_price(@rent.amount) %>)
      </p>
      <.button
        id={"rent_#{@rent.id}"}
        phx-click={pay_rent("rent_#{@rent.id}", @rent.id)}
        phx-value-rent={@rent.id}
        class={@class}
        disabled={@rent.paid}
      >
        <%= (@rent.paid && "Paid") || "Pay" %>
      </.button>
    </div>
    """
  end

  defp pay_rent(id, rent_id) do
    JS.set_attribute({"disabled", true}, to: "##{id}")
    |> JS.push("pay", value: %{rent: rent_id})
  end
end
