defmodule Day17 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 17 - Clumsy Crucible
  https://adventofcode.com/2023/day/17
  """

  defmodule PathFinder do
    use Agent

    def start_link() do
      Agent.start_link(fn -> {nil, nil} end, name: __MODULE__)
    end

    def setup do
      Agent.update(__MODULE__, fn _ -> init() end)
    end

    def init do
      step = {{0, 0}, nil, 1}
      seen = %{step => 0}

      queue =
        PriorityQueue.new()
        |> PriorityQueue.push(step, 0)

      {queue, seen}
    end

    def next do
      value =
        Agent.get(__MODULE__, fn {queue, _seen} ->
          PriorityQueue.peek(queue)
          |> then(&elem(&1, 1))
        end)

      Agent.update(__MODULE__, fn {queue, seen} ->
        {_, queue} = PriorityQueue.pop(queue)
        {queue, seen}
      end)

      value
    end

    def distance(key) do
      Agent.get(__MODULE__, fn {_, seen} -> Map.get(seen, key) end)
    end

    def update(key, prev_key, step_dist) do
      Agent.update(__MODULE__, fn {queue, seen} ->
        exisiting_dist = Map.get(seen, key)
        dist = Map.get(seen, prev_key) + step_dist

        if exisiting_dist == nil || dist < exisiting_dist do
          queue = PriorityQueue.push(queue, key, dist)
          seen = Map.put(seen, key, dist)
          {queue, seen}
        else
          {queue, seen}
        end
      end)
    end
  end

  @doc """
    Part 1: Find the shortest path from upper left to lower right, with max of 3 moves in one direction
    Part 2: Find the shortest path, with max of 10 moves and min of 4 in one direction
  """
  def solve(:part_1, filename) do
    find(filename, {0, 3})
  end

  def solve(:part_2, filename) do
    find(filename, {4, 10})
  end

  defp find(filename, limits) do
    {map, goal} = read_map(filename)
    PathFinder.start_link()
    PathFinder.setup()
    shortest_path(map, limits, goal)
  end

  defp shortest_path(map, {min, _} = limits, goal) do
    {pos, dir, count} = PathFinder.next()

    if pos == goal && count >= min do
      PathFinder.distance({pos, dir, count})
    else
      add_neighbours(map, {pos, dir, count}, limits)
      shortest_path(map, limits, goal)
    end
  end

  defp add_neighbours(map, {pos, dir, dir_count} = step, limits) do
    next_dirs(map, pos, limits, dir, dir_count)
    |> Enum.map(fn {n_pos, n_dir} ->
      step_dist = Map.get(map, n_pos)
      n_dir_count = if dir == nil || dir == n_dir, do: dir_count + 1, else: 1
      PathFinder.update({n_pos, n_dir, n_dir_count}, step, step_dist)
    end)
  end

  defp next_dirs(map, {x, y}, {min, max}, prev_dir, dir_count) do
    [
      {{x, y - 1}, :north},
      {{x + 1, y}, :east},
      {{x, y + 1}, :south},
      {{x - 1, y}, :west}
    ]
    |> Enum.reject(fn {pos, dir} ->
      too_many = prev_dir == dir && dir_count == max
      too_few = prev_dir != nil && prev_dir != dir && dir_count < min

      opposite(dir) == prev_dir || too_many || too_few || !Map.has_key?(map, pos)
    end)
  end

  defp opposite(:north), do: :south
  defp opposite(:east), do: :west
  defp opposite(:south), do: :north
  defp opposite(:west), do: :east

  defp read_map(filename) do
    FileHelper.read_lines(filename)
    |> Enum.with_index()
    |> Enum.reduce({%{}, {0, 0}}, fn {line, y}, acc ->
      String.trim(line)
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {v, x}, {a, _} ->
        val = String.to_integer(v)
        {Map.put(a, {x, y}, val), {x, y}}
      end)
    end)
  end
end

filename = "#{File.cwd!()}/files/day_17_input.txt"
result = Day17.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day17.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
