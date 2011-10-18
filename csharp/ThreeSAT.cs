//
// http://blogs.msdn.com/b/ericlippert/archive/2007/03/28/lambda-expressions-vs-anonymous-methods-part-five.aspx
//
// Is this representing the 3SAT NP-complete problem?
//
class MainClass
{
    class T{}
    class F{}
    delegate void DT(T t);
    delegate void DF(F f);
    static void M(DT dt)
    {
        System.Console.WriteLine("true");
        dt(new T());
    }
    static void M(DF df)
    {
        System.Console.WriteLine("false");
        df(new F());
    }
    static T Or(T a1, T a2, T a3){return new T();}
    static T Or(T a1, T a2, F a3){return new T();}
    static T Or(T a1, F a2, T a3){return new T();}
    static T Or(T a1, F a2, F a3){return new T();}
    static T Or(F a1, T a2, T a3){return new T();}
    static T Or(F a1, T a2, F a3){return new T();}
    static T Or(F a1, F a2, T a3){return new T();}
    static F Or(F a1, F a2, F a3){return new F();}
    static T And(T a1, T a2){return new T();}
    static F And(T a1, F a2){return new F();}
    static F And(F a1, T a2){return new F();}
    static F And(F a1, F a2){return new F();}
    static F Not(T a){return new F();}
    static T Not(F a){return new T();}
    static void MustBeT(T t){}
    static void Main()
    {
        // Introduce enough variables and then encode any Boolean predicate:
        // eg, here we encode (!x3) & ((!x1) & ((x1 | x2 | x1) & (x2 | x3 | x2)))
        M(x1=>M(x2=>M(x3=>MustBeT(
          And(
            Not(x3), 
            And(
              Not(x1), 
              And(
                Or(x1, x2, x1), 
                Or(x2, x3, x2))))))));
    }
}
