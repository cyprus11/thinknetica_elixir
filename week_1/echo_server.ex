defmodule EchoServer do
  @moduledoc """
  Учебный пример "Эхо сервера"
  который принимает :ping и отвечает {:pong, node()},
  если не :ping, то {:error, node()}
  ## Примеры
  iex> pid = EchoServer.start()
  #PID<0.114.0>

  iex> send(pid, {:ping, self()}
  {:ping, #PID<0.105.0>}

  iex> receive do
         {:pong, val} -> IO.puts "Answer #{val}"
       end
  Answer nonode@nohost
  :ok
  """

  def start do
    spawn(fn -> loop() end)
  end

  defp loop do
    receive do
      {:ping, from} ->
        send(from, {:pong, node()})
        loop()
      {_, from} ->
        send(from, {:error, node()})
        loop()
    end
  end
end
