class Triangle
	def initialize(a, b, c)
		@a = a
		@b = b
		@c = c
	end

	def a
		@a
	end

	def b
		@b
	end

	def c
		@c
	end

	def contains?(point)
		b1 = sign(point, @a, @b) < 0
		b2 = sign(point, @b, @c) < 0
		b3 = sign(point, @c, @a) < 0
		(b1 == b2) && (b2 == b3)
	end

	def area 
		(@a.x * (@b.y - @c.y) + @b.x * (@c.y - @a.y) + @c.x * (@a.y - @b.y)).abs / 2.0
	end

	def unionArea(triangle)
		area = 0
		if (contains?(triangle.a) && contains?(triangle.b) && contains?(triangle.c))
			area = area()
		elsif (triangle.contains?(@a) && triangle.contains?(@b) && triangle.contains?(@c))
			area = triangle.area
		elsif (isOneCommonVertex(triangle))
			area = area() + triangle.area
		elsif (isOneCommonEdge(triangle))
			area = area() + triangle.area
		# else
		# 	area = area() + triangle.area - intersectArea(triangle)
		end
			
		area
	end

	private
	def sign(p1, p2, p3)
		(p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
	end

	def isOneCommonVertex(triangle)
		 ((!(contains?(triangle.a) && contains?(triangle.b)) && (triangle.c == @a || triangle.c == @b || triangle.c == @c)) ||
					(!(contains?(triangle.b) && contains?(triangle.c)) && (triangle.a == @a || triangle.a == @b || triangle.a == @b)) ||
					(!(contains?(triangle.c) && contains?(triangle.a)) && (triangle.b == @a || triangle.b == @b || triangle.b == @c)))
	end

	def isOneCommonEdge(triangle)

	end

end 


class Point
	def initialize(x, y)
		@x = x
		@y = y
	end

	def x
		@x
	end

	def y
		@y
	end

	def to_s
		"[" + @x.to_s + ", " + @y.to_s + "]"
	end

	def ==(triangle)
		@x == triangle.x && @y == triangle.y
	end
end