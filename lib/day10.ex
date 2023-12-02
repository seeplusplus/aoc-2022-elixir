import Integer, only: [mod: 2]

defmodule Day10 do
  @behaviour Solution

  def init_state(p) when p == :part1 do
    %{vm: VirtualMachine.new(), acc: 0, p: p}
  end

  def init_state(p) when p == :part2 do
    %{vm: VirtualMachine.new(), crt: "", p: p}
  end

  def execute(line, state) when line == "" do
    state
  end

  def execute(line, state) when state.p == :part1 do
    VirtualMachine.plan_execute(line)
    |> Enum.reduce(
      state,
      fn tock, %{vm: vm, acc: acc} ->
        next_tick = vm.tick + 1
        acc = if (next_tick - 20) |> mod(40) === 0, do: acc + next_tick * vm.x, else: acc
        vm = tock.(vm)
        %{vm: vm, acc: acc}
      end
    )
    |> Map.put(:p, state.p)
  end

  def execute(line, state) when state.p == :part2 do
    VirtualMachine.plan_execute(line)
    |> Enum.reduce(
      state,
      fn tock, %{vm: vm, crt: crt} ->
        next_tick = vm.tick + 1

        char =
          case mod(vm.tick, 40) do
            x when x >= vm.x - 1 and x <= vm.x + 1 -> "#"
            _ -> "."
          end

        crt = crt <> char

        crt =
          crt <>
            if mod(next_tick, 40) == 0 do
              "\n"
            else
              ""
            end

        vm = tock.(vm)

        %{vm: vm, crt: crt}
      end
    )
    |> Map.put(:p, state.p)
  end

  def get_answer(state) when state.p == :part1 do
    state.acc
  end

  def get_answer(state) when state.p == :part2 do
    state.crt
  end
end

defmodule VirtualMachine do
  def new() do
    %{x: 1, tick: 0}
  end

  def plan_execute(instruction) do
    [instruction, args] =
      if instruction == "noop" do
        [instruction, nil]
      else
        String.split(instruction, " ")
      end

    plan_execute(instruction, args)
  end

  def plan_execute(instruction, args) when instruction == "addx" do
    args =
      case Integer.parse(args) do
        {args, _} -> args
        :error -> 0
      end

    if is_integer(args) do
      plan_execute("noop", nil) ++
        [
          fn vm ->
            vm
            |> Map.update(:tick, 2, &(&1 + 1))
            |> Map.update(:x, args, &(&1 + args))
          end
        ]
    else
      []
    end
  end

  def plan_execute(instruction, _) when instruction == "noop" do
    [fn vm -> Map.update(vm, :tick, 1, &(&1 + 1)) end]
  end
end
