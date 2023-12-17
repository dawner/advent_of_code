defmodule Day15 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 15
  https://adventofcode.com/2023/day/15
  """

  @doc """
    Part 1: Run a hash algorithm on a initialization sequence, return sum of results
    Part 2: With hash as box number, add/remove lenses from box and calculate focussing power of result
  """
  def solve(:part_1, filename) do
    read_instructions(filename)
    |> Enum.map(&hash/1)
    |> Enum.sum()
  end

  def solve(:part_2, filename) do
    read_instructions(filename)
    |> Enum.reduce(%{}, &process_lense/2)
    |> Enum.flat_map(fn {box_num, box} ->
      Enum.reverse(box)
      |> Enum.with_index()
      |> Enum.map(fn {{_, focal}, j} -> (1 + box_num) * (1 + j) * focal end)
    end)
    |> Enum.sum()
  end

  defp hash(segment) do
    segment
    |> String.split("", trim: true)
    |> Enum.reduce(0, fn <<c::utf8>>, acc ->
      rem((acc + c) * 17, 256)
    end)
  end

  defp process_lense(segment, boxes) do
    case Regex.run(~r/([a-z]+)([=|-])([1-9])?/, segment) do
      [_, label, "=", focal] ->
        update_box(boxes, label, focal)

      [_, label, "-"] ->
        remove(boxes, label)
    end
  end

  defp update_box(boxes, label, focal) do
    box_num = hash(label)

    new_box =
      Map.get(boxes, box_num)
      |> add_element(label, String.to_integer(focal))

    Map.put(boxes, box_num, new_box)
  end

  defp add_element(nil, label, focal), do: [{label, focal}]

  defp add_element(box, label, focal) do
    case Enum.find_index(box, fn {l, _} -> l == label end) do
      nil -> [{label, focal} | box]
      i -> List.replace_at(box, i, {label, focal})
    end
  end

  defp remove(boxes, label) do
    box_num = hash(label)

    Map.get(boxes, box_num)
    |> remove_element(box_num, label, boxes)
  end

  defp remove_element(nil, _box_num, label, boxes), do: boxes

  defp remove_element(box, box_num, label, boxes) do
    el = Enum.find(box, fn {l, _} -> l == label end)
    new_box = List.delete(box, el)
    Map.put(boxes, box_num, new_box)
  end

  defp read_instructions(filename) do
    {:ok, file_contents} = File.read(filename)

    file_contents
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
  end
end

filename = "#{File.cwd!()}/files/day_15_input.txt"
result = Day15.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day15.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
