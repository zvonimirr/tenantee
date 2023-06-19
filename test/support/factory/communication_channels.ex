defmodule Tenantee.Test.Factory.CommunicationChannels do
  @moduledoc """
  Communication channels factory for Tenantee tests.
  """
  alias Tenantee.Repo
  alias Tenantee.Schema.CommunicationChannel

  @doc """
  Generates and inserts a communication channel with the given attributes or the default attributes if none were given.
  """
  @spec generate_channel(Keyword.t()) :: {:ok, term()} | {:error, term()}
  def generate_channel(attrs \\ []) do
    type = Keyword.get(attrs, :type, "email")
    value = Keyword.get(attrs, :value, Faker.Internet.email())

    %CommunicationChannel{}
    |> CommunicationChannel.changeset(%{
      type: type,
      value: value
    })
    |> Repo.insert()
  end
end
