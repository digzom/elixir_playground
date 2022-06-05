defmodule SocketsTest do
  use ExUnit.Case
  doctest Sockets

  test "greets the world" do
    assert Sockets.hello() == :world
  end
end
