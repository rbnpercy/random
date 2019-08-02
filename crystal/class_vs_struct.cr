require "benchmark"

class PointClass
  getter x
  getter y

  def initialize(@x : Int32, @y : Int32)
  end
end

struct PointStruct
  getter x
  getter y

  def initialize(@x : Int32, @y : Int32)
  end
end

Benchmark.ips do |x|
  x.report("class") { PointClass.new(1, 2) }
  x.report("struct") { PointStruct.new(1, 2) }
end
