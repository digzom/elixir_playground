defmodule TakeANumber do
  def start() do
    # Please implement the start/0 function

    receive do
      {:report_state, sender_pid} ->
        nil
        # code
    end

    spawn(fn -> 0 end)
  end
end
