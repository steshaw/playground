use std::fmt;

#[derive(Debug)]
struct Person {
    name: String,
    age: i8,
}

impl fmt::Display for Person {
    fn fmt(&self, f: &mut fmt::Formatter) -> fmt::Result {
        write!(f, "{} aged {}", self.name, self.age)
    }
}

fn main() {
    let p = Person {
        name: "Fred".to_string(),
        age: 35,
    };

    println!("normal print p = {}", p);
    println!(" debug print p = {:?}", p);
    println!("pretty print p = {:#?}", p);
    println!("");
    let i42 = 42;
    println!("                print  i42 = {:#?}", i42);
    println!("lowercase hex x print  i42 = {:x}", i42);
    println!("uppercase hex X print  i42 = {:X}", i42);
    println!("        octal o print  i42 = {:o}", i42);
    println!("       binary o print  i42 = {:b}", i42);
    println!("      pointer p print &i42 = {:p}", &i42);
    let pi = 3.145;
    println!("                     print pi = {}", pi);
    println!("               colon print pi = {:}", pi);
    println!("              pretty print pi = {:#?}", pi);
    println!("   LowerExp[onent] e print pi = {:e}", pi);
    println!("   UpperExp[onent] E print pi = {:E}", pi);

    println!("");
    /// Some examples from _Rust By Example_.

    // You can right-align text with a specified width. This will output
    // "     1". 5 white spaces and a "1".
    println!("{number:>width$}", number=1, width=6);

    // You can pad numbers with extra zeroes. This will output "000001".
    println!("{number:>0width$}", number=1, width=6);

    // Create a structure which contains an `i32`. Name it `Structure`.
    #[derive(Debug)]
    struct Structure(i32);

    // However, custom types such as this structure require more complicated
    // handling.
    println!("This struct now prints: {:?}!", Structure(3));
}
