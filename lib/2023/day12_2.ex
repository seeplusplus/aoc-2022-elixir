defmodule SprintParseWorker do
  def loop_receive(n, acc) do
    case n do
      0 ->
        acc

      _ ->
        receive do
          m ->
            loop_receive(n - 1, acc + m)
        end
    end
  end

  def solve_in_parallel(i) do
    parent = self()

    u = SpringParse.parse(i)

    pid_count =
      for [pattern, expectation] <- u do
        spawn_link(fn ->
          send(parent, SpringParse.count_solutions(pattern, expectation))
        end)
      end
      |> Enum.count()

    loop_receive(pid_count, 0)
  end
end
