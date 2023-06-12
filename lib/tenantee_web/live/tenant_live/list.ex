defmodule TenanteeWeb.TenantLive.List do
  alias Tenantee.Entity.Tenant
  use TenanteeWeb, :live_view
  import TenanteeWeb.Components.Tenant, only: [card: 1]

  def mount(_params, _session, socket) do
    {:ok, default(socket)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Tenant.get(id) do
      {:ok, tenant} ->
        {:noreply, assign(socket, tenant: tenant)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Tenant not found")}
    end
  end

  def handle_event("do_delete", %{"id" => id}, socket) do
    case Tenant.delete(id) do
      :ok ->
        {:noreply,
         assign(socket, tenants: Tenant.all(), tenant: nil)
         |> put_flash(:info, "Tenant deleted successfully")}

      _error ->
        {:noreply, put_flash(socket, :error, "Tenant not found")}
    end
  end

  def handle_event("cancel_delete", _, socket) do
    {:noreply, assign(socket, tenant: nil)}
  end

  def render(assigns) do
    ~H"""
    <%= if @tenant do %>
      <.modal id="confirm-modal" show>
        <p class="text-2xl mb-4 font-bold">Are you sure?</p>
        <p class="text-gray-500">This action cannot be undone.</p>
        <p class="text-gray-500">
          <%= @tenant.first_name %> <%= @tenant.last_name %> will be gone forever.
        </p>
        <p class="text-gray-500 mb-4">
          This will also delete all leases associated with this tenant.
        </p>
        <div class="flex justify-end gap-4">
          <.button
            phx-click="do_delete"
            phx-value-id={@tenant.id}
            class="ml-2 bg-red-500 hover:bg-red-600"
          >
            Delete
          </.button>
          <.button phx-click="cancel_delete">Cancel</.button>
        </div>
      </.modal>
    <% end %>
    <h1 class="text-3xl font-bold mb-4">Manage your tenants</h1>
    <%= if @tenants == [] do %>
      <p class="text-gray-500 mb-4">You don't have any tenants yet.</p>
      <a href={~p"/tenants/new"}>
        <.button>Why not add one?</.button>
      </a>
    <% else %>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <%= for tenant <- @tenants do %>
          <.card tenant={tenant} />
        <% end %>
      </div>
      <a href={~p"/tenants/new"}>
        <.button class="mt-4">
          <.icon name="hero-home" /> Add another tenant
        </.button>
      </a>
    <% end %>
    """
  end

  defp default(socket) do
    socket
    |> assign(:tenants, Tenant.all())
    |> assign(:tenant, nil)
  end
end
