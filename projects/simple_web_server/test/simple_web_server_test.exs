defmodule SimpleWebServerTest do
  use ExUnit.Case
  doctest SimpleWebServer

  test "greets the world" do
    assert SimpleWebServer.hello() == :world
  end
end
