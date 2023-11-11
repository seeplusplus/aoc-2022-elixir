import Integer, only: [mod: 2]

defmodule Day10 do
  @behaviour Solution

  def init_state(_) do
    %{ vm: VirtualMachine.new(), acc: 0 }
  end

  def execute(line, state) when line == "" do
    state
  end

  def execute(line, state) do
    VirtualMachine.plan_execute(line) |>
    Enum.reduce(
      state,
      fn (tock, %{vm: vm, acc: acc}) ->
        next_tick = vm.tick + 1
        acc = if (next_tick - 20 |> mod(40)) === 0, do: acc + (next_tick) * vm.x, else: acc
        vm = tock.(vm)
        %{ vm: vm, acc: acc}
      end
    )
  end

  def get_answer(state) do
    state.acc
  end
end

defmodule VirtualMachine do
  def new() do
    %{ x: 1, tick: 0 }
  end

  def plan_execute(instruction) do
    [instruction, args] = if instruction == "noop" do 
      [instruction, nil]
    else 
      String.split(instruction, " ") 
    end

    plan_execute(instruction, args)
  end

  def plan_execute(instruction, args) when instruction == "addx" do
    args = case Integer.parse(args) do
      {args, _} -> args
      :error -> 0
    end
    if is_integer(args) do
      plan_execute("noop", nil) ++ 
      [
        fn (vm) -> 
          vm |> 
            Map.update(:tick, 2, &(&1 + 1)) |>
            Map.update(:x, args, &(&1 + args))
        end
      ]
    else []
    end
  end

  def plan_execute(instruction, _) when instruction == "noop" do
    [fn (vm) -> Map.update(vm, :tick, 1, &(&1 + 1)) end]
  end
end

