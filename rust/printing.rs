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
}
