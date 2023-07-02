defmodule TenanteeWeb.PropertyLive.Expenses do
  alias Tenantee.Config
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

  def handle_event(
        "create",
        %{
          "name" => name,
          "description" => description,
          "amount" => amount,
          "tenant_id" => payer_id
        },
        socket
      ) do
    with {:ok, currency} <- Config.get(:currency),
         {:ok, _expense} <-
           Expense.create(%{
             name: name,
             description: description,
             amount: Helper.handle_price(amount, currency),
             property_id: socket.assigns.id,
             tenant_id: payer_id
           }) do
      {:noreply,
       Helper.default(socket, %{"id" => socket.assigns.id})
       |> put_flash(:info, "Expense created successfully")}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Something went wrong.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :expense_groups, group_expenses(assigns.expenses))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </.link>

    <details class="mt-4">
      <summary class="cursor-pointer">
        <span class="text-xl font-bold">Add new expense</span>
      </summary>
      <form
        id="expense-add-form"
        phx-hook="FormHook"
        class="flex flex-col gap-2 max-w-xs"
        phx-submit="create"
      >
        <.input type="text" name="name" label="Name" placeholder="Name" value="" required />
        <.input
          type="textarea"
          name="description"
          label="Description"
          placeholder="Description"
          value=""
        />

        <.input
          type="number"
          name="amount"
          min="0.1"
          max="9999999999.9"
          step="0.1"
          value="0.1"
          label="Price"
          placeholder="Price of the expense"
          required
        />

        <.input
          type="select"
          name="tenant_id"
          label="Payer"
          value=""
          required
          options={get_payer_options(@tenants)}
        />

        <.button type="submit" phx-disable-with="Creating...">
          Create
        </.button>
      </form>
    </details>

    <%= if not is_nil(@expense) do %>
      <.modal id="confirm-modal" show>
        <p class="text-2xl mb-4 font-bold">Are you sure?</p>
        <p class="text-gray-500">This action cannot be undone.</p>
        <p class="text-gray-500"><%= @expense.name %> will be gone forever.</p>
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
    <div class="flex flex-col mt-4 gap-4">
      <h1 class="text-2xl font-bold">Expenses</h1>
      <details open>
        <summary class="cursor-pointer">
          <span class="text-xl font-bold">Unpaid</span>
        </summary>
        <div
          id="unpaid-expenses-container"
          class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-2"
          phx-hook="ModalHook"
        >
          <%= for expense <- @expense_groups.unpaid do %>
            <.card expense={expense} />
          <% end %>
        </div>
      </details>

      <hr class="my-2" />

      <details open>
        <summary class="cursor-pointer">
          <span class="text-xl font-bold">Paid</span>
        </summary>
        <div class="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-4 gap-2">
          <%= for expense <- @expense_groups.paid do %>
            <.card expense={expense} paid />
          <% end %>
        </div>
      </details>
    </div>
    """
  end

  defp group_expenses(expenses) do
    expenses
    |> Enum.group_by(&if &1.paid, do: :paid, else: :unpaid)
  end

  defp get_payer_options(tenants) do
    opts =
      tenants
      |> Enum.map(&{&1.first_name, &1.id})

    [{"You", "landlord"} | opts]
  end
end
