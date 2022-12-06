use std::fs::File;
use std::io::{self, prelude::*, BufReader};

fn unique<'o>(x: &'o Vec<&'o str>) -> io::Result<Vec<&'o str>> {
    let n = x.len();
    let mut vec_unique: Vec<&str> = vec![];
    for i in 0..n {
        let a = x[i];
        let mut is_unique: bool = true;
        'loop_inner: for j in (i+1)..n {
            let b = x[j];
            if a == b {
                is_unique = false;
                break 'loop_inner;
            }
        }
        if is_unique {
            vec_unique.push(a);
        }
    }
    Ok(vec_unique)
}

fn find_number_of_crate_stacks(fname: &str) -> io::Result<i32> {
    let file = File::open(fname)?;
    let reader = BufReader::new(file);
    let mut header_lines: Vec<String> = vec![];
    let out: i32;
    for line in reader.lines() {
        let x = line?;
        // println!("{}", x);
        if x == "" {
            break;
        } else {
            header_lines.push(x);
        }
    }
    let X = header_lines[header_lines.len()-1].split(" ").collect::<Vec<&str>>();
    let Y = unique(&X)?;
    out = Y[Y.len()-2].parse::<i32>().unwrap();
    // println!("{}", out);
    Ok(out)
}

fn extract_crate_stacks(fname: &str, n: i32) -> io::Result<Vec<Vec<String>>> {
    let file = File::open(fname)?;
    let reader = BufReader::new(file);
    let mut array: Vec<Vec<String>> = vec![vec![]];
    let mut out: Vec<Vec<String>> = vec![vec![]];
    for i in 1..n {
        array.push(vec![]);
        out.push(vec![]);
    }
    for line in reader.lines() {
        let x = line?;
        let y: Vec<&str> = x.split(" ").collect::<Vec<&str>>();
        // println!("{:?}", y);
        for i in 0..n {
            array[i as usize].push(y[i as usize].to_string().clone());
        }
        if y[0] == "" {
            break;
        }
    }
    // println!("{:?}", array);
    // Remove last element
    for i in 0..n {
        let m = array[i as usize].len() - 1 as usize;
        // println!("{}", m);
        array[i as usize].remove(m);
    }
    // println!("====================================");
    // println!("{:?}", array);
    // Remove empty strings
    for i in 0..n {
        let mut j: i32 = 0;
        for s in array[i as usize].iter() {
            // println!("{:?}", s);
            if s != "" {
                out[i as usize].push(s.clone());
            } else {
                j += 1;
            }
        }
    }
    // println!("************************");
    // println!("{:?}", out);
    Ok(out)
}

fn extract_instructions(fname: &str) -> io::Result<(Vec<i32>, Vec<i32>, Vec<i32>)> {
    let file: File = File::open(fname)?;
    let reader: BufReader<File> = BufReader::new(file);
    let mut count: Vec<i32> = vec![];
    let mut source: Vec<i32> = vec![];
    let mut destination: Vec<i32> = vec![];
    for line in reader.lines(){
        let x: String = line?;
        let y: Vec<&str> = x.split(" ").collect::<Vec<&str>>();
        if y[0] == "move" {
            count.push(y[1].parse::<i32>().unwrap());
            source.push(y[3].parse::<i32>().unwrap());
            destination.push(y[5].parse::<i32>().unwrap());
            // println!("{}", x);
        }
    }
    Ok((count, source, destination))
}

fn operate(c: usize, s: usize, d: usize, stacks: &Vec<Vec<String>>) -> io::Result<Vec<Vec<String>>> {
    let n: usize = stacks.len();
    let mut out: Vec<Vec<String>> = vec![vec![]];
    for i in 1..n {
        out.push(vec![]);
    }
    let mut crates_lifted: Vec<String> = vec![];
    for i in 0..c {
        crates_lifted.push("".to_string());
    }
    let m = stacks[s].len();
    let mut crates_left: Vec<String> = vec![];
    for i in c..m {
        crates_left.push("".to_string());
    }
    let o = stacks[d].len();
    let mut crates_base: Vec<String> = vec![];
    for i in 0..o {
        crates_base.push("".to_string());
    }
    crates_lifted.clone_from_slice(&stacks[s][0..c]);
    crates_left.clone_from_slice(&stacks[s][c..m]);
    crates_base.clone_from_slice(&stacks[d]);

    let mut crates_destination: Vec<String> = vec![];
    for i in 0..c {
        // crates_destination.push(crates_base[i].clone());
        crates_destination.push(stacks[s][i].clone());
    }
    for i in 0..o {
        // crates_destination.push(crates_base[i].clone());
        crates_destination.push(stacks[d][i].clone());
    }

    println!("{:?}", stacks[s]);
    println!("{:?}", stacks[d]);
    println!("{:?}", crates_lifted);
    println!("{:?}", crates_left);
    println!("{:?}", crates_base);
    println!("{:?}", crates_destination);

    
    Ok(vec![vec!["".to_string()]])
}

pub fn day05() -> io::Result<()> {
    // let x = vec![" ", "dsf", " ", "a", "a", "sf", "abc"];
    // let out = unique(&x)?;
    // println!("{:?}", out);
    let fname: &str = "res/day05_input.txt";
    let n: i32 = find_number_of_crate_stacks(fname)?;
    let stacks: Vec<Vec<String>> = extract_crate_stacks(fname, n)?;
    let (count, source, destination) = extract_instructions(fname)?;

    println!("{:?}", stacks);
    println!("{:?}", n);
    println!("{:?}", count);
    println!("======================");
    println!("{:?}", source);
    println!("======================");
    println!("{:?}", destination);

    println!("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
    operate(3 as usize, 0 as usize, 4 as usize, &stacks);


    Ok(())
}

