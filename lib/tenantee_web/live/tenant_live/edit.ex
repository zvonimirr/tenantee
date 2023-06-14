defmodule TenanteeWeb.TenantLive.Edit do
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

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.is_submit_disabled?(assigns))

    ~H"""
    <a class="text-gray-500" href={~p"/tenants"}>
      <.icon name="hero-arrow-left" /> Back to tenants
    </a>
    <h1 class="text-3xl font-bold my-4">Edit <%= @first_name %> <%= @last_name %></h1>
    <form
      id="tenant-edit-form"
      phx-hook="FormHook"
      phx-submit="update"
      class="flex flex-col gap-4 max-w-xs"
      data-required="first_name,last_name"
    >
      <.input
        type="text"
        name="first_name"
        value={@first_name}
        label="First name"
        placeholder="Tenant's first name"
        required
      />
      <.input
        type="text"
        name="last_name"
        value={@last_name}
        label="Last name"
        placeholder="Tenant's last name"
        required
      />

      <.button type="submit" disabled={@disabled} phx-disable-with="Updating...">
        Update
      </.button>
    </form>
    """
  end

  def handle_success(socket, first_name, last_name) do
    name = "#{first_name} #{last_name}"

    socket
    |> assign(:first_name, first_name)
    |> assign(:last_name, last_name)
    |> put_flash(:info, "#{name} was updated successfully.")
  end
end
