defmodule ListHelper do
  # -------------- sum --------------- #
  def sum_lists(list) do
    do_sum(0, list)
  end

  defp do_sum(current_sum, []), do: current_sum

  defp do_sum(current_sum, [head | tail]) do
    new_current_sum = current_sum + head
    do_sum(new_current_sum, tail)
  end

  def old_factorial(n) when n < 2, do: n

  def old_factorial(n) do
    n * old_factorial(n - 1)
  end

  # -------------- factorial --------------- #
  def factorial(n) do
    do_factorial(n, n)
  end

  def do_factorial(current_fac, 0), do: current_fac

  def do_factorial(current_fac, n) do
    new_current_fac = n * current_fac
    do_factorial(new_current_fac, n - 1)
  end

  # -------------- length --------------- #

  def list_len(list), do: do_list_len(list, 0)

  defp do_list_len([], count), do: count

  defp do_list_len([_head | tail], count) do
    current_count = count + 1

    do_list_len(tail, current_count)
  end

  # -------------- range --------------- #

  def range(from, to), do: do_range(from, to, [])

  defp do_range(from, to, list) when from === to, do: Enum.sort(list)

  defp do_range(from, to, list) do
    new_from = from + 1

    do_range(new_from, to, [new_from | list])
  end

  # -------------- positivate --------------- #

  def positivate(list), do: make_it_positive(list, [])
  defp make_it_positive([], new_list), do: new_list

  defp make_it_positive([head | tail], new_list) do
    new_head = abs(head)

    make_it_positive(tail, [new_head | new_list])
  end
end

list = ListHelper.positivate([-3, 3, -10])

IO.inspect(list)
