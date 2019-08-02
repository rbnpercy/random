i = 0
while i < 10
  proc = ->(x : Int32) do
    spawn do
      puts(x)
    end
  end
  proc.call(i)
  i += 1
end

Fiber.yield
