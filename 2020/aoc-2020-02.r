# aoc-2020-02.1

dat = read.delim("aoc-2020-02.txt", sep=" ", header=FALSE)
vec_min = as.numeric(matrix(unlist(strsplit(as.character(dat$V1), "-")), ncol=2, byrow=TRUE)[,1])
vec_max = as.numeric(matrix(unlist(strsplit(as.character(dat$V1), "-")), ncol=2, byrow=TRUE)[,2])
vec_chr = unlist(strsplit(as.character(dat$V2), ":"))

vec_cnt = c()
for (i in 1:nrow(dat)){
    passwd = as.character(dat$V3)[i]
    key_char = vec_chr[i]
    vec_cnt = c(vec_cnt, lengths(regmatches(passwd, gregexpr(key_char, passwd))))
}

sum((vec_cnt >= vec_min) & (vec_cnt <=vec_max))


# aoc-2020-02.2
dat = read.delim("aoc-2020-02.txt", sep=" ", header=FALSE)
vec_min = as.numeric(matrix(unlist(strsplit(as.character(dat$V1), "-")), ncol=2, byrow=TRUE)[,1])
vec_max = as.numeric(matrix(unlist(strsplit(as.character(dat$V1), "-")), ncol=2, byrow=TRUE)[,2])
vec_chr = unlist(strsplit(as.character(dat$V2), ":"))

vec_bool_pos1 = c()
vec_bool_pos2 = c()
for (i in 1:nrow(dat)){
    passwd = unlist(strsplit(as.character(dat$V3)[i], ""))
    key_char = vec_chr[i]
    pos1 = vec_min[i]
    pos2 = vec_max[i]
    vec_bool_pos1 = c(vec_bool_pos1, passwd[pos1] == key_char)
    vec_bool_pos2 = c(vec_bool_pos2, passwd[pos2] == key_char)
}

sum(xor(vec_bool_pos1, vec_bool_pos2))