defmodule TenanteeWeb.PropertyLive.Expenses do
  alias Tenantee.Entity.Expense
  alias TenanteeWeb.PropertyLive.Helper
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def handle_event("pay", %{"id" => expense_id}, socket) do
    case Expense.pay(expense_id) do
      :ok ->
        {:noreply,
         Helper.default(socket, %{"id" => socket.assigns.id})
         |> put_flash(:info, "Expense paid successfully")
         |> push_event("phx:enable", %{id: "expense_#{expense_id}"})}

      _error ->
        {:noreply,
         put_flash(socket, :error, "Something went wrong.")
         |> push_event("phx:enable", %{id: "expnese_#{expense_id}"})}
    end
  end

  # TODO: add expense card component
  # TODO: allow deletion of expenses
  # TODO  allow editing of expenses?
  # TODO: allow adding of expenses

  def render(assigns) do
    assigns = assign(assigns, :expense_groups, group_expenses(assigns.expenses))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </.link>
    <div class="flex flex-col gap-4">
      <h1 class="text-2xl font-bold">Expenses</h1>
      <h2 class="text-xl font-bold">Unpaid</h2>
      <div
        id="unpaid-expenses-container"
        class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-2"
        phx-hook="ModalHook"
      >
        <%= for expense <- @expense_groups.unpaid do %>
          <div class="flex flex-col gap-2 border border-gray-200 rounded-md p-4 max-w-xs">
            <span class="text-lg font-semibold"><%= expense.name %></span>
            <span class="text-sm text-gray-500"><%= expense.description %></span>
            <span class="text-gray-500 text-sm">
              To be paid by
              <%= if expense.tenant do %>
                <%= expense.tenant.first_name %>
                <%= expense.tenant.last_name %>.
              <% else %>
                <span class="text-red-500">you.</span>
              <% end %>
            </span>
            <span class="text-lg text-gray-500"><%= expense.amount %></span>

            <.button
              id={"expense_#{expense.id}"}
              phx-click={pay_expense("expense_#{expense.id}", expense.id)}
              phx-value-id={expense.id}
              class="bg-green-500 text-white rounded-md p-2 disabled:opacity-50"
            >
              <.icon name="hero-check" /> Pay
            </.button>
          </div>
        <% end %>
      </div>

      <hr class="my-4" />

      <h2 class="text-xl font-bold">Paid</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-2">
        <%= for expense <- @expense_groups.paid do %>
          <div class="flex flex-col gap-2 border border-gray-200 rounded-md p-4 max-w-xs">
            <span class="text-lg font-semibold"><%= expense.name %></span>
            <span class="text-sm text-gray-500"><%= expense.description %></span>
            <span class="text-gray-500 text-sm">
              Paid by
              <%= if expense.tenant do %>
                <%= expense.tenant.first_name %>
                <%= expense.tenant.last_name %>.
              <% else %>
                <span class="text-red-500">you.</span>
              <% end %>
            </span>
            <span class="text-lg text-gray-500"><%= expense.amount %></span>

            <.button class="text-white rounded-md p-2 opacity-50 cursor-not-allowed hover:bg-green-500">
              <.icon name="hero-check" /> Paid
            </.button>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp group_expenses(expenses) do
    expenses
    |> Enum.group_by(&if &1.paid, do: :paid, else: :unpaid)
  end

  defp pay_expense(id, expense_id) do
    JS.set_attribute({"disabled", true}, to: "##{id}")
    |> JS.push("pay", value: %{id: expense_id})
  end
end
