defmodule Tenantee.Other.CldrTest do
  use ExUnit.Case
  alias Tenantee.Cldr

  test "returns an invalid message" do
    assert Cldr.format_date(nil) == "Invalid date"
  end
end
