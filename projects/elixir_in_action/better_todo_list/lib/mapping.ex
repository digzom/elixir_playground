defmodule MyEnumerable do
  def map(enumerable, fun) do
    reducer = fn x, acc -> {:cont, [fun.(x) | acc]} end
    Enumerable.reduce(enumerable, {:cont, []}, reducer) |> elem(1) |> :lists.reverse()
  end
end
