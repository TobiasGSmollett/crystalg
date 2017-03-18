require "./*"

module Crystalg::Geometry
  class Point
    include Comparable(Point)
    
    getter x, y

    def initialize(@x : Float64, @y : Float64) end

    def +(other : Point)
      Point.new(x + other.x, y + other.y)
    end

    def -(other : Point)
      Point.new(x + (-other.x), y + (-other.y))
    end

    def *(other : Number)
      Point.new(x * other, y * other)
    end

    def /(other : Number)
      Point.new(x / other, y / other)
    end
    
    def <=>(other : Point)
      if x != other.x
        x <=> other.x
      else
        y <=> other.y
      end
    end

    def norm : Float
      (x * x + y * y).as(Float).sqrt
    end

    def distance(other : Point) : Float
      (self - other).norm
    end

    def dot(other : Point) : Float
      x * other.x + y * other.y
    end

    def cross(other : Point) : Float
      x * other.y - y * other.x
    end

    def rotate(radian : Float, pivot : Point = Point.new(0,0))
      Point.new(
        LibM.cos(r) * (x - pivot.x) - LibM.sin(r) * (y - pivot.y) + pivot.x,
        LibM.sin(r) * (x - pivot.x) + LibM.cos(r) * (y - pivot.y) + pivot.y)
    end

    def arg : Float
      LibM.atan(y/x) if x.sign > 0
      LibM.atan(y/x) + PI if x.sign < 0
      PI / 2.0.as Float  if y.sign > 0
      3.0 * PI / 2.0.as Float if y.sign < 0
      0
    end
  end
end