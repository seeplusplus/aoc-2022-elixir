defmodule BenchUtil do
  def get_puzzle_input(year, day) do
    {_, puzzle_input} = File.read("./input/#{year}_#{day}.txt")
    puzzle_input
  end
end
