defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "solve/2 part 1" do
    assert Day5.solve(:part_1, "#{File.cwd!()}/test/files/day_5_test_input.txt") == 35
  end

  test "solve/2 part 2" do
    assert Day5.solve(:part_2, "#{File.cwd!()}/test/files/day_5_test_input.txt") == 46
  end

  test "process_seed/1" do
    setup()
    assert Day5.process_seed(79) == 82
    assert Day5.process_seed(14) == 43
    assert Day5.process_seed(55) == 86
    assert Day5.process_seed(13) == 35
  end

  defp setup do
    [_ | garden_details] =
      "#{File.cwd!()}/test/files/day_5_test_input.txt"
      |> FileHelper.read_lines()

    Day5.setup_almanac(garden_details)
  end
end
