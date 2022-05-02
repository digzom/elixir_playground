defmodule MyListModule do
  def each([], _function), do: nil

  def each([head | tail], function) do
    function.(head)
    each(tail, function)
  end

  def map([], _function), do: []

  def map([head | tail], function) do
    [function.(head) | map(tail, function)]
  end

  def reduce([], acc, _function), do: acc

  def reduce([head | tail], acc, function) do
    reduce(tail, function.(head, acc), function)
  end
end
