defmodule ListerImplementationTest do
  use ExUnit.Case
  doctest ListerImplementation

  test "greets the world" do
    assert ListerImplementation.hello() == :world
  end
end
