defmodule CustomAi.ChatCompletion.Stub do
  @behaviour CustomAi.ChatCompletion

  @impl CustomAi.ChatCompletion
  def call(%{messages: messages}, opts) do
    messages
    |> Enum.map_join("\n", fn %{role: role, content: content} when role in ~w|user assistant|a ->
      content
    end)
    |> call(opts)
  end

  def call(request, opts) when is_binary(request) do
    response = "Hi, as a stub code, I can only mirror your request: ‹#{inspect(request)}›"
    {callback, _opts} = Keyword.pop(opts, :callback)

    case callback do
      f when is_function(f, 1) -> f.(response)
      _ -> response
    end
  end
end
