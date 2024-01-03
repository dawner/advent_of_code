defmodule Day22 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 22 Sand Slabs
  https://adventofcode.com/2023/day/22
  """
  require FileHelper

  defmodule Brick do
    defstruct [:min_x, :max_x, :min_y, :max_y, :min_z, :max_z]

    def get_coords(%Brick{min_x: x1, max_x: x2, min_y: y1, max_y: y2, min_z: z1, max_z: z2}) do
      {[x1, y1, z1], [x2, y2, z2]}
    end
  end

  defmodule SandSlab do
    use Agent

    def start_link({bricks, grid}) do
      Agent.start_link(
        fn ->
          Enum.with_index(bricks)
          |> Enum.reduce({%{}, grid}, fn {brick, i}, {bricks, grid} ->
            grid = add_brick(grid, brick, i)
            {Map.put(bricks, i, brick), grid}
          end)
        end,
        name: __MODULE__
      )
    end

    def grid do
      Agent.get(__MODULE__, fn {_bricks, grid} ->
        grid
      end)
    end

    def bricks do
      Agent.get(__MODULE__, fn {bricks, _grid} ->
        bricks
      end)
    end

    def print do
      Agent.get(__MODULE__, fn {_bricks, grid} ->
        Enum.map(grid, fn z ->
          Enum.map(z, fn y ->
            Enum.map(y, fn x ->
              IO.write(x)
            end)

            IO.write(" ")
          end)

          IO.write("\n")
        end)

        IO.write("-----------\n")
      end)
    end

    defp add_brick(grid, brick, i) do
      {[sx, sy, sz], [fx, fy, fz]} = Brick.get_coords(brick)

      Enum.reduce(sz..fz, grid, fn z, grid ->
        zline = Enum.at(grid, z)
        zline = replace_layer([sx, sy], [fx, fy], zline, i)
        List.replace_at(grid, z, zline)
      end)
    end

    def apply_gravity(i) do
      Agent.update(__MODULE__, fn {bricks, grid} ->
        brick = Map.get(bricks, i)
        {[sx, sy, sz], [fx, fy, fz]} = Brick.get_coords(brick)

        grid =
          Enum.reduce(sz..fz, grid, fn z, grid ->
            old_line = Enum.at(grid, z)
            new_line = Enum.at(grid, z - 1)

            zline = replace_layer([sx, sy], [fx, fy], new_line, i)

            grid = List.replace_at(grid, z - 1, zline)

            zline = replace_layer([sx, sy], [fx, fy], old_line, ".")

            List.replace_at(grid, z, zline)
          end)

        brick = %{brick | max_z: brick.max_z - 1, min_z: brick.min_z - 1}
        bricks = Map.put(bricks, i, brick)
        {bricks, grid}
      end)
    end

    defp replace_layer([x1, y1], [x2, y2], layer, replacement) do
      Enum.reduce(y1..y2, layer, fn y, layer ->
        line =
          Enum.reduce(x1..x2, Enum.at(layer, y), fn x, line ->
            List.replace_at(line, x, replacement)
          end)

        List.replace_at(layer, y, line)
      end)
    end
  end

  @doc """
    Part 1: Determine which bricks can be disintegrated from a 3D tower without making others fall
    Part 2: Determine how many cascading bricks will fall if each brick is removed
  """
  def solve(:part_1, filename) do
    setup(filename)

    bricks = SandSlab.bricks()
    grid = SandSlab.grid()
    grid_length = Enum.count(grid)

    Enum.count(bricks, fn {i, brick} ->
      # No bricks above would fall
      above = find_bricks_above(brick, grid, grid_length)
      move = Enum.any?(above, fn a -> move_down?(Map.get(bricks, a), [".", i]) end)
      !move
    end)
  end

  def solve(:part_2, filename) do
    setup(filename)

    sorted_bricks =
      SandSlab.bricks()
      |> Enum.sort(fn {_, a}, {_, b} -> a.min_z < b.min_z end)

    Enum.map(sorted_bricks, fn {i, brick} ->
      exclude = remove_brick(brick, i, sorted_bricks)
      Enum.count(exclude) - 2
    end)
    |> Enum.sum()
  end

  defp setup(filename) do
    {bricks, max} = read_coords(filename)
    SandSlab.start_link({Enum.reverse(bricks), build_grid(max)})

    SandSlab.print()
    move()
    SandSlab.print()
  end

  defp move() do
    changed =
      SandSlab.bricks()
      |> Enum.filter(fn {i, brick} ->
        if move_down?(brick) do
          SandSlab.apply_gravity(i)
        end
      end)

    if Enum.any?(changed) do
      move()
    end
  end

  defp remove_brick(brick, i, bricks) do
    Enum.reduce(bricks, [".", i], fn {bi, b}, exclude ->
      if b.min_z > brick.max_z && move_down?(b, exclude) do
        [bi | exclude]
      else
        exclude
      end
    end)
  end

  defp overlaps?(b1, b2) do
    b1.min_x <= b2.max_x && b1.min_y <= b2.max_y && b1.max_x >= b2.min_x && b1.max_y >= b2.min_y
  end

  defp move_down?(brick, exclude \\ ["."]) do
    {[min_x, min_y, min_z], [max_x, max_y, _max_z]} = Brick.get_coords(brick)
    grid = SandSlab.grid()

    if min_z > 1 do
      zslice = Enum.at(grid, min_z - 1)

      contains_block =
        Enum.any?(min_y..max_y, fn y ->
          Enum.any?(min_x..max_x, fn x ->
            el = Enum.at(zslice, y) |> Enum.at(x)
            !Enum.member?(exclude, el)
          end)
        end)

      !contains_block
    end
  end

  defp find_bricks_above(brick, grid, grid_length) do
    if brick.max_z + 1 < grid_length do
      zslice = Enum.at(grid, brick.max_z + 1)

      Enum.reduce(zslice, [], fn y, acc ->
        Enum.reduce(y, acc, fn x, nums ->
          if is_integer(x), do: [x | nums], else: nums
        end)
      end)
      |> Enum.uniq()
    else
      []
    end
  end

  defp read_coords(filename) do
    max = [0, 0, 0]

    FileHelper.read_lines(filename)
    |> Enum.reduce({[], max}, fn s, {bricks, max} ->
      result = Regex.run(~r/(\d+),(\d+),(\d+)~(\d+),(\d+),(\d+)/, s)
      {[z1, y1, x1], max} = to_coord(Enum.slice(result, 1..3), max)
      {[z2, y2, x2], max} = to_coord(Enum.slice(result, 4..6), max)
      [min_z, max_z] = Enum.sort([z1, z2])
      [min_y, max_y] = Enum.sort([y1, y2])
      [min_x, max_x] = Enum.sort([x1, x2])

      brick =
        %Brick{min_x: min_x, max_x: max_x, min_y: min_y, max_y: max_y, min_z: min_z, max_z: max_z}

      {[brick | bricks], max}
    end)
  end

  defp build_grid([maxx, maxy, maxz]) do
    List.duplicate(".", maxz + 1)
    |> Enum.map(fn _ ->
      List.duplicate(".", maxy + 1)
      |> Enum.map(fn _ ->
        List.duplicate(".", maxx + 1)
      end)
    end)
  end

  defp to_coord(nums, max) do
    Enum.with_index(nums)
    |> Enum.reduce({[], max}, fn {num, i}, {vals, max} ->
      val = String.to_integer(num)

      if Enum.at(max, i) < val do
        # Update max values
        {[val | vals], List.replace_at(max, i, val)}
      else
        {[val | vals], max}
      end
    end)
  end
end

# TODO this is not very efficient, but it works in a reasonable time (around 2-3min)
filename = "#{File.cwd!()}/files/day_22_input.txt"
result = Day22.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

# TODO this again is not very efficient, takes around 15min.
# Improving P1 move_down function would likely improve P2 too
filename = "#{File.cwd!()}/files/day_22_input.txt"
result = Day22.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
