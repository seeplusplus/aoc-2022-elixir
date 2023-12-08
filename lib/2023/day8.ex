defmodule Mix.Tasks.Day8 do
  use Mix.Task
  defp instruction_to_index("L"), do: 0
  defp instruction_to_index("R"), do: 1

  def walk(_, _, step, <<_::16>> <> "Z") do
    step
  end

  def walk(instructions, nodes, step, current_location) do
    l =
      instructions
      |> String.graphemes()
      |> Enum.at(rem(step, String.length(instructions)))

    index = instruction_to_index(l)
    new_location = elem(Map.get(nodes, current_location), index)
    walk(instructions, nodes, step + 1, new_location)
  end

  def loop_receive(max_len, acc) do
    cond do
      acc |> Enum.count() == max_len -> acc
      true -> receive do
        n -> loop_receive(max_len,[n | acc])
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
            |> Stream.map(
              &{
                &1 |> Enum.at(0),
                Regex.replace(~r/[\(\)]/, &1 |> Enum.at(1), "")
                |> String.split(", ")
                |> List.to_tuple()
              }
            ),
          into: %{} do
        {key, steps}
      end

    parent = self()
    pids = for entry <- nodes |> Map.keys() |> Enum.filter(&(&1 |> String.ends_with?("A"))) do
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

    loop_receive(pids |> Enum.count(), [])
      |> Enum.reduce(1, &MathUtil.lcm/2)
    end

  def run(_) do
    {_, puzzle_input} = File.read("./input/2023_8.txt")
    solve(puzzle_input, :part2) |> IO.puts()
  end
end
