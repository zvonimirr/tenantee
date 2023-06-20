defmodule Tenantee.Other.CspTest do
  alias TenanteeWeb.Csp
  use ExUnit.Case

  test "generates a valid CSP" do
    assert Csp.generate_csp() ==
             "default-src https: 'self'; img-src https: data: 'self'; style-src https: 'self' 'unsafe-inline'; script-src https: 'self' 'unsafe-inline'"
  end
end
