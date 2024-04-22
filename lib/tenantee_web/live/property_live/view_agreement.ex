defmodule TenanteeWeb.PropertyLive.ViewAgreement do
  alias TenanteeWeb.PropertyLive.Helper
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def render(assigns) do
    assigns = assign(assigns, :landlord_name, Config.get(:name, "Landlord"))
    assigns = assign(assigns, :currency, Config.get(:currency, "USD"))

    ~H"""
    <div>
      <.link class="text-gray-500" navigate={~p"/properties"}>
        <.icon name="hero-arrow-left" /> Back to property card
      </.link>

      <div id="pdf-content">
        <h1 style="font-weight: bold;">Lease Agreement</h1>

        <p>
          -------------------------------------------------------------------------------------------
        </p>

        <p style="font-weight: bold;">
          This Lease Agreement is entered into on <%= @agreement_params["start_date"] %>,
          by and between:
        </p>

        <p style="font-weight: bold;">Landlord: <%= @landlord_name %></p>
        <p style="font-weight: bold;">Tenant: <%= @agreement_params["tenant_name"] %></p>
        <p>
          -------------------------------------------------------------------------------------------
        </p>

        <h2 style="font-weight: bold;">Property Details:</h2>
        <p>Property Address: <%= @address %></p>

        <h2 style="font-weight: bold;">Terms of the Lease:</h2>
        <p>
          This lease is for a term of <%= @agreement_params["lease_term"] %> months,
          commencing on <%= @agreement_params["start_date"] %> and ending on <%= @agreement_params[
            "end_date"
          ] %> unless terminated earlier in accordance
          with the terms of this agreement.
        </p>

        <h2 style="font-weight: bold;">Rental Details:</h2>
        <p>Monthly Rent Amount (<%= @currency %>): <%= @agreement_params["rent_amount"] %></p>
        <p>Security Deposit (<%= @currency %>): <%= @agreement_params["security_deposit"] %></p>

        <%= if @agreement_params["additional_terms"] != "" do %>
          <h2 style="font-weight: bold;">Additional Terms:</h2>
          <p><%= @agreement_params["additional_terms"] %> -</p>
        <% end %>

        <p>
          -------------------------------------------------------------------------------------------
        </p>
        <p class="mt-4">
          Signed by the Landlord: __________________________
        </p>
        <p class="mt-4">
          Signed by the Tenant: __________________________
        </p>
      </div>

      <div class="my-4">
        <.button phx-click={JS.dispatch("tenantee:print-pdf")}>
          <.icon name="hero-clipboard" class="w-4 h-4" /> Download PDF
        </.button>
      </div>

      <div class="my-4">
        <.link class="text-gray-500" navigate={~p"/properties/#{assigns.id}/edit_agreement"}>
          <.icon name="hero-arrow-left" /> Edit Agreement
        </.link>
      </div>
    </div>
    """
  end
end
