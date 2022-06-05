defmodule EchoClient do
  use WebSockex
  require Logger

  # it's an open server :)
  @echo_server "http://localhost:10000/.ws"

  # start a process link, initialize connection
  def start_link(opts \\ []) do
    WebSockex.start_link(@echo_server, __MODULE__, %{}, opts)
  end

  # doing something when receive a message from server
  def handle_frame({:text, "please reply" = msg}, state) do
    # reveiving the message and logging the returned message
    Logger.info("Echo server says: #{msg}")
    
    reply = "I'm replying"
    # sending this message to echo server
    Logger.info("Sent to Echo server: #{reply}")
    {:reply, {:text, reply}, state}
  end

  def handle_frame({:text, "shut down"}, state) do
    Logger.info("shutting down")
    {:close, state}
  end

  # here we are handle with the response from the echo server
  def handle_frame({:text, msg}, state) do
    Logger.info("Echo server says: #{msg}")
    {:ok, state}
  end

  def handle_disconnect(%{reason: reason}, state) do
    Logger.info("Disconnect with reason: #{inspect reason}")
    {:ok, state}
  end
end
