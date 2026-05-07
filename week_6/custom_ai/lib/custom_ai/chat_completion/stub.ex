defmodule CustomAi.ChatCompletion.Stub do
  @moduledoc "Stub module if has not available model"
  @behaviour CustomAi.ChatCompletion

  @impl CustomAi.ChatCompletion
  @spec call(map(), keyword()) :: {:ok, String.t()} | {:error, term()}
  def call(%{messages: messages}, opts) do
    result =
      messages
      |> Enum.map_join("\n", fn %{role: role, content: content} when role in ~w|user assistant|a ->
        content
      end)
      |> call(opts)

    {:ok, result}
  end

  @impl CustomAi.ChatCompletion
  @spec call(binary(), keyword()) :: {:ok, String.t()} | {:error, term()}
  def call(request, opts) when is_binary(request) do
    response = "Hi, as a stub code, I can only mirror your request: ‹#{inspect(request)}›"
    {callback, _opts} = Keyword.pop(opts, :callback)

    result =
      case callback do
        f when is_function(f, 1) -> f.(response)
        _ -> response
      end

    {:ok, result}
  end

  @impl CustomAi.ChatCompletion
  @spec to_string(term()) :: String.t()
  def to_string(outcome) do
    inspect(outcome)
  end
end
