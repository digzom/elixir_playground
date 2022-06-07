defmodule SimpleWebServer.Routing do
  use Plug.Router

  # this is a kind of code injection directly on the compiler
  plug(:match)
  plug(:dispatch)

  get "/hello" do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, "World")
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
