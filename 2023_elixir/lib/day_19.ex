defmodule Day19 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 19 Aplenty
  https://adventofcode.com/2023/day/19
  """

  @doc """
    Part 1: Classify parts depending on a set of rules, counting number accepted
  """
  def solve(:part_1, filename) do
    {workflows, parts} =
      FileHelper.read_lines(filename)
      |> Enum.reduce({%{}, []}, fn line, {workflows, parts} ->
        parse_line(line, {workflows, parts})
      end)

    results = Enum.filter(parts, fn part -> process("in", part, workflows) end)

    Enum.flat_map(results, fn part -> Enum.map(part, fn {_k, v} -> v end) end)
    |> Enum.sum()
  end

  # def solve(:part_2, filename) do
  # end

  defp process("A", _, _), do: true
  defp process("R", _, _), do: false

  defp process(key, part, workflows) do
    Map.get(workflows, key)
    |> check_rules(part, workflows)
  end

  defp check_rules([{nil, nil, nil, out}], part, workflows), do: process(out, part, workflows)

  defp check_rules([{p, op, val, out} | rules], part, workflows) do
    part_val = Map.get(part, p)

    if apply_rule(part_val, op, val) do
      process(out, part, workflows)
    else
      check_rules(rules, part, workflows)
    end
  end

  defp apply_rule(part_val, "<", val), do: part_val < val
  defp apply_rule(part_val, ">", val), do: part_val > val

  defp parse_line(line, {workflows, parts}) do
    if String.at(line, 0) == "{" do
      {workflows, [parse_part(line) | parts]}
    else
      {name, operations} = parse_workflow(line)
      {Map.put(workflows, name, operations), parts}
    end
  end

  defp parse_workflow(line) do
    [_, name, raw_operations] = Regex.run(~r/([a-z]+){(.*)}/, line)

    operations =
      String.split(raw_operations, ",")
      |> Enum.map(fn rules -> parse_rules(rules) end)

    {name, operations}
  end

  defp parse_rules(rule) do
    if String.contains?(rule, ":") do
      [_, part, op, val, out] = Regex.run(~r/([xmas]{1})([<>])([0-9]+):([a-zAR]+)/, rule)
      {part, op, String.to_integer(val), out}
    else
      {nil, nil, nil, rule}
    end
  end

  defp parse_part(line) do
    parts_regex = ~r/{x=(?<x>[0-9]+),m=(?<m>[0-9]+),a=(?<a>[0-9]+),s=(?<s>[0-9]+)/
    parts = Regex.named_captures(parts_regex, line)

    for {k, v} <- parts, into: %{}, do: {k, String.to_integer(v)}
  end
end

filename = "#{File.cwd!()}/files/day_19_input.txt"
result = Day19.solve(:part_1, filename)
IO.puts("Part 1: #{result}")
