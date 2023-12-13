defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "solve/2 part 1 - expansion x2" do
    assert Day11.solve("#{File.cwd!()}/test/files/day_11_test_input.txt", 2) == 374
  end

  test "solve/2 part 2 - expansion x10" do
    assert Day11.solve("#{File.cwd!()}/test/files/day_11_test_input.txt", 10) == 1030
  end

  test "solve/2 part 2 - expansion x100" do
    assert Day11.solve("#{File.cwd!()}/test/files/day_11_test_input.txt", 100) == 8410
  end
end
