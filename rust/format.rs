fn main() {
    let r = format!("x = {}, y = {y}", 10, y = 30);
    let c = 'a';
    let foo = r + ", " + &format!("c = '{}'", c);
    println!("foo = {}", foo);
}
