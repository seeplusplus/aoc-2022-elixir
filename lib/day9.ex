defmodule Day9 do
  def init_state(p) when p == :part1 do
    { [ {0,0}, {0,0} ], MapSet.new() }
  end

  def init_state(p) when p == :part2 do
    { [ {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}, {0,0}], MapSet.new() }
  end

  def execute(line, state) when line == "" do
    state
  end

  def execute(line, state) do
    [command, count] = line |> String.split(" ");
    { count, _ } = Integer.parse(count);

    Enum.reduce(
      1..count,
      state,
      fn (_, state) -> 
        { rope, tail_positions } = state
        rope = command 
          |> get_movement_direction()
          |> move_head(rope)
        { rope, MapSet.put(tail_positions, List.last(rope)) }
      end
    );  
  end

  def get_answer(state) do
    {_, tail_positions } = state
    MapSet.size(tail_positions)
  end

  defp move_head(direction, rope) do
    [head | tail ] = rope
    move_rope([add_2_tuple(head, direction)], tail)
  end

  defp move_rope(good, bad) when bad == [] do
    good
  end

  defp move_rope(good, bad) do
    leader = good |> List.last()
    [ follower | tail ] = bad

    move_rope(good ++ [keep_min_distance(follower, leader, 1)], tail)
  end

  defp keep_min_distance(tail, head, min_distance) do
    difference = distance_vector(tail, head)

    if max_coord_difference(tail, head) <= min_distance do 
      tail 
    else
      {a, b} = difference
      megan = fn (x) -> if x != 0 do
          if x > 0 do 1 else -1 end
        else
          0
        end
      end
      add_2_tuple(tail, {megan.(a), megan.(b)})
    end
  end

  defp get_movement_direction(direction) do
    case direction do
      "R" -> {1, 0}
      "L" -> {-1, 0}
      "U" -> {0, 1}
      "D" -> {0, -1}
    end
  end

  defp add_2_tuple(x, y) do
    { elem(x,0) + elem(y,0), elem(x,1) + elem(y,1) }
  end

  defp distance_vector(x, y) do 
    { elem(y,0) - elem(x,0), elem(y,1) - elem(x,1) }
  end

  defp max_coord_difference(x, y) do 
    {a, b} = { abs(elem(x,0)-elem(y,0)), abs(elem(x,1)-elem(y,1)) }
    max(a, b)
  end
end

