defmodule RpgExercise do
  def set_attributes() do
    str = Integer.parse(IO.gets("Strength: "))
    dxt = Integer.parse(IO.gets("Dextery: "))
    int = Integer.parse(IO.gets("Intelligence: "))

    sum_attributes(%{strength: str, dextery: dxt, intelligence: int})
  end

  def sum_attributes(%{dextery: {dxt, _}, intelligence: {int, _}, strength: {str, _}}) do
    IO.puts("Strength: #{(str * 2)}, Intelligence: #{(int * 3)}, Dextery: #{(dxt * 3)}")
    IO.puts("You spent #{dxt + int + str} points with your character.")
  end
end
