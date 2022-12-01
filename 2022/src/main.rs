use std::fs::File;
use std::io::{self, prelude::*, BufReader};

fn main() -> io::Result<()> {
    let file = File::open("res/day01_input.txt")?;
    let reader = BufReader::new(file);

    let mut max_calories: i32 = 0;
    let mut triplet_calories = Vec::new();
    triplet_calories.push(0);
    triplet_calories.push(0);
    triplet_calories.push(0);
    let mut calorie_counter: i32 = 0;
    for line in reader.lines() {
        let x = line?;
        println!("{}", x);
        if x != "" {
            let my_string = x.to_string();  // `parse()` works with `&str` and `String`!
            let my_int = my_string.parse::<i32>().unwrap();
            calorie_counter = calorie_counter + my_int;
        } else {
            if calorie_counter > max_calories {
                max_calories = calorie_counter;
                triplet_calories[2] = triplet_calories[1];
                triplet_calories[1] = triplet_calories[0];
                triplet_calories[0] = max_calories
            }
            calorie_counter = 0;
        }
    }
    println!("{}", max_calories);
    println!("{}", triplet_calories[0]);
    println!("{}", triplet_calories[1]);
    println!("{}", triplet_calories[2]);
    let mut sum: i32 = 0;
    for i in triplet_calories.iter() {
        sum += i;
    }
    println!("{}", sum);

    Ok(())
}
