use std::fs::File;
// use std::io::{self, prelude::*, BufReader};
use std::io::BufReader;

fn main() -> io::Result<()> {
    let file = File::open("day01_input.txt")?;
    let reader = BufReader::new(file);

    for line in reader.lines() {
        println!("{}", line?);
    }

    Ok(())
}
