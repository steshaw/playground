(* These are the examples of Tips for Computer Scientists on Standard ML (Revised), by Mads Tofte, April 5, 2008 *)

(* The next two lines are specific to Moscow ML. Remove them if you use another implementation of Standard ML *)
(* load "Int"; *)
(* load "Real"; *)

(* example 1.1 *)

val a = 1;
val b = 0;
val c = ~37;

(* example 1.2 *)

val e1'1 = 0.7;
val e1'2 = 3.1415;
val e1'3 = ~3.32E~7;

(* example 2.1 *)
val e2'1a = 2+3;
val e2'1b = 2.0+real(5);

(* example 2.2 *)

fun square(x:int) = x*x;
fun square'(x) = (x:int) * x;

val poste2'2 = ~(2+3);
val poste2'2 = ~(2.0 * 7.0);

(* example 4.1 *)

val e4'1a = [2,3,5]
val e4'1b = ["ape","man"];

val poste4'1a= nil;
val poste4'1b= []
val poste4'1c = 2::3::5::nil;

(* example 6.1 *)

val poste6'1a = 
   let val pi = 3.1415
   in  pi * pi
   end;

(* example 6.2 *)
   val x = 3;

(* example 6.3 *)

   val x = 3
   val y = x+x;

(* example 6.4 *)
   local 
     val x = 3;
     val y = 5
   in
     val z = x+y
   end   ;

(* example 6.5 *)

   val x = 3
   val y = x
   val x = 4;

(* example 6.6 *)

  fun fac(n) = 
    if n=0 then 1 
    else n*fac(n-1)
  val x = fac(5)  (* or fac 5, 
               if one prefers *)

(* sec 7 *)

fun f x y = (x+y):int;

val f' = fn x=>fn y=>(x+y):int;

(* example 7.1 *)

val e7'1=  map op + [(1,2),(2,3),(4,5)];

(* example 7.2 *)
  local val l = 15
  in
    fun f(r) = l + r
  end;
  val y = 
    let val l = [7,9,12]
    in f(length l)
    end;

(* example 8.1 *)

val e8'1 = {make = "Ford", built = 1904};

(* example 9.1 *)
  val x = 3;
  fun f(y) = x+y;

(* example 9.2 *)

  val pair = (3,4)
  val (x,y) = pair
  val z = x+y;

(* example 9.3 *)
  val car = {make = "Ford", 
             built = 1904}
  fun modernize{make = m, 
                built = year}=
        {make = m , 
         built = year+1};

(* example 9.4 *)
  fun modernize{make, built} =
    {make = make, 
     built = built+1};

  val {make, built, ...} =
      {built = 1904, 
       colour = "black", 
       make = "Ford"}


(* example 9.5 *)
  fun one() = 1;

(* example 9.6 *)
   val mylist = [1,2,3]
   val first::rest = mylist;

(* example 10.1 *)
  fun length l =
    case l of
      [] => 0
    | _ ::rest=>1+length rest

(* example 11.1 *)
  fun length [] = 0
    | length (_::rest) = 
         1 + length rest

(* example 11.2 *)
  fun even 0 = true
    | even n = odd(n-1)
  and odd  0 = false
    | odd  n = even(n-1);

