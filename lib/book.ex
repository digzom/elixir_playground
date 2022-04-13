defmodule Book do
  apply_tax = fn price -> price * 0.12 end

  Enum.each([12.5, 30.99, 250.49, 18.80], apply_tax)
end
