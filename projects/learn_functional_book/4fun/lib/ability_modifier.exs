defmodule AbilityModifier do
  user_input = IO.gets("Write your ability score: \n")

  result =
    case Integer.parse(user_input) do
      :error ->
        "Invalid ability score: #{user_input}"

      {ability_score, _} when ability_score < 0 ->
        "Invalid value"

      # I know that Integer.parse will return a tuple, so my pattern does not change
      {ability_score, _} ->
        ability_modifier = (ability_score - 10) / 2
        "Your ability modifier is #{ability_modifier}"
    end

  def cois() do
    IO.puts("Olá")
  end

  IO.puts(result)
end
