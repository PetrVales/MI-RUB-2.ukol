include Math

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
		if ((@a == point) || (@b == point) || (@c == point))
			return true
		end
		if sameSide(point, a, b, c) and sameSide(point, b, a, c) and sameSide(point, c, a, b) then
			return true
    	else
    		return false
    	end
	end

	def area 
		# ((@a.x * (@b.y - @c.y) + @b.x * (@c.y - @a.y) + @c.x * (@a.y - @b.y)) / 2.0).abs.round(4)
		((@a.x * @b.y + @b.x*@c.y + @c.x*@a.y - @a.y*@b.x - @b.y*@c.x - @c.y*@a.x) / 2.0).abs.round(4)
	end

	def areaNoRound
		# ((@a.x * (@b.y - @c.y) + @b.x * (@c.y - @a.y) + @c.x * (@a.y - @b.y)) / 2.0).abs
		(((@a.x * @b.y + @b.x*@c.y + @c.x*@a.y - @a.y*@b.x - @b.y*@c.x - @c.y*@a.x)) / 2.0).abs
	end

	def union(triangle)
		if (contains?(triangle.a) && contains?(triangle.b) && contains?(triangle.c))
			self
		elsif (triangle.contains?(a) && triangle.contains?(b) && triangle.contains?(c))
			triangle
		else
			polygon = []
			buildPolygon(self, polygon, triangle.a)
			buildPolygon(self, polygon, triangle.b)
			buildPolygon(self, polygon, triangle.c)
			buildPolygon(triangle, polygon, a)
			buildPolygon(triangle, polygon, b)
			buildPolygon(triangle, polygon, c)
			addLineIntersects(polygon, triangle)
			if polygon.length > 0 then
				CompositePolygon.new(self, triangle, Polygon.new(polygon))
			else
				nil
			end
		end
	end

	private
	def sameSide(testedPoint, knownPoint, i, j)
		cp1 = crossProduct(j - i, testedPoint - i)
	    cp2 = crossProduct(j - i, knownPoint - i)
	    if dotProduct(cp1, cp2) >= 0 then 
	    	return true
	    else 
	    	return false
	    end
	end
	def crossProduct(i, j)
		i.x * j.y - j.x * i.y
	end
	def dotProduct(i, j)
		i * j
	end
	def buildPolygon(triangle, polygon, p)
		if (triangle.contains?(p))
			polygon.push(p)
		end
	end
	def addLineIntersects(polygon, triangle)
		addEdgeIntersection(polygon, triangle, [a, b], [triangle.a, triangle.b])
		addEdgeIntersection(polygon, triangle, [a, b], [triangle.a, triangle.c])
		addEdgeIntersection(polygon, triangle, [a, b], [triangle.c, triangle.b])
		addEdgeIntersection(polygon, triangle, [a, c], [triangle.a, triangle.b])
		addEdgeIntersection(polygon, triangle, [a, c], [triangle.a, triangle.c])
		addEdgeIntersection(polygon, triangle, [a, c], [triangle.c, triangle.b])
		addEdgeIntersection(polygon, triangle, [c, b], [triangle.a, triangle.b])
		addEdgeIntersection(polygon, triangle, [c, b], [triangle.a, triangle.c])
		addEdgeIntersection(polygon, triangle, [c, b], [triangle.c, triangle.b])
	end
	def addEdgeIntersection(polygon, triangle, x, y)
		p = linesIntersect(x, y)
		if (p != nil && contains?(p) && triangle.contains?(p))
			polygon.push(p)
		end
	end
	def linesIntersect(x, y)
		line1 = Line.new(x[0], x[1])
		line2 = Line.new(y[0], y[1])
		line1.intersect(line2)
	end
end 

