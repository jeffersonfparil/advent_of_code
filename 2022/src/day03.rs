use std::fs::File;
use std::io::{self, prelude::*, BufReader};

fn parse(x: String) -> io::Result<Vec<u8>> {
    // let y = x.chars().collect::<Vec<_>>();
    let z = x.as_bytes().to_vec();
    let mut all: Vec<u8> = vec![];
    for i in z.iter() {
        let a: u8;
        if i > &90 {
            a = i - 96;
        } else {
            a = i - 38;
        }
        // println!("--------------------");
        // println!("{}", a);
        all.push(a);
    }
    Ok(all)
}

pub fn day03() -> io::Result<()> {
    let file = File::open("res/day03_input.txt")?;
    let reader = BufReader::new(file);

    let mut sum_priorities: i32 = 0;
    let mut triplet_count: i32 = 0;
    let mut all: Vec<u8> = vec![];
    let mut all_2: Vec<u8> = vec![];
    let mut all_3: Vec<u8> = vec![];
    for line in reader.lines() {
        let x = line?;
        if triplet_count == 0 {
            all = parse(x)?;
            triplet_count += 1;
        } else if triplet_count == 1 {
            all_2 = parse(x)?;
            triplet_count += 1;
        } else if triplet_count == 2 {
            all_3 = parse(x)?;
            triplet_count = 0;
            let n = all.len();
            let n_2 = all_2.len();
            let n_3 = all_3.len();
            'loop_outer: for i in 0..n {
                for j in 0..n_2 {
                    for k in 0..n_3 {
                        if (all[i] == all_2[j]) & (all[i] == all_3[k]) {
                            let a = all[i] as i32;
                            sum_priorities += a;
                            break 'loop_outer;
                        }
                    }
                }
            }
        }
        
        // let all = parse(x)?;
        // let l = all.len();
        // let n = l/2;
        // 'loop_outer: for i in 0..n {
        //     let bag1 = all[i] as i32;            
        //     for j in n..l {
        //         let bag2 = all[j] as i32;
        //         if bag1 == bag2 {
        //             sum_priorities += bag1;
        //             break 'loop_outer;
        //         }
        //     }
        // }
        // println!("==================");
        // println!("{}", sum_priorities);
        // println!("{}", l);
        // println!("{}", n);
        // println!("{}", x);
        // println!("{}--{}", y[0], all[0]);
        // println!("{}--{}", y[1], all[1]);
        // println!("{}--{}", y[2], all[2]);
    }
    println!("{}", sum_priorities);
    // println!("{}", sum_priorities);
    Ok(())
}
