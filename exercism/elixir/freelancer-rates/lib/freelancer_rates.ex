defmodule FreelancerRates do
  def daily_rate(hourly_rate) do
    hourly_rate * 8.0
  end

  def apply_discount(before_discount, discount) do
    actual_rate = before_discount - before_discount * (discount / 100)
    actual_rate
  end

  def monthly_rate(hourly_rate, discount) do
    d_rate = daily_rate(hourly_rate)
    actual_monthly_rate = d_rate * 22
    ceil_float = Float.ceil(apply_discount(actual_monthly_rate, discount))
    string_float = Float.to_string(ceil_float)
    {value, _} = Integer.parse(string_float)
    value
  end

  def days_in_budget(budget, hourly_rate, discount) do
    day_rate = daily_rate(hourly_rate)
    actual_day_rate = apply_discount(day_rate, discount)
    Float.floor(budget / actual_day_rate, 1)
  end
end
