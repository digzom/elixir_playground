defmodule SimpleWebServer.Application do
  @moduledoc false

  use Application

  # now we are under supervision tree
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: SimpleWebServer.WebServer, options: [port: 4000]},
      {Plug.Cowboy, scheme: :http, plug: SimpleWebServer.Routing, options: [port: 4001]}
    ]

    opts = [strategy: :one_for_one, name: SimpleWebServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
