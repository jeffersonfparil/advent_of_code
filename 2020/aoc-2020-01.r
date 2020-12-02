# aoc-2020-01.1
x = read.csv("aoc-2020-01.1.txt", header=FALSE)$V1
for (i in 1:(length(x)-1)){
    a = x[i]
    for (j in i:length(x)){
        b = x[j]
        c = a + b
        if (c == 2020){
            print(paste0("a = ", a))
            print(paste0("b = ", b))
            print(paste0("a*b = ", a*b))
        }
    }
}

# aoc-2020-01.2
x = read.csv("aoc-2020-01.1.txt", header=FALSE)$V1
for (i in 1:(length(x)-1)){
    a = x[i]
    for (j in i:length(x)){
        b = x[j]
        for (k in j:length(x)){
            c = x[k]
            d = a + b + c
            if (d == 2020){
                print(paste0("a = ", a))
                print(paste0("b = ", b))
                print(paste0("c = ", c))
                print(paste0("a*b*c = ", a*b*c))
            }
        }
    }
}
