defmodule TenanteeWeb.TenantLive.Add do
  alias TenanteeWeb.TenantLive.Helper
  alias Tenantee.Entity.Tenant
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, Helper.default(socket)}
  end

  def handle_event("change", %{"_target" => [target]} = params, socket) do
    value = params[target]
    {:noreply, assign(socket, String.to_existing_atom(target), value) |> assign(:created, false)}
  end

  def handle_event(
        "create",
        %{"first_name" => first_name, "last_name" => last_name},
        socket
      ) do
    with {:ok, tenant} <-
           Tenant.create(%{
             first_name: first_name,
             last_name: last_name
           }) do
      {:noreply, handle_success(socket, tenant.id, first_name <> " " <> last_name)}
    else
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
    <h1 class="text-3xl font-bold my-4">Create new tenant</h1>
    <form phx-submit="create" class="flex flex-col gap-4 max-w-xs">
      <.input
        phx-change="change"
        type="text"
        name="first_name"
        value={@first_name}
        label="First name"
        placeholder="Tenant's first name"
        required
      />
      <.input
        phx-change="change"
        type="text"
        name="last_name"
        value={@last_name}
        label="Last name"
        placeholder="Tenant's last name"
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
end
