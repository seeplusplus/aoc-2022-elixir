defmodule Day9 do
  def init_state(p) when p == :part1 do
    { {0,0}, {0,0}, MapSet.new() }
  end

  def execute(line, state) do
    if String.trim(line) == "" do
      state
    else
      [command, count] = line |> String.split(" ");
      { count, _ } = Integer.parse(count);

      move_rope = fn (movement, {head, tail, tail_positions}) ->
        head = movement |> get_movement_tuple() |> add_2_tuple(head);
        tail = tail |> keep_min_distance(head, 1)
        tail_positions = MapSet.put(tail_positions, tail)
        {head, tail, tail_positions}
      end

      Enum.reduce(
        1..count,
        state,
        fn (_, state) -> 
          #IO.puts(command)
          #IO.puts(inspect(state))
          new_state = move_rope.(command, state) 
          #IO.puts(inspect(new_state))
          new_state
        end
      );  
    end
  end

  defp keep_min_distance(tail, head, min_distance) do
    difference = distance_vector(tail, head)
    #IO.puts(inspect(difference))

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

  def get_answer(state) do
    {_, _, tail_positions } = state
    MapSet.size(tail_positions)
  end

  defp get_movement_tuple(direction) do
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
    #IO.puts("max_coord_difference: " <> inspect({a,b}))
    max(a, b)
  end
end

