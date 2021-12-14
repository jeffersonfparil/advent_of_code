fname = "aoc-2021-14-input.txt"

vec_input = readlines(fname)
vec_input = ["NNCB", "", "CH -> B", "HH -> N", "CB -> H", "NH -> C", "HB -> C", "HC -> B", "HN -> C", "NN -> C", "BH -> H", "NC -> B", "NB -> B", "BN -> B", "BB -> N", "BC -> B", "CC -> N", "CN -> C"]

fun_parse = function(vec_input)
    vec_insert = []
    for line in vec_input[3:end]
        # line = vec_input[3:end][1]
        vec_pair_and_insert = split(line, " -> ")
        append!(vec_insert, vec_pair_and_insert[2])
    end
    return(vec_insert)
end

vec_insert = fun_parse(vec_input)
[count(vec_insert .== x) for x in unique(vec_insert)]

