fn main() {
    println!("{}", Some("unwraps successfully").unwrap());
    None.unwrap() // panics
}
