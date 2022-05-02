defmodule IncomeTax do
  salary_with_tax = fn(salary) ->
    tax =
      cond do
        salary <= 2000 ->
          salary * 1.0

        salary <= 3000 ->
          salary * 0.05

        salary <= 6000 ->
          salary * 0.1

        salary > 6000 ->
          salary * 0.15
      end

    salary + tax
  end

  salary = IO.gets("Salary: ")

  result =
    case Integer.parse(salary) do
      :error ->
        "Invalid salary: #{salary}"

      {user_salary, _} ->
        salary_with_tax.(user_salary)
    end

  IO.puts(result)
end
