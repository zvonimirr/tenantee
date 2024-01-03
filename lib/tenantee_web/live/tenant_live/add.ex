defmodule TenanteeWeb.TenantLive.Add do
  alias TenanteeWeb.TenantLive.Helper
  alias Tenantee.Entity.Tenant
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, Helper.default(socket)}
  end

  def handle_event(
        "create",
        %{"first_name" => first_name, "last_name" => last_name},
        socket
      ) do
    case Tenant.create(%{
           first_name: first_name,
           last_name: last_name
         }) do
      {:ok, tenant} ->
        {:noreply, handle_success(socket, tenant.id, first_name <> " " <> last_name)}

      {:error, _reason} ->
        {:noreply, handle_error(socket, first_name, last_name)}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.submit_disabled?(assigns))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/tenants"}>
      <.icon name="hero-arrow-left" /> Back to tenants
    </.link>
    <h1 class="text-3xl font-bold my-4">Create new tenant</h1>
    <form
      id="tenant-add-form"
      phx-hook="FormHook"
      phx-submit="create"
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

      <.button type="submit" disabled={@disabled} phx-disable-with="Creating...">
        Create
      </.button>
    </form>
    """
  end

  def handle_success(socket, id, name) do
    put_flash(socket, :info, "#{name} was created successfully.")
    |> push_navigate(to: ~p"/tenants/#{id}")
  end

  def handle_error(socket, first_name, last_name) do
    socket
    |> assign(:first_name, first_name)
    |> assign(:last_name, last_name)
    |> put_flash(:error, "Something went wrong. Please try again.")
  end
end
