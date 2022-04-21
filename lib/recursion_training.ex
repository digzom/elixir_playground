defmodule RecursionTraining do
  def factorial_of(0), do: 1
  def factorial_of(1), do: 1
  def factorial_of(n) when n > 0, do: n * factorial_of(n - 1)

  def sum_all_numbers(0), do: 0
  def sum_all_numbers(n) when n > 0, do: n + sum_all_numbers(n - 1)

  def print_all_numbers(0), do: IO.puts(0)

  def print_all_numbers(n) do
    IO.puts(n)
    print_all_numbers(n - 1)
  end

  def print_one_to_nesim(n), do: print_one_to_n(n, n)
  def print_one_to_n(n, 0), do: n

  def print_one_to_n(n, acc) when n > 2 do
    IO.puts(n - acc)
    print_one_to_n(n, acc - 1)
  end

  def count(n), do: n

  def print_n_terms_of_fibbonacci(terms) do
    IO.puts(1)
    do_fibbonacci(1, 0, count(0), terms)
  end

  def do_fibbonacci(n, prev, count, terms) when count == terms - 2, do: n + prev

  def do_fibbonacci(n, prev, count, terms) when count <= terms - 3 do
    actual_n = n + prev
    IO.puts(actual_n)
    do_fibbonacci(actual_n, n, count + 1, terms)
  end

  def sum_list([]), do: 0

  def sum_list([head | tail]) do
    head + sum_list(tail)
  end
end
