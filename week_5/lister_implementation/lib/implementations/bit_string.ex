defimpl Protocols.Lister, for: BitString do
  @doc """
  return the given input as a list of strings

  ## Examples

    iex> Protocols.Lister.to_list("1 2 3")
    ["1", "2", "3"]
  """

  @spec to_list(binary()) :: [binary()]
  def to_list(input), do: input |> String.split()
end
