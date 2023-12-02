use std::fs::File;
use std::io::{self, prelude::*, BufReader};

pub fn day01() -> io::Result<()> {

    let file = File::open("res/day01_input.txt").unwrap();
    let reader = BufReader::new(file);
    let mut sum = 0;
    for line in reader.lines() {
        let line = line.unwrap();
        let line = line.split("").filter(|&x| {let y = match x.parse::<i32>(){
            Ok(_) => true,
            Err(_) => false,
        }; y})
        .map(|x| x.parse::<i32>().unwrap())
        .collect::<Vec<i32>>();
    let x0 = line[0];
    let x1 = *line.last().unwrap();
        println!("line={:?}", line);
        println!("x0={:?}; x1={:?}", x0, x1);
    sum += (x0.to_string() + &x1.to_string()).parse::<i32>().unwrap();
    }
    println!("sum={:?}", sum);

    Ok(())
}
