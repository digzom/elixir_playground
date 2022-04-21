defmodule MyList do
  def get_max([]), do: []
  def get_max([a]), do: [a]

  def get_max(list) do
    half_size = div(Enum.count(list), 2)
    {list_a, list_b} = Enum.split(list, half_size)

    merge(
      get_max(list_a),
      get_max(list_b)
    )
  end

  defp merge([], list_b), do: list_b
  defp merge(list_a, []), do: list_a

  defp merge([head_a | tail_a], list_b = [head_b | _]) when head_a > head_b do
    [head_a | merge(tail_a, list_b)]
  end

  defp merge(list_a = [head_a | _], [head_b | tail_b]) when head_a <= head_b do
    [head_b | merge(list_a, tail_b)]
  end

  def max(list) do
    [head | _] = get_max(list)
    head
  end

  def min(list) do
    [head | _] = Enum.take(get_max(list), -1)

    head
  end
end
