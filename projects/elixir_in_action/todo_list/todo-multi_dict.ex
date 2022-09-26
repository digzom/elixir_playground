defmodule MultiDict do
  def new(), do: %{}

  def add(dict, key, value) do
    dict
  end

  def get(dict, key) do
    values = Map.get(dict, key, [])

    %{"#{key}": values}
  end
end
