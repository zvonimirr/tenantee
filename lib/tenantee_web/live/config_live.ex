defmodule TenanteeWeb.ConfigLive do
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    with name <- Config.get(:name, "") do
      {:ok, assign(socket, name: name)}
    end
  end

  def handle_event("change", %{"_target" => [target]} = params, socket) do
    value = params[target]
    {:noreply, assign(socket, String.to_existing_atom(target), value)}
  end

  def handle_event("save", %{"name" => name}, socket) do
    case Config.set(:name, name) do
      :ok ->
        {:noreply, put_flash(socket, :info, "Configuration saved successfully!")}

      :error ->
        {:noreply, put_flash(socket, :error, "Failed to save the configuration!")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, assigns.name |> String.trim() |> String.length() == 0)

    ~H"""
    <h1 class="text-3xl font-bold">Configuration</h1>
    <form phx-submit="save" class="flex flex-col gap-4 max-w-xs">
      <.input phx-change="change" name="name" value={@name} label="Name" placeholder="Your name..." />
      <.button type="submit" disabled={@disabled} phx-disable-with="Saving...">
        Save
      </.button>
    </form>
    """
  end
end
