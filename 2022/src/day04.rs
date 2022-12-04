use std::fs::File;
use std::io::{self, prelude::*, BufReader};
use std::str::FromStr;

fn parse(x: &str) -> Vec<i32> {
    x.split("-")
     .collect::<Vec<&str>>()
     .into_iter()
     .map(|a| a.parse::<i32>().unwrap())
     .collect()
}

// We're assuming ordered (lowest to highest) consecuting numbers
fn proper_subset(p1: &Vec<i32>, p2: &Vec<i32>) -> io::Result<bool> {
    let out: bool = (
                        (p1[0] <= p2[0]) & 
                        (p1[1] >= p2[1])
                    ) | 
                    (
                        (p1[0] >= p2[0]) & 
                        (p1[1] <= p2[1])
                    );
    Ok(out)
}

fn some_overlap(p1: &Vec<i32>, p2: &Vec<i32>) -> io::Result<bool> {
    let d_1t_2h = p1[1] - p2[0];
    let d_2t_1h = p2[1] - p1[0];
    let out: bool = (
                        (p1[0] <= p2[0]) & 
                        (d_1t_2h >= 0)
                    ) | 
                    (
                        (p1[0] >= p2[0]) & 
                        (d_2t_1h >= 0)
                    );
    Ok(out)
}

pub fn day04() -> io::Result<i32> {
    let file: File = File::open("res/day04_input.txt")?;
    let reader: BufReader<File> = BufReader::new(file);
    let mut overlap_counter: i32 = 0;
    let mut some_overlap_counter: i32 = 0;
    for line in reader.lines() {
        let x: String = line?;
        let y: Vec<&str> = x.split(",").collect();
        let (p1, p2) = (parse(y[0]), parse(y[1]));
        if proper_subset(&p1, &p2)? {
            overlap_counter += 1;
        }
        if some_overlap(&p1, &p2)? {
            some_overlap_counter += 1;
        }
        // println!("=====================");
        // println!("{}", x);
        // println!("{}", y[0]);
        // println!("{}", y[1]);
        // println!("{}-{}", p1[0], p1[1]);
        // println!("{}-{}", p2[0], p2[1]);
        // println!("{}", overlap_counter);
    }
    println!("{}", overlap_counter);
    println!("{}", some_overlap_counter);
    Ok(0)
}