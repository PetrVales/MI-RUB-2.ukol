require './Triangles.rb'

describe Triangle do

	it "creats triangle from three points" do
		a = Point.new(0,0)
		b = Point.new(1,0)
		c = Point.new(0,1)
    	triangle = Triangle.new(a, b, c)
    	triangle.a.should eq(a)
    	triangle.b.should eq(b)
    	triangle.c.should eq(c)
  	end

  	it "detemines if contains a point" do
		a = Point.new(0,0)
		b = Point.new(3,0)
		c = Point.new(0,3)
    	triangle = Triangle.new(a, b, c)
    	triangle.contains?(Point.new(1,1)).should eq(true)
    	triangle.contains?(Point.new(0,0)).should eq(true)
    	triangle.contains?(Point.new(3,3)).should eq(false)
  	end

  	it "computes its area" do
  		a = Point.new(0,0)
		b = Point.new(3,0)
		c = Point.new(0,3)
    	triangle = Triangle.new(a, b, c)
    	triangle.area.should eq(4.5)
  	end

  	it "computes union area of two triangles - if bigger triangle contains smaller triangle, union area equals the area of the bigger triangle" do
    	biggerTriangle = Triangle.new(Point.new(0,0), Point.new(10,0), Point.new(0,10))
    	smallerTriangle = Triangle.new(Point.new(1,1), Point.new(9,0), Point.new(0,9))
    	biggerTriangle.unionArea(smallerTriangle).should eq(biggerTriangle.area)
  	end

  	it "computes union area of two triangles - area of two wertex connected triangles is sum of their areas" do
    	firstTriangle = Triangle.new(Point.new(9,9), Point.new(9,0), Point.new(0,9))
    	secondTriangle = Triangle.new(Point.new(0,0), Point.new(9,0), Point.new(0,9))
    	firstTriangle.unionArea(secondTriangle).should eq(81)
  	end

  	it "computes union area of two triangles - area of two edge connected triangles is sum of their areas" do
    	firstTriangle = Triangle.new(Point.new(9,9), Point.new(9,0), Point.new(0,9))
    	secondTriangle = Triangle.new(Point.new(0,0), Point.new(9,0), Point.new(0,9))
    	firstTriangle.unionArea(secondTriangle).should eq(81)
  	end

end

describe Point do

	it "creats 2d point" do
		x = 0
		y = 0
		point = Point.new(x, y)
		point.x.should eq(x)
		point.y.should eq(x)
  	end

  	it "equals to by value" do
		point1 = Point.new(0, 0)
		point2 = Point.new(0, 0)
		(point1 == point2).should eq(true)
  	end

end

