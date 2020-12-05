# aoc-2020-03

dat = read.csv("aoc-2020-03.txt", header=FALSE)
X_raw = matrix(unlist(strsplit(as.character(dat$V1), "")), nrow=nrow(dat), byrow=TRUE)
n = nrow(X_raw)
m = ncol(X_raw)


funct_count_trees = function(X_raw, nmoves_right, nmoves_down){
    # nmoves_right = 3
    # nmoves_down = 1

    X = X_raw
    for (i in 1:ceiling(nmoves_right*n/m)){
        X = cbind(X, X_raw)
    }

    movement_col = seq(from=nmoves_right+1, to=ncol(X), by=nmoves_right)
    movement_row = seq(from=nmoves_down+1, to=nrow(X), by=nmoves_down)

    iter_len = c(length(movement_col), length(movement_row))[min(c(length(movement_col), length(movement_row)))==c(length(movement_col), length(movement_row))]

    out = c()
    for (i in 1:iter_len){
        out = c(out, X[movement_row[i], movement_col[i]])
    }

    OUT = sum(out == "#")
    return(OUT)
}

funct_count_trees(X_raw, nmoves_right=3, nmoves_down=1)

R1D1 = funct_count_trees(X_raw, nmoves_right=1, nmoves_down=1)
R3D1 = funct_count_trees(X_raw, nmoves_right=3, nmoves_down=1)
R5D1 = funct_count_trees(X_raw, nmoves_right=5, nmoves_down=1)
R7D1 = funct_count_trees(X_raw, nmoves_right=7, nmoves_down=1)
R1D2 = funct_count_trees(X_raw, nmoves_right=1, nmoves_down=2)

as.numeric(R1D1) * as.numeric(R3D1) * as.numeric(R5D1) * as.numeric(R7D1) * as.numeric(R1D2)

