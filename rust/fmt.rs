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
    println!("                print i42 = {:#?}", i42);
    println!("lowercase hex x print i42 = {:x}", i42);
    println!("uppercase hex X print i42 = {:X}", i42);
    println!("        octal o print i42 = {:o}", i42);
    let pi = 3.145;
    println!("                     print pi = {}", pi);
    println!("               colon print pi = {:}", pi);
    println!("              pretty print pi = {:#?}", pi);
    println!("   LowerExp[onent] e print pi = {:e}", pi);
    println!("   UpperExp[onent] E print pi = {:E}", pi);
}
