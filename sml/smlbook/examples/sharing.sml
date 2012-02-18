signature VECTOR =
  sig
    type vector
    val zero : vector
    val scale : real * vector -> vector
    val add : vector * vector -> vector
    val dot : vector * vector -> real
  end

signature POINT =
  sig
    structure Vector : VECTOR
    type point
    (* move a point along a vector *)
    val translate : point * Vector.vector -> point
    (* the vector from a to b *)
    val ray : point * point -> Vector.vector
  end    

signature SPHERE =
  sig
    structure Vector : VECTOR
    structure Point : POINT
    type sphere
    val sphere : Point.point * Vector.vector -> sphere
  end

signature GEOMETRY =
  sig
    structure Point : POINT
    structure Sphere : SPHERE
  end



signature SPHERE =
  sig
    structure Vector : VECTOR
    structure Point : POINT
    sharing type Point.Vector.vector = Vector.vector
    type sphere
    val sphere : Point.point * Vector.vector -> sphere
  end

signature GEOMETRY =
  sig
    structure Point : POINT
    structure Sphere : SPHERE
    sharing type Point.point = Sphere.Point.point
            and  Point.Vector.vector = Sphere.Vector.vector
  end

signature SPHERE =
  sig
    structure Vector : VECTOR
    structure Point : POINT
    sharing Point.Vector = Vector
    type sphere
    val sphere : Point.point * Vector.vector -> sphere
  end

signature GEOMETRY =
  sig
    structure Point : POINT
    structure Sphere : SPHERE
    sharing Point = Sphere.Point
        and Point.Vector = Sphere.Vector
  end


signature SPHERE =
  sig
    structure Point : POINT
    type sphere
    val sphere : Point.point * Point.Vector.vector -> sphere
  end

signature GEOMETRY =
  sig
    structure Point : POINT
    structure Sphere : SPHERE
    sharing Point = Sphere.Point
  end

signature SPHERE =
  sig
    type sphere
    val sphere : Point.point * Point.Vector.vector -> sphere
  end

signature SEMI_SPACE =
  sig
    structure Point : POINT
    type semispace
    val side : Point.point * semispace -> bool option
  end

signature EXTD_GEOMETRY =
  sig
    structure Sphere : SPHERE
    structure SemiSpace : SEMI_SPACE
    sharing Sphere.Point = SemiSpace.Point
  end
