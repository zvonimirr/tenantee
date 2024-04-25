defmodule Tenantee.Other.ConfigTest do
  use Tenantee.DataCase
  import Mock
  alias Tenantee.Valkey
  alias Tenantee.Config

  test "get" do
    Config.delete(:test)

    assert Config.get(:test, "default") == "default"
    assert Config.get("test", "default") == "default"

    assert Config.get(:test) == {:error, "key not found"}
    assert Config.get("test") == {:error, "key not found"}

    assert Config.get("") == {:error, "key not found"}
    assert Config.get("", "default") == "default"
  end

  test "get (with failure)" do
    with_mock Valkey, command: fn _cmd -> {:error, "error"} end do
      assert Config.get(:test, "default") == "default"
    end
  end

  test "set" do
    assert Config.set(:test, "value") == :ok

    assert Config.get("test") == {:ok, "value"}
  end

  test "set (with failure)" do
    with_mock Valkey, command: fn _cmd -> {:error, "error"} end do
      assert Config.set(:test, "value") == :error
    end
  end

  test "delete" do
    Config.set(:test, "value")
    assert Config.delete(:test) == :ok

    assert Config.get("test") == {:error, "key not found"}
  end

  test "delete (with failure)" do
    with_mock Valkey, command: fn _cmd -> {:error, "error"} end do
      assert Config.delete(:test) == :error
    end
  end
end
