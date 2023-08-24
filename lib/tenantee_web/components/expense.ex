defmodule TenanteeWeb.Components.Expense do
  @moduledoc """
  Provides UI components for the Expense context.
  """
  use Phoenix.Component
  import TenanteeWeb.CoreComponents
  alias Phoenix.LiveView.JS

  @doc """
  Renders a expense card.
  """
  attr :expense, :map, required: true
  attr :paid, :boolean, default: false

  def card(assigns) do
    ~H"""
    <div class="flex flex-col gap-2 border border-gray-200 rounded-md p-4 max-w-xs">
      <div class="flex justify-between">
        <span class="text-lg font-semibold"><%= @expense.name %></span>
        <.button
          id={"delete_expense_#{@expense.id}"}
          class="bg-red-500 text-white hover:bg-red-600"
          data-tooltip="Delete expense"
          phx-click={open_confirm_modal(@expense.id)}
        >
          <.icon name="hero-trash" />
        </.button>
      </div>
      <span class="text-sm text-gray-500"><%= @expense.description %></span>
      <span class="text-gray-500 text-sm">
        To be paid by
        <%= if @expense.tenant do %>
          <%= @expense.tenant.first_name %>
          <%= @expense.tenant.last_name %>.
        <% else %>
          <span class="text-red-500">you.</span>
        <% end %>
      </span>
      <span class="text-lg text-gray-500"><%= @expense.amount %></span>
      <%= if @paid do %>
        <.button class="text-white rounded-md p-2 opacity-50 cursor-not-allowed hover:bg-green-500">
          <.icon name="hero-check" /> Paid
        </.button>
      <% else %>
        <.button
          id={"expense_#{@expense.id}"}
          phx-click={pay_expense("expense_#{@expense.id}", @expense.id)}
          phx-value-id={@expense.id}
          class="bg-green-500 text-white rounded-md p-2 disabled:opacity-50"
        >
          <.icon name="hero-check" /> Pay
        </.button>
      <% end %>
    </div>
    """
  end

  defp pay_expense(id, expense_id) do
    JS.set_attribute({"disabled", true}, to: "##{id}")
    |> JS.push("pay", value: %{id: expense_id})
  end
end
