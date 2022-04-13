defmodule Sum do
  def up_to(1), do: 1
  def up_to(n), do: n * up_to(n - 1)
end
