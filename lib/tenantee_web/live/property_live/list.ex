defmodule TenanteeWeb.PropertyLive.List do
  alias Tenantee.Entity.Property
  alias Tenantee.Entity.Tenant
  use TenanteeWeb, :live_view
  import TenanteeWeb.Components.Property, only: [card: 1]
  import TenanteeWeb.Components.Tenant, only: [list_item: 1]

  def mount(_params, _session, socket) do
    {:ok, default(socket)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Property.get(id) do
      {:ok, property} ->
        {:noreply, assign(socket, property: property, action: "delete")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Property not found")}
    end
  end

  def handle_event("manage_tenants", %{"id" => id}, socket) do
    case Property.get(id) do
      {:ok, property} ->
        {:noreply, assign(socket, property: property, action: "manage_tenants")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Property not found")}
    end
  end

  def handle_event("do_delete", %{"id" => id}, socket) do
    case Property.delete(id) do
      :ok ->
        {:noreply,
         assign(socket, properties: Property.all(), property: nil)
         |> put_flash(:info, "Property deleted successfully")}

      _error ->
        {:noreply, put_flash(socket, :error, "Property not found")}
    end
  end

  def handle_event("cancel_delete", _, socket) do
    {:noreply, assign(socket, action: nil, property: nil)}
  end

  def handle_event("toggle_lease", %{"property" => property_id, "tenant" => tenant_id}, socket) do
    with {:ok, property} <- Property.get(property_id),
         {:ok, tenant} <- Tenant.get(tenant_id),
         :ok <- Property.toggle_lease(property, tenant),
         {:ok, property} <- Property.get(property_id) do
      {:noreply,
       assign(socket, properties: Property.all(), property: property)
       |> put_flash(:info, "Lease updated successfully.")}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Something went wrong.")}
    end
  end

  def render(assigns) do
    ~H"""
    <%= if @action == "delete" and not is_nil(@property) do %>
      <.modal id="confirm-modal" show>
        <p class="text-2xl mb-4 font-bold">Are you sure?</p>
        <p class="text-gray-500">This action cannot be undone.</p>
        <p class="text-gray-500"><%= @property.name %> will be gone forever.</p>
        <p class="text-gray-500 mb-4">
          This will also delete all the tenants and leases associated with this property.
        </p>
        <div class="flex justify-end gap-4">
          <.button
            phx-click="do_delete"
            phx-value-id={@property.id}
            class="ml-2 bg-red-500 hover:bg-red-600"
          >
            Delete
          </.button>
          <.button phx-click="cancel_delete">Cancel</.button>
        </div>
      </.modal>
    <% end %>
    <%= if @action == "manage_tenants" and not is_nil(@property) do %>
      <.modal id="manage-tenants-modal" show>
        <p class="text-2xl mb-4 font-bold">Manage tenants</p>
        <p class="text-gray-500">
          Toggling the checkbox will add or remove the tenant from the property.
        </p>
        <p class="text-gray-500 mb-4">
          Tenants with a lease will be shown in green.
        </p>
        <div class="flex flex-col gap-4 mb-4 items-start">
          <%= for tenant <- Tenant.all() do %>
            <.list_item tenant={tenant} property={@property} />
          <% end %>
        </div>

        <.button phx-click="cancel_delete" class="ml-2 bg-red-500 hover:bg-red-600">
          Cancel
        </.button>
      </.modal>
    <% end %>
    <h1 class="text-3xl font-bold mb-4">Manage your properties</h1>
    <%= if @properties == [] do %>
      <p class="text-gray-500 mb-4">You don't have any properties yet.</p>
      <a href={~p"/properties/new"}>
        <.button>Why not add one?</.button>
      </a>
    <% else %>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
        <%= for property <- @properties do %>
          <.card property={property} />
        <% end %>
      </div>
      <a href={~p"/properties/new"}>
        <.button class="mt-4">
          <.icon name="hero-home" /> Add another property
        </.button>
      </a>
    <% end %>
    """
  end

  defp default(socket) do
    socket
    |> assign(:properties, Property.all())
    |> assign(:property, nil)
    |> assign(:action, nil)
  end
end
