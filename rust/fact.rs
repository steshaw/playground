//
// Examples from https://en.wikipedia.org/wiki/Rust_(programming_language)
//

fn factorial_recursive(i: u64) -> u64 {
    match i {
        0 => 1,
        n => n * factorial_recursive(n-1)
    }
}

fn factorial_iterative(i: u64) -> u64 {
    let mut acc = 1;
    for num in 2..=i {
        acc *= num;
    }
    acc
}

fn factorial_iterators(i: u64) -> u64 {
    (1..=i).product()
}

fn main() {
  println!("factorial_recursive(5) => {}", factorial_recursive(5));
  println!("factorial_iterative(5) => {}", factorial_iterative(5));
  println!("factorial_iterators(5) => {}", factorial_iterators(5))
}
