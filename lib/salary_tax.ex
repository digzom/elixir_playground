defmodule SalaryTax do
  def apply_tax(salary) do

    tax = cond do
      salary <= 2000 ->
        salary * 1.0
      salary <= 3000 ->
        salary * 0.05
      salary <= 6000 ->
        salary * 0.1
      salary > 6000 ->
        salary * 0.15
    end
    new_salary = salary + tax
    IO.puts("Salary: #{salary}; Tax: #{tax}; Total: #{:erlang.float_to_binary(new_salary, [:compact, decimals: 2])}")
  end
end
