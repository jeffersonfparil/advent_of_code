use std::fs::File;
use std::io::{self, prelude::*, BufReader};

pub fn day02() -> io::Result<()> {
    let file = File::open("res/day02_input.txt")?;
    let reader = BufReader::new(file);

    let mut total_score: i32 = 0;
    for line in reader.lines() {
        let x = line?;
        let y = x.split(" ");
        let z: Vec<&str> = y.collect();
        let mut theirs: i32 = 1;
        let mut yours: i32 = 1;
        if z[0] == "B" {
            theirs += 1
        } else if z[0] == "C" {
            theirs += 2
        }
        // if z[1] == "Y" {
        //     yours += 1
        // } else if z[1] == "Z" {
        //     yours += 2
        // }
        // let diff: i32 = if theirs <= yours {
        //     theirs - yours
        // } else {
        //     theirs - (yours + 3)
        // };
        // if diff == -1 {
        //     total_score += 6
        // } else if diff == 0 {
        //     total_score += 3
        // }


        if z[1] == "X" {
            yours = theirs + 2
        } else if z[1] == "Y" {
            total_score += 3;
            yours = theirs
        } else {
            total_score += 6;
            yours = theirs + 1
        }

        if yours > 3 {
            yours = yours - 3
        }
        total_score += yours;
        // println!("==================");
        // println!("{}", z[0]);
        // println!("{}", theirs);
        // println!(".............");
        // println!("{}", z[1]);
        // println!("{}", yours);
        // println!("!!!!!!!!!!!!!!!!!!");
        // println!("{}", total_score);
    }
    println!("{}", total_score);
    println!("##############################");


    Ok(())
}
