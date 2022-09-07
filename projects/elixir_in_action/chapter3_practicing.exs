defmodule FileReader do
  def large_lines!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.filter(&(String.length(&1) <= 80))
  end

  def line_lengths!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(&String.length(&1))
  end

  def longest_line_length!(path) do
    longest_line = File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.max()

    {longest_line, String.length(longest_line)}
  end

  def words_per_line!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Enum.map(fn line -> length(String.split(line)) end)
  end

  def line_with_most_words!(path) do
    File.stream!(path)
    |> Stream.map(&String.replace(&1, "\n", ""))
    |> Stream.map(fn line -> {length(String.split(line)), line} end)
    |> Enum.max()
  end
end

IO.inspect(FileReader.line_with_most_words!("./chapter1.md"))
