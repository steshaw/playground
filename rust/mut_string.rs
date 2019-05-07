fn main() {
    let mut hello = String::from("Hello, ");

    hello.push('w');
    hello.push_str("orld!");

    println!("hello = {:?}", hello);
}
