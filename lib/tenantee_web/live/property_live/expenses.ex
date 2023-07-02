defmodule TenanteeWeb.PropertyLive.Expenses do
  alias Tenantee.Entity.Expense
  alias TenanteeWeb.PropertyLive.Helper
  import TenanteeWeb.Components.Expense
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
          <.card expense={expense} />
        <% end %>
      </div>

      <hr class="my-4" />

      <h2 class="text-xl font-bold">Paid</h2>
      <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-2">
        <%= for expense <- @expense_groups.paid do %>
          <.card expense={expense} paid />
        <% end %>
      </div>
    </div>
    """
  end

  defp group_expenses(expenses) do
    expenses
    |> Enum.group_by(&if &1.paid, do: :paid, else: :unpaid)
  end
end
