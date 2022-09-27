defmodule BetterTodoListTest do
  use ExUnit.Case
  doctest BetterTodoList

  test "greets the world" do
    assert BetterTodoList.hello() == :world
  end
end
