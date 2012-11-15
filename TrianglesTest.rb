require './Triangles.rb'

describe Triangle do

	it "creats triangle from three points" do
		a = Point.new(0, 0)
		b = Point.new(1, 0)
		c = Point.new(0, 1)
    triangle = Triangle.new(a, b, c)
    triangle.a.should eq(a)
    triangle.b.should eq(b)
    triangle.c.should eq(c)
  end

  it "detemines if contains a point" do

		a = Point.new(0, 0)
		b = Point.new(3, 0)
		c = Point.new(0, 3)
    triangle = Triangle.new(a, b, c)
    triangle.contains?(Point.new(1, 1)).should eq(true)
    triangle.contains?(Point.new(0, 0)).should eq(true)
    triangle.contains?(Point.new(0.0, 0.0)).should eq(true)
    triangle.contains?(Point.new(3, 3)).should eq(false)
    Triangle.new(Point.new(10, 5), Point.new(20, -5), Point.new(0, -5)).contains?(Point.new(15.0, 0.0)).should eq(true)
    Triangle.new(Point.new(10, 5), Point.new(20, -5), Point.new(0, -5)).contains?(Point.new(5.0, 0.0)).should eq(true)
    Triangle.new(Point.new(10, 5), Point.new(20, -5), Point.new(0, -5)).contains?(Point.new(12.5, 7.5)).should eq(false)
    Triangle.new(Point.new(0, 0), Point.new(20, 0), Point.new(0, 20)).contains?(Point.new(0, -5)).should eq(false)
    Triangle.new(Point.new(0, 0), Point.new(10, 0), Point.new(0, 10)).contains?(Point.new(1, 1)).should eq(true)
    Triangle.new(Point.new(0, 0), Point.new(10, 0), Point.new(0, 10)).contains?(Point.new(9, 0)).should eq(true)
    Triangle.new(Point.new(0, 0), Point.new(10, 0), Point.new(0, 10)).contains?(Point.new(0, 9)).should eq(true)
    Triangle.new(Point.new(0, 0), Point.new(10, 0), Point.new(0, 10)).contains?(Point.new(0.0, 1.0)).should eq(true)
    Triangle.new(Point.new(1, 1), Point.new(9, 1), Point.new(1, 9)).contains?(Point.new(0.0, 1.0)).should eq(false)
  end

  it "computes its area" do
  	a = Point.new(0,0)
		b = Point.new(3,0)
		c = Point.new(0,3)
    triangle = Triangle.new(a, b, c)
    triangle.area.should eq(4.5)
  end

  it "creats polygon when unioned with a triangle - a triangle inside another triangle" do
    biggerTriangle = Triangle.new(Point.new(0, 0), Point.new(10, 0), Point.new(0, 10))
    smallerTriangle = Triangle.new(Point.new(1, 1), Point.new(9, 1), Point.new(1, 9))
    biggerTriangle.union(smallerTriangle).area.should eq(50 + 32 - 32)
    smallerTriangle.union(biggerTriangle).area.should eq(50.0000)
  end


  it "creats polygon when unioned with a triangle - star polygon" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(2, 0), Point.new(0, 2))
    secondTriangle = Triangle.new(Point.new(2, 0), Point.new(2, 2), Point.new(0, 4))
    firstTriangle.union(secondTriangle).area.should eq(4.0000)
  end

  it "creats polygon when unioned with a triangle - one point in" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(20, 0), Point.new(0, 20))
    secondTriangle = Triangle.new(Point.new(10, 5), Point.new(20, -5), Point.new(0, -5))
    firstTriangle.union(secondTriangle).area.should eq(200 + 100 - 25)
  end

  it "creats polygon when unioned with a triangle - two points in" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(25, 0), Point.new(0, 25))
    secondTriangle = Triangle.new(Point.new(5, 5), Point.new(15, 5), Point.new(10, -5))
    firstTriangle.union(secondTriangle).area.should eq(312.5 + 50 - 37.5)
  end

  it "creats polygon when unioned with a triangle - point on edge" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(20, 0), Point.new(0, 20))
    secondTriangle = Triangle.new(Point.new(10, 0), Point.new(15, -5), Point.new(5, -5))
    firstTriangle.union(secondTriangle).area.should eq(200 + 25 - 0)
  end

  it "creats polygon when unioned with a triangle - edges intersects" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(20, 0), Point.new(0, 20))
    secondTriangle = Triangle.new(Point.new(10, -5), Point.new(5, 0), Point.new(15, 0))
    firstTriangle.union(secondTriangle).area.should eq(200 + 25 - 0)
  end

  it "creats polygon when unioned with a triangle - shared vertex" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(20, 0), Point.new(0, 20))
    secondTriangle = Triangle.new(Point.new(0, 0), Point.new(-20, 0), Point.new(0, -20))
    firstTriangle.union(secondTriangle).area.should eq(200 + 200 - 0)
  end

  it "creats polygon when unioned with a triangle - no intersect" do
    firstTriangle = Triangle.new(Point.new(1, 1), Point.new(20, 1), Point.new(1, 20))
    secondTriangle = Triangle.new(Point.new(-1, -1), Point.new(-20, -1), Point.new(-1, -20))
    firstTriangle.union(secondTriangle).should eq(nil)
  end

  it "2.09" do
    firstTriangle = Triangle.new(Point.new(0, 0), Point.new(2, 2), Point.new(0, 4))
    secondTriangle = Triangle.new(Point.new(1, 2), Point.new(3, 0), Point.new(3, 4))
    firstTriangle.union(secondTriangle).area.should eq(7.5)
  end

  it "3.00" do
    firstTriangle = Triangle.new(Point.new(-4.411525, -2.117070), Point.new(4.119449, 1.851282), Point.new(-0.430301, 0.486771))
    secondTriangle = Triangle.new(Point.new(3.421203, 3.835558), Point.new(2.838781, -1.470002), Point.new(-2.193104, 1.434644))
    firstTriangle.union(secondTriangle).area.should eq(15.9879)
  end    

  it "3.01" do
    firstTriangle = Triangle.new(Point.new(-4.659108, 0.382158), Point.new(4.017545, 1.941800), Point.new(-1.420865, -0.297085))
    secondTriangle = Triangle.new(Point.new(-2.053315, -3.623354), Point.new(-0.266349, -2.385332), Point.new(3.581862, 3.493331))
    firstTriangle.union(secondTriangle).area.should eq(8.1658)
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
    (point1 == nil).should eq(false)
  end

