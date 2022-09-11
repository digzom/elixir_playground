defmodule MultiDict do
  def new(), do: %{}

  def add(dict, key, value) do
    dict
    |> Map.update(key, [value], fn values ->
      new_values = [value | values]
      List.flatten(new_values)
    end)
  end

  def get(dict, key) do
    values = Map.get(dict, key, [])

    %{"#{key}": values}
  end
end
