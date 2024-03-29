defmodule TenanteeWeb.PropertyLive.ViewAgreement do
  alias TenanteeWeb.PropertyLive.Helper
  alias Tenantee.Config
  alias Tenantee.Entity.{Rent, Property, Tenant}
  alias Tenantee.Cldr
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def render(assigns) do
    landlord_name = Config.get(:name, nil) # Replace this with your logic to fetch the landlord's name

    ~H"""
    <div>

      <.link class="text-gray-500" navigate={~p"/properties"}>
        <.icon name="hero-arrow-left" /> Back to property card
      </.link>

      <div id="pdf-content">

        <h1 style="font-weight: bold;">Lease Agreement</h1>

        <p>-------------------------------------------------------------------------------------------</p>

        <p style="font-weight: bold;">
          This Lease Agreement is entered into on <%= @agreement_params["start_date"] %>,
          by and between:
        </p>

        <p style="font-weight: bold;">Landlord: <%= landlord_name %></p>
        <p style="font-weight: bold;">Tenant: <%= @agreement_params["tenant_name"] %></p>
        <p>-------------------------------------------------------------------------------------------</p>

        <h2 style="font-weight: bold;">Property Details:</h2>
        <p>Property Address: <%= @address %></p>

        <h2 style="font-weight: bold;">Terms of the Lease:</h2>
        <p>
          This lease is for a term of <%= @agreement_params["lease_term"] %> months,
          commencing on <%= @agreement_params["start_date"] %> and ending on
          <%= @agreement_params["end_date"] %> unless terminated earlier in accordance
          with the terms of this agreement.
        </p>

        <h2 style="font-weight: bold;">Rental Details:</h2>
        <p>Monthly Rent Amount: <%= @agreement_params["rent_amount"] %></p>
        <p>Security Deposit: <%= @agreement_params["security_deposit"] %></p>

        <%= if @agreement_params["additional_terms"] != "" do %>
          <h2 style="font-weight: bold;">Additional Terms:</h2>
          <p><%= @agreement_params["additional_terms"] %> - </p>
        <% end %>

      </div>

      <br>

      <.button onclick="downloadPDF()">
        <.icon name="hero-clipboard" class="w-4 h-4" /> Download PDF
      </.button>

      <br>

      <.link class="text-gray-500" navigate={~p"/properties/#{assigns.id}/edit_agreement"}>
        <.icon name="hero-arrow-left" /> Edit Agreement
      </.link>

    </div>

    <script >
      // JavaScript function to generate and download PDF
      function downloadPDF() {
        // Open a new window for printing
        var printWindow = window.open('', '_blank');

        // Inject the HTML content into the new window
        printWindow.document.write(document.getElementById('pdf-content').outerHTML);

        // Execute the print function in the new window
        printWindow.document.close();
        printWindow.print();
      }
    </script>

    """
  end
end
