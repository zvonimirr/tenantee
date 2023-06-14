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
    csp = [
      "default-src": ["https:", "'self'"],
      "img-src": ["https:", "data:", "'self'"],
      "style-src": ["https:", "'self'", "'unsafe-inline'"],
      "script-src": ["https:", "'self'", "'unsafe-inline'"]
    ]

    csp
    |> Keyword.keys()
    |> Enum.map_join("; ", fn key ->
      Atom.to_string(key) <> " " <> Enum.join(Keyword.get(csp, key), " ")
    end)
  end
end
