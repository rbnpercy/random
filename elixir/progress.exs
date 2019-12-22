defmodule Progress do

  @rounding_precision 2
  @progress_bar_width 100  # Percentage of Terminal window's width
  @complete_character "█"  # Unicode Character 'FULL BLOCK' (U+2588)
  @incomplete_character "░"  # Unicode Character 'LIGHT SHADE' (U+2591)

  def bar(count, total) do
    percent = percent_complete(count, total)
    divisor = 100 / @progress_bar_width
    complete_count = round(percent / divisor)
    incomplete_count = @progress_bar_width - complete_count
    complete = String.duplicate(@complete_character, complete_count)
    incomplete = String.duplicate(@incomplete_character, incomplete_count)
    "#{complete}#{incomplete} (#{percent}%)"
  end

  defp percent_complete(count, total) do
    Float.round(100.0 * count / total, @rounding_precision)
  end
end

total = 100
Enum.each(1..total, fn task ->
  IO.write("\r#{Progress.bar(task, total)}")
  Process.sleep(50)
end)
IO.write("\n")
