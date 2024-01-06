defmodule Day23 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 23 A Long Walk
  https://adventofcode.com/2023/day/23
  """
  require FileHelper

  @doc """
    Part 1: Find longest path through hiking trails, not allowing going back up slopes (^,>,v,<)
    Part 2: Find longest path through hiking trails allowing going back up slopes
  """
  def solve(:part_1, filename) do
    {lines, bounds} =
      FileHelper.read_as_map(filename)

    lines
    |> Enum.reject(fn {_, v} -> v == "#" end)
    |> Map.new()
    |> calculate_longest_path(bounds)
  end

  def solve(:part_2, filename) do
    {lines, bounds} =
      FileHelper.read_as_map(filename)

    lines
    |> Enum.reject(fn {_, v} -> v == "#" end)
    |> Enum.map(fn {k, el} ->
      if slope?(el), do: {k, "."}, else: {k, el}
    end)
    |> Map.new()
    |> calculate_longest_path(bounds)
  end

  defp calculate_longest_path(lines, bounds) do
    {graph, start, finish} = setup_graph(lines, bounds)

    graph
    |> add_split_points(lines)
    |> calculate_weights(lines)
    |> find_longest_path(start, finish)
  end

  defp setup_graph(data, {_, max_y}) do
    {start, _} = Enum.find(data, fn {{_, y}, v} -> y == 0 && v == "." end)
    {finish, _} = Enum.find(data, fn {{_, y}, v} -> y == max_y - 1 && v == "." end)

    g =
      Graph.new()
      |> Graph.add_vertex(start)
      |> Graph.add_vertex(finish)

    {g, start, finish}
  end

  defp add_split_points(g, data) do
    Enum.reduce(data, g, fn {{x, y}, el}, g ->
      # If more than 2 neighbours record the point.
      # Other points in between will just count towards edge weight.
      num_neighbours = neighbours(el, {x, y}, data) |> Enum.count()

      if num_neighbours > 2 do
        Graph.add_vertex(g, {x, y})
      else
        g
      end
    end)
  end

  defp calculate_weights(g, data) do
    Graph.vertices(g)
    |> Enum.reduce(g, fn v, g ->
      add_weighted_edges(v, [{0, v}], [v], data, g)
    end)
  end

  def find_longest_path(g, start, finish) do
    Graph.Pathfinding.all(g, start, finish)
    |> Enum.map(&Enum.chunk_every(&1, 2, 1, :discard))
    |> Enum.map(fn path ->
      Enum.reduce(path, 0, fn [e1, e2], acc ->
        Graph.edge(g, e1, e2).weight + acc
      end)
    end)
    |> Enum.max()
  end

  defp add_weighted_edges(start, [{n, v} | stack], seen, data, g) do
    if(n != 0 && Graph.has_vertex?(g, v)) do
      # Reached a split point so record weight
      Graph.add_edge(g, start, v, weight: n)
    else
      neighbours(Map.get(data, v), v, data)
      |> Enum.reduce({g, stack, seen}, fn {_el, pos}, {g, stack, seen} ->
        if Enum.member?(seen, pos) do
          # Stop if we've already visited this point
          {g, stack, seen}
        else
          # Otherwise, increment count and record this point as seen
          g = add_weighted_edges(start, [{n + 1, pos} | stack], [pos | seen], data, g)
          {g, stack, seen}
        end
      end)
      |> then(fn {g, _, _} -> g end)
    end
  end

  defp neighbours(el, {x, y}, data) do
    possible_steps(el, {x, y})
    |> Enum.filter(&Map.has_key?(data, &1))
    |> Enum.map(fn {nx, ny} -> {Map.get(data, {nx, ny}), {nx, ny}} end)
  end

  # defp possible_steps("#", _), do: []
  defp possible_steps("^", {x, y}), do: [{x, y - 1}]
  defp possible_steps(">", {x, y}), do: [{x + 1, y}]
  defp possible_steps("v", {x, y}), do: [{x, y + 1}]
  defp possible_steps("<", {x, y}), do: [{x - 1, y}]

  defp possible_steps(_, {x, y}) do
    # North, East, South, West
    [{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}]
  end

  defp slope?(el), do: Enum.member?(["^", ">", "v", "<"], el)
end

filename = "#{File.cwd!()}/files/day_23_input.txt"

{uSecs, result} = :timer.tc(Day23, :solve, [:part_1, filename])
IO.puts("Part 1: #{result} (#{uSecs / 1_000_000} seconds)")

{uSecs, result} = :timer.tc(Day23, :solve, [:part_2, filename])
IO.puts("Part 2: #{result} (#{uSecs / 1_000_000} seconds)")