(* example 11.3 *)
  fun update f d r  =
  case f of
    [] => [(d,r)]
  | ((p as (d',_)):: rest)=>
      if d=d' then (d,r)::rest
      else p::update rest d r;

(* example 15.1 *)
  datatype colour = BLACK | WHITE;

(* example 15.2 

  datatype 'a list = 
    nil
  | op :: of 'a * 'a list;
*)

(* example 16.1 *)
  exception NoSuchPerson
  exception BadLastName of string;

(* example 16.2 *)

  fun findFred [] = 
        raise NoSuchPerson
    | findFred (p::ps) =
        case p of
          {name = "Fred", 
           location} => location
        | _ => findFred ps
  
 fun someFredWorking(staff)=
   (case findFred(staff) of
      "office" => true
    | "conference" => true
    | _ => false
   )handle NoSuchPerson => false;

(* example 17.1 *)
  let val r = ref(0)
  in r:= !r + 1;
     r:= !r + 1;
     r
  end;

(* example 17.2 *)
  local 
    val own = ref 0
  in
    fun fresh_int() =
     (own:= !own + 1;
      !own
     )
  end

(* example 17.3 *)
   val i = ref 0;
   fun P(r,v)= 
     (i:= v; 
      r:= v+1
     );

(* sec 19 *)

fun displayCountry(country,cap)=
  TextIO.output(TextIO.stdOut,
    "\n" ^ country 
    ^ "\t" ^ cap)
fun displayCountries L =
  (TextIO.output(TextIO.stdOut, 
     "\nCountries\
     \ and their capitals:\n\n");
   map displayCountry L;
   TextIO.output(TextIO.stdOut, 
     "\n\n")
  );


(*
val _ = TextIO.output(TextIO.stdOut,
            "Type a line and hit <ret>:\n");

val myLine = 
    TextIO.inputLine(TextIO.stdIn);
*)

(* structure *)

  structure Year =
  struct
    type year = int
    fun next(y:year)=
      y+1
    fun toString(y)= 
      Int.toString(y)
  end
 
(* signature *)
  
  signature YR =
  sig
    type year
    val next: 
      year-> year
    val toString: 
      year -> string
  end;

(* structure matching *)

  structure Year' (*: YR*) =
  struct
    type year = string
    fun next(y)=y+1
    fun toString(y) = 
      Int.toString(y)
  end;

 
  (* Year matches YR, but Year' does not.*)

(* transparent signature constraint *)
   
  structure Year1: YR =
  struct
    type year = int
    fun next(y:year) =
      y+1
    fun toString(y) = 
      Int.toString(y)
  end

  val s = Year1.toString 1900;

(* opaque signature constraint *)

  structure Year2:> YR =
  struct
    type year = int
    fun next(y:year) =
      y+1
    fun toString(y) = 
      Int.toString(y)
  end

  (*val s = Year2.toString 1900;*)

  (* The above does not typecheck. In fact there is no way of
     constructing years outside Year2 with this constaint.
     Let us expand signature YR with a spec of a function,ad,
     that can create years: *)

  signature YEAR = 
  sig 
    eqtype year
    val ad: int->year
    val next: 
      year-> year
    val toString: 
      year -> string
  end

  structure Year:> YEAR =
  struct
    type year = int
    fun next(y:year) =
      y+1
    fun ad i = i 
    fun toString(y) = 
      Int.toString(y)
  end

  val s = Year.toString(Year.ad 1900)

  (* the above introduces eqtype *)

  (* If we write code using Year rather than
     integers for years, we make the code more modular.
     For example, if we later change the implementation of
     the toString function as follows: *)

(*
  structure Y:> YEAR =
  struct
    type year = int
    fun next(y:year) =
      y+1
    fun ad i = i 
    fun toString(y) = 
      Int.toString(y)^" AD"
  end
*)

  (* then this change is reflected
     in all code that is written in terms of the
     Y structure. The function ad may look like
     an unnecessary complication, but it helps to make
     explicit which integer constants in the program are 
     actually year constants. *)

(* writing structure that refer to other structures *)

signature MANUFACTURER =
  sig
    type year
    type car
    val first: car 
    val built: car -> year
    val evolve: car  -> car
    val toString: car -> string
  end;

structure Ford:> MANUFACTURER =
  struct
    type year = Year.year
    type car = {make: string, 
                built: Year.year,
                price: real}
    fun built(c:car) = #built c
    val first =
      {make = "Ford Model A",
       built= Year.ad 1903,
       price = 750.0} (*USD*)
    (* assume 4 % inflation 
       per year: *)
    val yr_inflation = 1.04 
    fun evolve(c:car)=
        {make = #make c, 
         built = Year.next(built c),
         price = yr_inflation 
               * #price c}
    fun toString(c)= 
      #make c ^ 
      "  USD "  ^ 
      Int.toString(
        Real.floor(#price c))
  end;

  (* This typechecks. Moreover, the opaque signature constraint
     hides the fact that car is a record type outside the declation
     of Ford. *)

(* Type abbreviations in signatures  *)

  (* Explain syntax and semantics of type abbreviation *)

  (* Example: *)
  (* val s = Year.toString(Ford.built Ford.first) *)

  (* will not type check. The opaque signature constraint makes
     Ford.year a new type which, outside the declaration of Ford,
     has nothing to do with the type Y.year. What we need to do is
     to make the Ford structure a little less opaque, without making
     it completely transparent (as could be done with a transparent signnature
     constraint. This can be done in a number of ways. It can be
     done using a type abbrevation in the signature: *)

signature MANUFACTURER' =
  sig
    type year = Year.year
    type car
    val first: car
    val built: car -> year
    val evolve: car  -> car
    val toString: car -> string
  end;

structure Ford:> MANUFACTURER' =
  struct
    type year = Year.year
    type car = {make: string, 
                built: Year.year,
                price: real}
    fun built(c:car) = #built c
    val first =
      {make = "Ford Model A",
       built= Year.ad 1903,
       price = 750.0} (*USD*)
    (* assume 4 % inflation 
       per year: *)
    val yr_inflation = 1.04 
    fun evolve(c:car)=
        {make = #make c, 
         built = Year.next(built c),
         price = yr_inflation 
               * #price c}
    fun toString(c)= 
      #make c ^ 
      "  USD "  ^ 
      Int.toString(
        Real.floor(#price c))
  end;

  val s = Year.toString(Ford.built Ford.first)

(* Type Realisation*)

  (* Instead of adding a type abbreviation in
     the declaration of the signature, one can
     use the where type as follows: *)

structure Ford:> 
      MANUFACTURER 
      where type year=Year.year =
  struct
    type year = Year.year
    type car = {make: string, 
                built: Year.year,
                price: real}
    fun built(c:car) = #built c
    val first =
      {make = "Ford Model A",
       built= Year.ad 1903,
       price = 750.0} (*USD*)
    (* assume 4 % inflation 
       per year: *)
    val yr_inflation = 1.04 
    fun evolve(c:car)=
        {make = #make c, 
         built = Year.next(built c),
         price = yr_inflation 
               * #price c}
    fun toString(c)= 
      #make c ^ 
      "  USD "  ^ 
      Int.toString(
        Real.floor(#price c))
  end;

val s = Year.toString(
          Ford.built Ford.first)


(* Functors *)

functor Manufacturer(
  structure Y: YEAR
  val name: string
  val first: Y.year
  val usd: int
  ):> MANUFACTURER  where
      type year=Y.year   =
  struct
    type year = Y.year
    type car = {make: string, 
                built: Y.year,
                price: real}
    fun built(c:car) = #built c
    val first ={make = name,
                built= first,
                price= real usd}
    (* assume 4 % inflation 
       per year: *)
    val yr_inflation = 1.04 
    fun evolve(c:car)=
        {make = #make c, 
         built = Y.next(built c),
         price = yr_inflation 
               * #price c}
    fun toString(c)= 
      #make c ^ 
      "  USD "  ^ 
      Int.toString(
        Real.floor(#price c))
  end;

structure Ford=
  Manufacturer(
    structure Y= Year
    val name = "Ford Model A"
    val first= Y.ad 1903
    val usd = 750
  )

structure Honda=
  Manufacturer(
    structure Y= Year
    val name = "Honda S500"
    val first = Y.ad 1963
    val usd = 1275
  )

(* sharing *)

functor InflationTable(
  structure Y: YEAR
  structure M: MANUFACTURER
  sharing type Y.year = M.year):
   sig
     val print: unit -> unit
   end= 
struct
  fun line(y,c) =
    if y= Y.ad 2020 then ()     
    else
      (TextIO.output(
         TextIO.stdOut, 
         Y.toString y
         ^ "\t" ^ M.toString c
         ^ "\n");
       line(Y.next y, 
            M.evolve c )
      )
  val y0 = M.built M.first
  fun print() = line(y0,M.first)
end;

structure P1 = InflationTable(
  structure Y = Year
  structure M = Ford);

structure P2 = InflationTable(
  structure Y = Year
  structure M = Honda);

val _ = P1.print();
val _ = P2.print();
