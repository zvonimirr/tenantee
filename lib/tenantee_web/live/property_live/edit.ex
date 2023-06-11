defmodule TenanteeWeb.PropertyLive.Edit do
  alias Tenantee.Entity.Property
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, assign_defaults(socket, params)}
  end

  def handle_event("change", %{"_target" => [target]} = params, socket) do
    value = params[target]
    {:noreply, assign(socket, String.to_existing_atom(target), value)}
  end

  def handle_event(
        "update",
        %{"name" => name, "description" => description, "address" => address},
        socket
      ) do
    with :ok <-
           Property.update(socket.assigns.id, %{
             name: name,
             description: description,
             address: address
           }) do
      {:noreply, put_flash(socket, :info, "#{name} was updated successfully.")}
    else
      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Error updating the property.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, is_disabled(assigns))

    ~H"""
    <a class="text-gray-500" href={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </a>
    <h1 class="text-3xl font-bold my-4">Edit <%= @name %></h1>
    <form phx-submit="update" class="flex flex-col gap-4 max-w-xs">
      <.input
        phx-change="change"
        type="text"
        name="name"
        value={@name}
        label="Name"
        placeholder="Name of the property"
        required
      />
      <.input
        phx-change="change"
        type="text"
        name="address"
        value={@address}
        label="Address"
        placeholder="Address of the property"
        required
      />
      <.input
        phx-change="change"
        type="textarea"
        name="description"
        value={@description}
        label="Description"
        placeholder="Description of the property"
      />

      <.button type="submit" disabled={@disabled} phx-disable-with="Updating...">
        Update
      </.button>
    </form>
    """
  end

  defp assign_defaults(socket, %{"id" => id}) do
    with {:ok, property} <- Property.get(id) do
      assign(socket, :name, property.name)
      |> assign(:address, property.address)
      |> assign(:description, property.description)
      |> assign(:id, id)
    end
  end

  defp is_disabled(assigns) do
    [
      assigns.name,
      assigns.address
    ]
    |> Enum.any?(&(String.length(&1) == 0))
  end
end
