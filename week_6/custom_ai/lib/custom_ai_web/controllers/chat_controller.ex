defmodule CustomAiWeb.ChatController do
  use CustomAiWeb, :controller

  @spec stream(Plug.Conn.t(), map()) :: Plug.Conn.t()
  def stream(conn, %{"request" => request}) do
    conn =
      conn
      |> put_resp_content_type("application/json")
      |> send_chunked(200)

    CustomAi.ChatCompletion.call(request,
      callback: fn data ->
        result = Jason.encode!(data)
        chunk(conn, result)
        chunk(conn, "\n")
      end
    )

    conn
  end
end
