defmodule EchoServer do
  def start do
    spawn(fn -> loop() end)
  end

  defp loop do
    receive do
      {:ping, from} ->
        send(from, {:pong, node()})
        loop()
    end
  end
end
