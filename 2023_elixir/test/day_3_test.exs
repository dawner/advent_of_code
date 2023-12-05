defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Part 1 solve/2" do
    filename = "#{File.cwd!()}/test/files/day_3_test_input.txt"
    assert Day3.solve(:part_1, filename) == 4361
  end

  test "Part 1 solve/2 more complex" do
    filename = "#{File.cwd!()}/test/files/day_3_test_2_input.txt"
    # Duplicate counts: 1+11+11+1+1+11+11+1+1+1=50
    assert Day3.solve(:part_1, filename) == 50
  end

  test "Part 2 solve/2" do
    filename = "#{File.cwd!()}/test/files/day_3_test_input.txt"
    assert Day3.solve(:part_2, filename) == 467_835
  end

  test "Part 2 solve/2 more complex" do
    filename = "#{File.cwd!()}/test/files/day_3_test_2_input.txt"
    # Top gears included only: (1*11)+(1*11)
    assert Day3.solve(:part_2, filename) == 22
  end
end
