defmodule BetterTodoList do
  defstruct auto_id: 1, entries: %{}

  def new(entries \\ []) do
    # this todo_list_acc is the updated state of BetterTodoList (the initial state)
    # and here are transforming the entry in an instance of BetterTodoList struct
    # the lambda function receives the entry fist and the struct as second argument
    # that's why we call add_entry with this order of argument
    Enum.reduce(entries, %BetterTodoList{}, &add_entry(&2, &1))
  end

  def add_entry(todo_list, entry) do
    entry = Map.put(entry, :id, todo_list.auto_id)

    new_entries =
      Map.put(
        todo_list.entries,
        todo_list.auto_id,
        entry
      )

    %BetterTodoList{
      todo_list
      | entries: new_entries,
        auto_id: todo_list.auto_id + 1
    }
  end

  @spec entries(map(), Calendar.date()) :: map()
  def entries(todo_list = %BetterTodoList{}, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    # searching the entry with the given id
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list

      # example of a deep update
      {:ok, old_entry} ->
        # calling the updater callback function to modify the entry
        old_entry_id = old_entry.id
        # using pattern matching to make sure that the entry is a map
        # and the id hasn't been changed
        new_entry = %{id: ^old_entry_id} = updater_fun.(old_entry)
        # storing the new entry in the list of entries
        new_entries = Map.put(todo_list.entries, new_entry.id, new_entry)
        # saving the list in the instance of BetterTodoList
        %BetterTodoList{todo_list | entries: new_entries}
    end
  end

  # this creates a new interface for the caller. Here, the caller
  # can give an entry with an id to update
  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn _ -> new_entry end)
  end

  def delete_entry(todo_list, entry_id) do
    case Map.fetch(todo_list, entry_id) do
      :error ->
        "This ID doesn't exist"

      {:ok, _} ->
        Map.delete(todo_list, entry_id)
    end
  end
end