class Polygon

	def initialize(vertices)
		center = centerPoint(vertices)
		@vertices = vertices.sort {|a, b| 
			Math.atan2(a.y - center.y, a.x - center.x) <=> Math.atan2(b.y - center.y, b.x - center.x)
		}
	end

	def vertices
		@vertices
	end

	def area
		sum = 0
		for i in 0..(@vertices.length - 1)
			sum += @vertices[i].x * @vertices[(i + 1) % @vertices.length].y - @vertices[(i + 1) % @vertices.length].x * @vertices[i].y
		end
		(sum / 2.0).round(4).abs
	end

	def areaNoRound
		sum = 0
		for i in 0..(@vertices.length - 1)
			sum += @vertices[i].x * @vertices[(i + 1) % @vertices.length].y - @vertices[(i + 1) % @vertices.length].x * @vertices[i].y
		end
		(sum / 2.0).abs
	end

	def ==(polygon)
		if @vertices.length != polygon.vertices.length
			return false
		end
		for i in 0..(polygon.vertices.length - 1)
			if @vertices.index(polygon.vertices[i]) == nil
				return false
			end
		end
		true
	end

	private
	def centerPoint(vertices)
		sumX = 0.0
		sumY = 0.0
		vertices.each {|x| sumX += x.x; sumY += x.y }
		Point.new(sumX.to_f / vertices.length, sumY.to_f / vertices.length)
	end
end

class CompositePolygon < Polygon

	def initialize(a, b, p)
		@a = a
		@b = b
		@p = p
	end

	def area
		(@a.areaNoRound + @b.areaNoRound - @p.areaNoRound).round(4)
	end


	def ==(polygon)
		if (polygon.is_a? CompositePolygon)
			@a == polygon.a && @b == polygon.b && @p == polygon.p
		else
			false
		end
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

	def ==(point)
		if point == nil 
			false
		else
			@x == point.x && @y == point.y
		end
	end

	def -(point)
		Point.new(@x - point.x, @y - point.y)
	end
end

class Line
	def initialize(x, y)
		@x = x
		@y = y
	end

	def intersect(line)
		x1 = @x.x
		y1 = @x.y
		x2 = @y.x
		y2 = @y.y
		x3 = line.x.x
		y3 = line.x.y
		x4 = line.y.x
		y4 = line.y.y
		if (((x1 - x2)*(y3 - y4) - (y1 - y2)*(x3 - x4)) == 0)
			return nil
		else
			x = ((x1*y2 - y1*x2)*(x3 - x4) - (x1 - x2)*(x3*y4 - y3*x4)).to_f / ((x1 -x2)*(y3 - y4) - (y1 - y2)*(x3 - x4))
			y = ((x1*y2 - y1*x2)*(y3 - y4) - (y1 - y2)*(x3*y4 - y3*x4)).to_f / ((x1 -x2)*(y3 - y4) - (y1 - y2)*(x3 - x4))
			if (!x.nan? && !y.nan? && x.finite? && y.finite?)
				return Point.new(x, y)
			else
				return nil
			end
		end
	end

	def x
		@x
	end

	def y
		@y
	end
end

class Solver
	def solve
		puts "Zadejte souradnice prvniho vrcholu prvniho trojuhelniku: "
		a = readPoint
		puts "Zadejte souradnice druheho vrcholu prvniho trojuhelniku: "
		b = readPoint
		puts "Zadejte souradnice tretiho vrcholu prvniho trojuhelniku: "
		c = readPoint
		puts "Zadejte souradnice prvniho vrcholu druheho trojuhelniku: "
		x = readPoint
		puts "Zadejte souradnice druheho vrcholu druheho trojuhelniku: "
		y = readPoint
		puts "Zadejte souradnice tretiho vrcholu druheho trojuhelniku: "
		z = readPoint
		union = Triangle.new(a, b, c).union(Triangle.new(x, y, z))
		if (union == nil) then
			puts "Trojuhelniky se nedotykaji."
		else
			puts "Vysledny obsah: %.4f" % union.area.to_s
		end
	end

	private 
	def readPoint
		begin
			skipWhiteSpaces
			x = Float(gets(' ').strip)
			skipWhiteSpaces
			y = Float(gets(' ').strip)
			Point.new(x, y)
		rescue ArgumentError, NoMethodError
			puts "Spatny vstup."
			exit
		end
	end
	def skipWhiteSpaces
		c = gets(' ')
		while c.strip.empty? && !STDIN.eof?
			c = gets(' ')
		end
		STDIN.ungetc(c) 
	end
end
Solver.new.solve
