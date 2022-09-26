defmodule TodoList do
  def new, do: Map.new()

  def add_entry(todo_list, %{date: date, title: title}) do
    Map.update(key, [value], fn values ->
      new_values = [value | values]
      List.flatten(new_values)
    end)
  end

  def entries(todo_list, date) do
    values = Map.get(dict, key, [])

    %{"#{key}": values}
  end
end
