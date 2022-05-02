defmodule MatchstickFactory do
  def boxes(matchsticks) do
    big = div(matchsticks, 50)
    big_rest = rem(matchsticks, 50)

    medium = div(big_rest, 20)
    medium_rest = rem(big_rest, 20)

    small = div(medium_rest, 5)
    small_rest = rem(medium_rest, 5)

    rest = small_rest

    %{big: big, medium: medium, small: small, remaining_matchsticks: rest}
  end
end
