defmodule Tenantee.Other.CldrTest do
  use ExUnit.Case
  alias Tenantee.Cldr

  test "returns an invalid message" do
    assert Cldr.format_date(nil) == "Invalid date"
  end

  test "handles plurals" do
    assert Cldr.pluralize("singular", "plural", 1) == "singular"
    assert Cldr.pluralize("singular", "plural", 2) == "plural"
  end
end
