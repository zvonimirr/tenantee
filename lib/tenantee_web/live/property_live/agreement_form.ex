defmodule TenanteeWeb.PropertyLive.Agreement do
  alias TenanteeWeb.PropertyLive.Helper
  alias Tenantee.Config
  alias Tenantee.Entity.Property
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def handle_event(
        "rent-agreement",
        %{
          "tenant_name" => tenant_name,
          "rent_amount" => rent_amount,
          "lease_term" => lease_term,
          "start_date" => start_date,
          "end_date" => end_date,
          "security_deposit" => security_deposit,
          "additional_terms" => additional_terms
        },
        socket
      ) do
    with :ok <- Property.create_agreement(socket.assigns.id, %{
                "tenant_name" => tenant_name,
                "rent_amount" => to_string(rent_amount),
                "lease_term" => to_string(lease_term),
                "start_date" => to_string(start_date),
                "end_date" => to_string(end_date),
                "security_deposit" => to_string(security_deposit),
                "additional_terms" => additional_terms
              }),
         {:ok, property} <- Property.get(socket.assigns.id) do
      {:noreply, handle_success(socket, property.name, property)}
    else
      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Something went wrong, please try again.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.is_submit_disabled?(assigns))

    #getting the list of tenants
    options = for tenant <- assigns.tenants do
      "#{tenant.first_name} #{tenant.last_name}"
    end
    options = options ++ ["None"]

    #assigning to assigns
    assigns = assign(assigns, :options, options)

    ~H"""

    <.link class="text-gray-500" navigate={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to property card
    </.link>

    <h1 class="text-3xl font-bold my-4">Create new agreement</h1>

    <form
      id="agreement-form"
      phx-hook="FormHook"
      phx-submit="rent-agreement"
      class="flex flex-col gap-4 max-w-xs"
    >

    <.input
      type="select"
      id = "tenant_name"
      name="tenant_name"
      value={@agreement_params["tenant_name"]}
      options={@options}
      label="Tenant:"
      prompt="Tenant.."
    />

    <.input
      type="number"
      id="rent_amount"
      name="rent_amount"
      value=""
      label="Monthly Rent Amount:"
      placeholder=""
      maxlength=""
      required
    />

    <.input
      type="number"
      id="lease_term"
      name="lease_term"
      value=""
      label="Lease Term (in months):"
      placeholder=""
      maxlength=""
      required
    />

    <.input
      type="date"
      id="start_date"
      name="start_date"
      value=""
      label="Lease Start Date:"
      placeholder=""
      maxlength=""
      required
    />

    <.input
      type="date"
      id="end_date"
      name="end_date"
      value=""
      label="Lease End Date:"
      placeholder=""
      maxlength=""
      required
    />

    <.input
      type="number"
      id="security_deposit"
      name="security_deposit"
      value=""
      label="Security Deposit:"
      placeholder=""
      maxlength=""
      required
    />

    <.input
      type="textarea"
      id="additional_terms"
      name="additional_terms"
      value=""
      label="Additional Terms:"
      placeholder=""
      rows="4"
    />

    <.button type="submit">Submit</.button>

    </form>
  """
  end


  def handle_success(socket, property_address, property) do
    socket
    |> put_flash(:info, "#{property.name} agreement was created successfully.")
    |> push_navigate(to: ~p"/properties/#{property.id}/view_agreement")
  end
end