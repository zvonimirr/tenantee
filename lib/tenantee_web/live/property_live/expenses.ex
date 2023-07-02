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

  def handle_event("delete", %{"id" => id}, socket) do
    case Expense.get(id) do
      {:ok, expense} -> {:noreply, assign(socket, expense: expense)}
      {:error, _} -> {:noreply, put_flash(socket, :error, "Expense not found")}
    end
  end

  def handle_event("do_delete", %{"id" => id}, socket) do
    case Expense.delete(id) do
      :ok ->
        {:noreply,
         Helper.default(socket, %{"id" => socket.assigns.id})
         |> put_flash(:info, "Expense deleted successfully")}

      _error ->
        {:noreply, put_flash(socket, :error, "Something went wrong.")}
    end
  end

  def handle_event("cancel_delete", _, socket) do
    {:noreply, assign(socket, expense: nil)}
  end

  # TODO  allow editing of expenses?
  # TODO: allow adding of expenses

  def render(assigns) do
    assigns = assign(assigns, :expense_groups, group_expenses(assigns.expenses))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </.link>
    <%= if not is_nil(@expense) do %>
      <.modal id="confirm-modal" show>
        <p class="text-2xl mb-4 font-bold">Are you sure?</p>
        <p class="text-gray-500">This action cannot be undone.</p>
        <div class="flex gap-4 mt-4">
          <.button
            id="delete-expense"
            phx-click={do_delete("delete-expense", @expense.id)}
            phx-value-id={@expense.id}
            class="ml-2 bg-red-500 hover:bg-red-600 disabled:hover:bg-red-600"
          >
            Delete
          </.button>
          <.button phx-click="cancel_delete">Cancel</.button>
        </div>
      </.modal>
    <% end %>
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
