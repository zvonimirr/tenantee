defmodule TenanteeWeb.TenantLive.Edit do
  alias Tenantee.Entity.CommunicationChannel
  alias TenanteeWeb.TenantLive.Helper
  alias Tenantee.Entity.Tenant
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def handle_event(
        "update",
        %{"first_name" => first_name, "last_name" => last_name},
        socket
      ) do
    case Tenant.update(socket.assigns.id, %{
           first_name: first_name,
           last_name: last_name
         }) do
      :ok ->
        {:noreply, handle_success(socket, first_name, last_name)}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Something went wrong. Please try again.")}
    end
  end

  def handle_event(
        "add_communication_channel",
        %{"type" => type, "value" => value},
        socket
      ) do
    case Tenant.add_communication_channel(socket.assigns.id, %{
           type: type,
           value: value
         }) do
      :ok ->
        {:noreply, handle_success(socket, type)}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Something went wrong. Please try again.")}
    end
  end

  def handle_event("delete_communication_channel", %{"id" => id}, socket) do
    with {channel_id, ""} <- Integer.parse(id),
         :ok <- CommunicationChannel.delete(channel_id) do
      {:noreply, handle_success(socket, channel_id)}
    else
      _error ->
        {:noreply, put_flash(socket, :error, "Something went wrong. Please try again.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.is_submit_disabled?(assigns))

    ~H"""
    <a class="text-gray-500" href={~p"/tenants"}>
      <.icon name="hero-arrow-left" /> Back to tenants
    </a>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="col-span-2 md:col-span-1">
        <h1 class="text-3xl font-bold my-4">Edit <%= @first_name %> <%= @last_name %></h1>
        <form
          id="tenant-edit-form"
          phx-hook="FormHook"
          phx-submit="update"
          class="flex flex-col gap-4 max-w-xs"
        >
          <.input
            type="text"
            name="first_name"
            value={@first_name}
            label="First name"
            placeholder="Tenant's first name"
            maxlength="255"
            required
          />
          <.input
            type="text"
            name="last_name"
            value={@last_name}
            label="Last name"
            placeholder="Tenant's last name"
            maxlength="255"
            required
          />

          <.button type="submit" disabled={@disabled} phx-disable-with="Updating...">
            Update
          </.button>
        </form>
      </div>
      <div class="col-span-2 md:col-span-1">
        <h1 class="text-3xl font-bold my-4">Communication channels</h1>
        <%= if @communication_channels != [] do %>
          <div class="flex flex-col gap-4 max-w-xs">
            <%= for communication_channel <- @communication_channels do %>
              <p class="text-gray-500 communication-channel">
                <%= communication_channel.type %>
                <span class="text-gray-400">
                  (<%= communication_channel.value %>)
                </span>
                <.button
                  class="mx-4 bg-red-500 hover:bg-red-600 disabled:bg-red-500 disabled:cursor-not-allowed disabled:hover:bg-red-600"
                  phx-click="delete_communication_channel"
                  phx-value-id={communication_channel.id}
                  phx-disable-with="..."
                >
                  <.icon name="hero-trash" />
                </.button>
              </p>
            <% end %>
          </div>
        <% else %>
          <p class="text-gray-500">No communication channels found.</p>
        <% end %>

        <form
          id="communication-channel-add-form"
          class="max-w-xs"
          phx-hook="FormHook"
          phx-submit="add_communication_channel"
        >
          <.input
            type="text"
            name="type"
            label="Type"
            value=""
            placeholder="Channel type"
            maxlength="255"
            required
          />
          <.input
            type="text"
            name="value"
            label="Value"
            value=""
            maxlength="255"
            placeholder="Channel value"
            required
          />

          <.button type="submit" class="mt-3 w-full" disabled phx-disable-with="Adding...">
            Add
          </.button>
        </form>
      </div>
    </div>
    """
  end

  defp handle_success(socket, first_name, last_name) do
    name = "#{first_name} #{last_name}"

    socket
    |> Helper.default(%{"id" => socket.assigns.id})
    |> put_flash(:info, "#{name} was updated successfully.")
  end

  defp handle_success(socket, id) when is_integer(id) do
    socket
    |> Helper.default(%{"id" => socket.assigns.id})
    |> put_flash(:info, "Communication channel was deleted successfully.")
  end

  defp handle_success(socket, type) do
    socket
    |> Helper.default(%{"id" => socket.assigns.id})
    |> put_flash(:info, "Communication channel #{type} was added successfully.")
  end
end
