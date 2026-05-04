defmodule CustomAiWeb.ChatController do
  use CustomAiWeb, :controller

  # def index(conn, _params) do
  #   render(conn, :index, query: "")
  # end

  def stream(conn, %{"request" => request}) do
    conn =
      conn
      |> put_resp_content_type(@nd_json_content_type)
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
