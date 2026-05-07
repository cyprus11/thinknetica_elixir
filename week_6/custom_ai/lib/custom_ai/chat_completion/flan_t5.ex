defmodule CustomAi.ChatCompletion.FlanT5 do
  @moduledoc "Grab the model from https://huggingface.co/google/flan-t5-base/tree/main"

  use GenServer

  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    {name, opts} = opts |> Keyword.put_new(:name, __MODULE__) |> Keyword.pop!(:name)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  @impl GenServer
  @spec init(keyword()) :: {:ok, map()}
  def init(opts) do
    model_base = {:hf, "google/flan-t5-base"}

    {:ok, model} = Bumblebee.load_model(model_base)
    {:ok, tokenizer} = Bumblebee.load_tokenizer(model_base)
    {:ok, generation_config} = Bumblebee.load_generation_config(model_base)

    opts = Keyword.put_new(opts, :max_new_tokens, 15)
    generation_config = Bumblebee.configure(generation_config, opts)

    serving =
      Bumblebee.Text.generation(model, tokenizer, generation_config, stream: true)

    {:ok, %{serving: serving}}
  end

  @impl GenServer
  @spec handle_call({:serve, binary() | map(), (binary() -> term())}, GenServer.from(), map()) ::
          {:reply, :ok, map()}
  def handle_call({:serve, prompt, callback}, _from, %{serving: serving} = state) do
    Task.start(fn ->
      serving
      |> Nx.Serving.run(prompt)
      |> Enum.each(fn chunk ->
        if is_binary(chunk), do: callback.(chunk)
      end)
    end)

    {:reply, :ok, state}
  end

  @behaviour CustomAi.ChatCompletion

  @impl CustomAi.ChatCompletion
  @spec call(binary() | map(), keyword()) :: {:ok, String.t()} | {:error, term()}
  def call(request, opts) do
    {callback, opts} = Keyword.pop(opts, :callback, fn _ -> :ok end)
    {name, _opts} = Keyword.pop(opts, :name, __MODULE__)
    GenServer.call(name, {:serve, request, callback}, :infinity)
    {:ok, ""}
  end

  @impl CustomAi.ChatCompletion
  @spec to_string(term()) :: String.t()
  def to_string(outcome) do
    inspect(outcome)
  end
end
