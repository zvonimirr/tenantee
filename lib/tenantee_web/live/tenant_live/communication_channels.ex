defmodule TenanteeWeb.TenantLive.CommunicationChannels do
  alias Tenantee.Entity.{Tenant, CommunicationChannel}
  alias TenanteeWeb.TenantLive.Helper
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
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
    ~H"""
    <.link class="text-gray-500" navigate={~p"/tenants"}>
      <.icon name="hero-arrow-left" /> Back to tenants
    </.link>
    <div class="col-span-2 md:col-span-1">
      <h1 class="text-3xl font-bold my-4">
        Communication channels for <%= @first_name %> <%= @last_name %>
      </h1>
      <%= if @communication_channels != [] do %>
        <div
          id="communication-channels-container"
          class="flex flex-col gap-4 max-w-xs"
          phx-hook="CopyHook"
        >
          <%= for communication_channel <- @communication_channels do %>
            <p class="text-gray-500 communication-channel">
              <%= communication_channel.type %>
              <span class="text-gray-400">
                (<%= communication_channel.value %>)
              </span>
              <span class="mx-4">
                <.button
                  id={"copy-#{communication_channel.id}"}
                  data-copy
                  data-value={communication_channel.value}
                  data-tooltip="Copy"
                >
                  <.icon name="hero-clipboard" />
                </.button>
                <.button
                  class="bg-red-500 hover:bg-red-600 disabled:bg-red-500 disabled:cursor-not-allowed disabled:hover:bg-red-600"
                  phx-click="delete_communication_channel"
                  phx-value-id={communication_channel.id}
                  phx-disable-with="..."
                  data-tooltip="Delete"
                >
                  <.icon name="hero-trash" />
                </.button>
              </span>
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
    """
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