end

describe Line do
  # it "creates line defined by two points" do
  #   point1 = Point.new(0, 0)
  #   point2 = Point.new(4, 4)
  #   line = Line.new(point1, point2)
  #   line.contains(Point.new(1, 1)).should eq(true)
  #   line.contains(Point.new(1, 2)).should eq(false)
  #   line.contains(Point.new(5, 5)).should eq(false)
  #   line = Line.new(Point.new(10, 5),Point.new(0, -5))
  #   line.contains(Point.new(12.5, 7.5)).should eq(false)
  #   Line.new(Point.new(0, 0), Point.new(0, 10)).contains(Point.new(0, 9)).should eq(true)
  #   Line.new(Point.new(0, 0), Point.new(0, 10)).contains(Point.new(0, 11)).should eq(false)
  #   Line.new(Point.new(0, 0), Point.new(20, 0)).contains(Point.new(0, -5)).should eq(false)
  #   Line.new(Point.new(0, 0), Point.new(0, 20)).contains(Point.new(0, -5)).should eq(false)
  #   Line.new(Point.new(0, 20), Point.new(20, 0)).contains(Point.new(0, -5)).should eq(false)
  # end

  it "intersect with another line in a point" do
    line1 = Line.new(Point.new(0, 0), Point.new(1, 1))
    line2 = Line.new(Point.new(0, 1), Point.new(1, 0))
    line1.intersect(line2).should eq(Point.new(0.5, 0.5))
    line2.intersect(line2).should eq(nil)
  end
end

# describe Polygon do

#   it "creats 2d polygon from array of points" do
#     point1 = Point.new(0, 0)
#     point2 = Point.new(1, 0)
#     point3 = Point.new(1, 1)
#     point4 = Point.new(0, 1)
#     polygon = Polygon.new([point1, point2, point3, point4])
#     polygon.vertices.should eq([point1, point2, point3, point4])
#   end

#   it "computes its area" do
#     point1 = Point.new(0, 0)
#     point2 = Point.new(10, 0)
#     point3 = Point.new(10, 10)
#     point4 = Point.new(0, 10)
#     polygon = Polygon.new([point1, point2, point3, point4])
#     polygon.area.should eq(100)
#   end

#   it "equals to polygon with same vertices" do
#     first = Polygon.new([Point.new(0, 0), Point.new(10, 0), Point.new(10, 10), Point.new(0, 10)])
#     second = Polygon.new([Point.new(0, 0), Point.new(10, 0), Point.new(10, 10), Point.new(0, 10)])
#     (first == second).should eq(true)
#   end

#   it "should not equal to polygon with different vertices" do
#     first = Polygon.new([Point.new(1, 0), Point.new(10, 0), Point.new(10, 10), Point.new(0, 10)])
#     second = Polygon.new([Point.new(0, 0), Point.new(10, 0), Point.new(10, 10), Point.new(0, 10)])
#     (first == second).should eq(false)
#   end

# end

