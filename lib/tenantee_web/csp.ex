defmodule TenanteeWeb.Csp do
  @moduledoc """
  Content Security Policy (CSP) configuration.
  """

  @doc """
  Generate CSP header.
  """
  @spec generate_csp() :: String.t()
  def generate_csp() do
    # Base CSP configuration, plus additional LiveDashboard configuration if it's enabled
    csp =
      [
        "default-src": ["https:", "'self'"],
        "img-src": ["https:", "data:", "'self'"],
        "style-src": ["https:", "'self'", "'unsafe-inline'"]
      ] ++
        if Application.get_env(:tenantee, :dev_routes) do
          [
            "font-src": ["'unsafe-inline'", "data:"],
            "script-src": ["'unsafe-inline'"]
          ]
        else
          []
        end

    csp
    |> Keyword.keys()
    |> Enum.map_join("; ", fn key ->
      Atom.to_string(key) <> " " <> Enum.join(Keyword.get(csp, key), " ")
    end)
  end
end
