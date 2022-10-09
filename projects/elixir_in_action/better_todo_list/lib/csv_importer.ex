defmodule BetterTodoList.CsvImporter do
  def import(path) do
    File.stream!(path)
    |> Stream.map(fn string -> String.replace(string, "\n", "") end)
    |> Stream.map(fn el -> String.split(el, ",") end)
    |> Enum.map(fn [date, task] -> %{date: date, title: task} end)
    |> IO.inspect()
  end
end
