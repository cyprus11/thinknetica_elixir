defmodule CustomAiWeb.ChatsLive.Index do
  use CustomAiWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:messages, [])
      |> assign(:running, false)

    {:ok, socket}
  end

  @impl true
  def handle_event("submit", %{"content" => content}, socket) do
    message = %{role: :user, content: content}
    updated_messages = [message | socket.assigns.messages]

    # The process id of the current LiveView
    pid = self()

    socket =
      socket
      |> assign(:running, true)
      |> assign(:text, message[:content])
      |> start_async(:chat_completion, fn ->
        run_chat_completion(pid, Enum.reverse(updated_messages))
      end)

    {:noreply, socket}
  end

  @impl true
  def handle_info({:chunk, chunk}, socket) do
    updated_messages =
      case socket.assigns.messages do
        [%{role: :assistant, content: content} | messages] ->
          [%{role: :assistant, content: content <> chunk} | messages]

        messages ->
          [%{role: :assistant, content: chunk} | messages]
      end

    {:noreply, assign(socket, :messages, updated_messages)}
  end

  @impl true
  def handle_async(:chat_completion, _result, socket) do
    {:noreply, assign(socket, :running, false)}
  end

  defp run_chat_completion(pid, messages) do
    prompt = Enum.map_join(messages, "\n", & &1.content)

    CustomAi.ChatCompletion.FlanT5.call(prompt,
      callback: fn chunk ->
        case chunk do
          content when is_binary(content) ->
            send(pid, {:chunk, content})
          _ ->
            nil
        end
      end
    )
  end
end
