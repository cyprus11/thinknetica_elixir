defimpl Protocols.Lister, for: Map do
  @doc """
  return the given input as a list of tuples

  ## Examples

    iex> Protocols.Lister.to_list(%{a: 1, b: 2})
    [{:a, 1}, {:b, 2}]
  """

  @spec to_list(Map) :: [{any(), any()}]
  def to_list(input), do: input |> Map.to_list()
end
