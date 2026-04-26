defimpl Protocols.Lister, for: Tuple do
  @doc """
  return the given input as a list of elements

  ## Examples

    iex> Protocols.Lister.to_list({1, 2, 3})
    [1, 2, 3]
  """

  @spec to_list(Tuple) :: [any()]
  def to_list(input), do: input |> Tuple.to_list()
end
