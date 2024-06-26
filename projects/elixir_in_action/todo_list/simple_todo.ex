defmodule TodoList do
  defstruct auto_id: 1, entries: %{}

  def new, do: %TodoList{}

  def add_entry(todo_list = %TodoList{}, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.auto_id,
        entry
      )

    %TodoList{
      todo_list
      | entries: new_entries,
        auto_id: todo_list.auto_id + 1
    }
  end

  def entries(todo_list, date) do
    values = Map.get(dict, key, [])

    %{"#{key}": values}
  end
end
