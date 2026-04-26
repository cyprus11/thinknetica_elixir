defmodule ManyToManyWeb.PageController do
  use ManyToManyWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
