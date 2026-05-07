defmodule CustomAi.ChatCompletion do
  @moduledoc "Behaviour to be implemented by chat completion engines"

  @callback call(binary() | map(), keyword()) :: {:ok, String.t()} | {:error, term}
  @callback to_string(term()) :: String.t()

  @optional_callbacks to_string: 1

  @spec call(binary() | map(), keyword(), module()) :: {:ok, String.t()} | {:error, term()}
  def call(request, opts \\ [], engine \\ CustomAi.ChatCompletion.Stub) do
    {engine, opts} = Keyword.pop(opts, :engine, engine)
    engine.call(request, opts)
  end

  @spec to_string(term(), module()) :: String.t()
  def to_string(outcome, engine) do
    if function_exported?(engine, :to_string, 1),
      do: engine.to_string(outcome),
      else: inspect(outcome)
  end
end
