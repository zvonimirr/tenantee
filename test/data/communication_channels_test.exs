defmodule Tenantee.Data.CommunicationChannelsTest do
  use Tenantee.DataCase
  alias Tenantee.Entity.CommunicationChannel
  import Tenantee.Test.Factory.CommunicationChannels

  test "creates a communication channel" do
    assert {:ok, _channel} =
             CommunicationChannel.create(%{
               type: "test",
               value: "test"
             })
  end

  test "deletes a communication channel" do
    {:ok, channel} = generate_channel()

    assert :ok = CommunicationChannel.delete(channel.id)
  end

  test "gets a communication channel" do
    {:ok, channel} = generate_channel()

    assert {:ok, found_channel} = CommunicationChannel.get(channel.id)

    assert found_channel.id == channel.id
  end

  test "errors when getting a communication channel that does not exist" do
    assert {:error, "Communication channel not found"} = CommunicationChannel.get(-1)
  end

  test "errors when deleting a communication channel that does not exist" do
    assert {:error, "Communication channel not found"} = CommunicationChannel.delete(-1)
  end
end
