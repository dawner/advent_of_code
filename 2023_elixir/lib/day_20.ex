defmodule Day20 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 20 Pulse Propagation
  https://adventofcode.com/2023/day/20
  """
  defmodule PulseMachines do
    use Agent

    def start_link({links, state}) do
      Agent.start_link(fn -> {links, state, %{high: 0, low: 0}} end)
    end

    def update_count(pid, pulse) do
      Agent.update(pid, fn {links, state, counts} ->
        counts =
          case pulse do
            :high -> %{counts | high: counts.high + 1}
            :low -> %{counts | low: counts.low + 1}
            nil -> counts
          end

        {links, state, counts}
      end)
    end

    def update_state(pid, {key, new_state}) do
      Agent.update(pid, fn {links, state, counts} ->
        {links, %{state | key => new_state}, counts}
      end)
    end

    def get_destinations(pid, key) do
      Agent.get(pid, fn {links, _, _} ->
        Map.get(links, key)
      end)
    end

    def get_state(pid, key) do
      Agent.get(pid, fn {_, state, _} ->
        Map.get(state, key)
      end)
    end

    def get_result(pid) do
      Agent.get(pid, fn {_, _, %{high: high, low: low}} ->
        high * low
      end)
    end
  end

  @doc """
    Part 1: Calculate the number of high/low pulses sent through modules (Flip flop % or Conjunction &)
  """
  def solve(:part_1, filename) do
    {:ok, pid} =
      process_file(filename)
      |> PulseMachines.start_link()

    Enum.map(1..1000, fn _i ->
      PulseMachines.update_count(pid, :low)
      cycle(pid, :low, "broadcaster")
    end)

    PulseMachines.get_result(pid)
  end

  defp cycle(_pid, {[], _pulse}, _prev), do: nil
  defp cycle(_pid, {_dest, nil}, _prev), do: nil

  defp cycle(pid, pulse, prev) do
    destinations = PulseMachines.get_destinations(pid, prev)

    Enum.reduce(destinations, [], fn key, next_round ->
      PulseMachines.update_count(pid, pulse)

      {next_state, next_pulse} =
        PulseMachines.get_state(pid, key)
        |> next(pulse, prev)

      if next_pulse == nil do
        next_round
      else
        PulseMachines.update_state(pid, {key, next_state})
        [{key, next_pulse} | next_round]
      end
    end)
    |> Enum.reverse()
    |> Enum.map(fn {key, pulse} ->
      cycle(pid, pulse, key)
    end)
  end

  defp next(nil, _pulse, _prev), do: {nil, nil}
  defp next({:flip, state}, :high, _prev), do: {{:flip, state}, nil}
  defp next({:flip, :off}, :low, _prev), do: {{:flip, :on}, :high}
  defp next({:flip, :on}, :low, _prev), do: {{:flip, :off}, :low}

  defp next({:conj, state}, pulse, prev) do
    state = Map.put(state, prev, pulse)

    if Enum.all?(state, fn {_k, v} -> v == :high end) do
      {{:conj, state}, :low}
    else
      {{:conj, state}, :high}
    end
  end

  defp get_type(module) do
    {module_type, module_name} = String.split_at(module, 1)

    case module_type do
      "%" -> {module_name, {:flip, :off}}
      "&" -> {module_name, {:conj, %{}}}
      _ -> {"broadcaster", {:broadcast, nil}}
    end
  end

  defp process_file(filename) do
    # Store all "connections (modules names -> destinations)
    # and initialize a map of all module states
    {connections, state} =
      FileHelper.read_lines(filename)
      |> Enum.reduce({%{}, %{}}, fn line, {connections, state} ->
        [module, destinations] = String.split(line, " -> ", trim: true)

        {module_name, module_type} = get_type(module)
        destinations = String.split(destinations, ", ", trim: true)

        {Map.put(connections, module_name, destinations),
         Map.put(state, module_name, module_type)}
      end)

    # Update states of conjunction modules to store every input module key
    # against the current pulse state - initially :low for all
    state =
      Enum.reduce(connections, state, fn {key, destinations}, acc ->
        Enum.reduce(destinations, acc, fn dest, inner_acc ->
          conj = Map.get(inner_acc, dest)

          if conj && elem(conj, 0) == :conj do
            new_type_info = Map.put(elem(conj, 1), key, :low)
            Map.put(inner_acc, dest, {:conj, new_type_info})
          else
            inner_acc
          end
        end)
      end)

    {connections, state}
  end
end

# filename = "#{File.cwd!()}/files/day_20_input.txt"
# result = Day20.solve(:part_1, filename)
# IO.puts("Part 1: #{result}")
