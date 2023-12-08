defmodule Mix.Tasks.Day8 do
  use Mix.Task
  defp instruction_to_index("L"), do: 0
  defp instruction_to_index("R"), do: 1

  def walk(_, _, step, <<_::binary-size(2)>> <> "Z") do
    step
  end

  def walk(instructions, nodes, step, current_location) do
    index =
      instructions
      |> String.at(rem(step, String.length(instructions)))
      |> instruction_to_index()

    new_location = elem(Map.get(nodes, current_location), index)
    walk(instructions, nodes, step + 1, new_location)
  end

  def loop_receive(max_len, acc, count) do
    cond do
      count == max_len -> acc
      true -> receive do
        n -> loop_receive(max_len, MathUtil.lcm(acc, n), count + 1)
      end
    end
  end

  def solve(input, _) do
    [instructions, nodes] = input |> String.split("\n\n")

    nodes =
      for {key, steps} <-
            nodes
            |> String.split("\n")
            |> Stream.reject(&(&1 == ""))
            |> Stream.map(&String.split(String.trim(&1), " = "))
            |> Stream.map(fn [from, "(" <> <<a::binary-size(3)>> <> ", " <> <<b::binary-size(3)>> <> ")"] -> {from, {a,b}} end),
          into: %{} do
        {key, steps}
      end

    parent = self()
    pids = for entry <- nodes |> Map.keys() |> Stream.filter(&(&1 |> String.ends_with?("A"))) do
      spawn(fn -> 
        send(parent,
          walk(
            instructions,
            nodes,
            0,
            entry
          )
        )
        end
      )
    end 

    loop_receive(pids |> Enum.count(), 1, 0)
  end

  def run(_) do
    {_, puzzle_input} = File.read("./input/2023_8.txt")
    solve(puzzle_input, :part2) |> IO.puts()
  end
end
