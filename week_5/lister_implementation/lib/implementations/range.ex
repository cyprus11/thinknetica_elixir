defimpl Protocols.Lister, for: Range  do
  @doc """
  return the given input as a list of integers

  ## Examples

    iex> Protocols.Lister.to_list(1..5)
    [1, 2, 3, 4, 5]
  """

  @spec to_list(Range) :: [integer()]
  def to_list(input), do: input |> Enum.to_list()
end
