defmodule Tenantee.Config do
  @moduledoc """
  A helper module for managing the configuration of the application.
  """
  alias Tenantee.Redis

  @doc """
  Returns the configuration for the application.
  """
  @spec get(String.t() | atom(), any) :: any
  def get(key, default) when is_atom(key) do
    get(Atom.to_string(key), default)
  end

  def get(key, default) when is_bitstring(key) do
    case Redis.command(["GET", key]) do
      {:ok, value} -> if is_nil(value), do: default, else: value
      {:error, _} -> default
    end
  end

  @spec get(String.t() | atom()) :: {:ok, any} | {:error, String.t()}
  def get(key) when is_atom(key) do
    case get(Atom.to_string(key), nil) do
      nil -> {:error, "key not found"}
      value -> {:ok, value}
    end
  end

  def get(key) when is_bitstring(key) do
    case get(key, nil) do
      nil -> {:error, "key not found"}
      value -> {:ok, value}
    end
  end

  @doc """
  Sets the configuration for the application.
  """
  @spec set(String.t() | atom(), any) :: :ok | :error
  def set(key, value) when is_atom(key) do
    set(Atom.to_string(key), value)
  end

  def set(key, value) when is_bitstring(key) do
    case Redis.command(["SET", key, value]) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end

  @doc """
  Deletes the configuration for the application.
  """
  @spec delete(String.t() | atom()) :: :ok | :error
  def delete(key) when is_atom(key) do
    delete(Atom.to_string(key))
  end

  def delete(key) when is_bitstring(key) do
    case Redis.command(["DEL", key]) do
      {:ok, _} -> :ok
      {:error, _} -> :error
    end
  end

  @doc """
  Check if any of the required config values are missing.
  """
  @spec lacks_config?() :: boolean()
  def lacks_config?() do
    [
      get(:name),
      get(:currency),
      get(:tax)
    ]
    |> Enum.map(&elem(&1, 0))
    |> Enum.any?(&(&1 == :error))
  end
end
