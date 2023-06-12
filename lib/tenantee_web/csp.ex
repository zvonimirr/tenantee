defmodule TenanteeWeb.Csp do
  @moduledoc """
  Content Security Policy (CSP) configuration.
  """

  @doc """
  Generate CSP header.
  """
  @spec generate_csp() :: String.t()
  def generate_csp() do
    csp = [
      "default-src": ["https:", "'self'"],
      "img-src": ["https:", "data:", "'self'"],
      "style-src": ["https:", "'self'", "'unsafe-inline'"]
    ]

    csp
    |> Keyword.keys()
    |> Enum.map(fn key ->
      Atom.to_string(key) <> " " <> Enum.join(Keyword.get(csp, key), " ")
    end)
    |> Enum.join("; ")
    |> IO.inspect()
  end
end
