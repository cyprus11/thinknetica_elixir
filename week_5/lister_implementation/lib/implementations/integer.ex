defimpl Protocols.Lister, for: Integer do
  @doc """
  return the given input as a list of integers

  ## Examples

    iex> Protocols.Lister.to_list(123)
    [1, 2, 3]
  """

  @spec to_list(Integer) :: [Integer]
  def to_list(input), do: input |> Integer.digits()
end
