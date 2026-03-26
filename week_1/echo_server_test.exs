Code.require_file("echo_server.ex", __DIR__)

ExUnit.start()

defmodule EchoServerTest do
  use ExUnit.Case

  test "return :pong answer on :ping" do
    pid = EchoServer.start()

    send(pid, {:ping, self()})

    assert_receive({:pong, _node})
  end

  test "return :error answer on not :ping" do
    pid = EchoServer.start()

    send(pid, {:wrong, self()})

    assert_receive({:error, _node})
  end
end
