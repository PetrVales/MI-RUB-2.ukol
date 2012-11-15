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
		(@a.x * (@b.y - @c.y) + @b.x * (@c.y - @a.y) + @c.x * (@a.y - @b.y)).abs / 2.0
	end

	def union(triangle)
		if (contains?(triangle.a) && contains?(triangle.b) && contains?(triangle.c))
			Polygon.new([a, b, c])
		elsif (triangle.contains?(a) && triangle.contains?(b) && triangle.contains?(c))
			Polygon.new([triangle.a, triangle.b, triangle.c])
		else
			polygon = []
			buildPolygon(polygon, triangle.a)
			buildPolygon(polygon, triangle.b)
			buildPolygon(polygon, triangle.c)
			addLineIntersects(polygon, triangle)
			# puts polygon.to_s
			if polygon.length > 0 then
				CompositePolygon.new(self, triangle, Polygon.new(polygon))
			else
				raise "no intersect area"
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
	def buildPolygon(polygon, p)
		if (contains?(p))
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
		(sum / 2).round(5).abs
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
		Point.new(sumX / vertices.length, sumY / vertices.length)
	end
end

class CompositePolygon < Polygon

	def initialize(a, b, p)
		@a = a
		@b = b
		@p = p
	end

	def area
		# puts @a.area.to_s + " + " + @b.area.to_s + " - " + @p.area.to_s
		@a.area + @b.area - @p.area
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

	def contains(p)
		slope = ((@x.y - @y.y).to_f / (@x.x - @y.x))
		slopeXP = ((@x.y - p.y).to_f / (@x.x - p.x))
		slopePY = ((p.y - @y.y).to_f / (p.x - @y.x))
		# puts slope.to_s + " ; " + slopeXP.to_s + " ; " + slopePY.to_s + "              " + @x.to_s + " ; " + @y.to_s + " ; " + p.to_s
		(slope == slopeXP) && (slope == slopePY) && (p.x <= @x.x || p.x <= @y.x) && (p.y <= @x.y || p.y <= @y.y)
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
			if (x.zero?)
				x = 0.0
			end
			y = ((x1*y2 - y1*x2)*(y3 - y4) - (y1 - y2)*(x3*y4 - y3*x4)).to_f / ((x1 -x2)*(y3 - y4) - (y1 - y2)*(x3 - x4))
			if (y.zero?)
				y = 0.0
			end
			p = Point.new(x, y)
			if (!p.x.nan? && !p.y.nan? && p.x.finite? && p.y.finite? && contains(p) && line.contains(p))
				return p
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