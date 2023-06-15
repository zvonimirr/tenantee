defmodule Tenantee.Other.ConfigTest do
  use Tenantee.DataCase
  alias Tenantee.Config

  test "get" do
    assert Config.get(:test, "default") == "default"
    assert Config.get("test", "default") == "default"

    assert Config.get(:test) == {:error, "key not found"}
    assert Config.get("test") == {:error, "key not found"}

    assert Config.get("") == {:error, "key not found"}
    assert Config.get("", "default") == "default"
  end

  assert "set" do
    assert Config.set(:test, "value") == :ok

    assert Config.get("test") == {:ok, "value"}
  end

  assert "delete" do
    Config.set(:test, "value")
    assert Config.delete(:test) == :ok

    assert Config.get("test") == {:error, "key not found"}
  end
end
