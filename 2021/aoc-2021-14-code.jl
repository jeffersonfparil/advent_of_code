fun_parse = function(vec_input)
    # vec_input = ["NNCB", "", "CH -> B", "HH -> N", "CB -> H", "NH -> C", "HB -> C", "HC -> B", "HN -> C", "NN -> C", "BH -> H", "NC -> B", "NB -> B", "BN -> B", "BB -> N", "BC -> B", "CC -> N", "CN -> C"]
    str_polymer = vec_input[1]
    vec_pair_and_insert = []
    for line in vec_input[3:end]
        # line = vec_input[3:end][1]
        vec_pair_and_insert = vcat(vec_pair_and_insert, split(line, " -> "))
    end
    mat_pair_and_insert = reshape(vec_pair_and_insert, (2, Int(length(vec_pair_and_insert)/2)))
    return(str_polymer, mat_pair_and_insert)
end

fun_find_insert = function(str_pair, mat_pair_and_insert)
    # str_pair = mat_pair_and_insert[1, 5]
    vec_bool_idx = mat_pair_and_insert[1, :] .== str_pair
    str_insert = mat_pair_and_insert[2, vec_bool_idx]
    return(str_insert)
end

fun_counter = function(str_insert, vec_labels, vec_counts)
    # str_insert = mat_pair_and_insert[2, 5]
    # vec_labels = sort(unique(vcat(vcat(vcat(split.(mat_pair_and_insert[1,:], "")...), vcat(split.(mat_pair_and_insert[2,:], "")...)), split(str_polymer,""))))
    # vec_counts = zeros(Int, length(vec_labels))
    vec_bool_idx = vec_labels .== str_insert
    vec_counts[vec_bool_idx] = vec_counts[vec_bool_idx] .+ 1
    return(vec_counts)
end

fun_grow_polymer_find_inserts_recursive = function(str_polymer, mat_pair_and_insert, n_counter, n_steps, vec_labels, vec_counts)
    if n_counter < n_steps
        n_counter = n_counter + 1
        for i in 1:(length(str_polymer)-1)
            # i = 1
            str_pair = str_polymer[i:(i+1)]
            str_insert = fun_find_insert(str_pair, mat_pair_and_insert)
            vec_counts = fun_counter(str_insert, vec_labels, vec_counts)
            vec_counts = fun_grow_polymer_find_inserts_recursive(
                            str_pair[1] * str_insert[1] * str_pair[2],
                            mat_pair_and_insert,
                            n_counter,
                            n_steps,
                            vec_labels,
                            vec_counts)
            # println(str_polymer)
        end
    else
        n_counter = n_counter - 1
    end
    # println(n_counter)
    return(vec_counts)
end


fname = "aoc-2021-14-input.txt"
vec_input = readlines(fname)
# vec_input = ["NNCB", "", "CH -> B", "HH -> N", "CB -> H", "NH -> C", "HB -> C", "HC -> B", "HN -> C", "NN -> C", "BH -> H", "NC -> B", "NB -> B", "BN -> B", "BB -> N", "BC -> B", "CC -> N", "CN -> C"]
str_polymer, mat_pair_and_insert = fun_parse(vec_input)
n_counter = 0
n_steps = 40
vec_labels = sort(unique(vcat(vcat(vcat(split.(mat_pair_and_insert[1,:], "")...), vcat(split.(mat_pair_and_insert[2,:], "")...)), split(str_polymer,""))))
vec_counts = zeros(Int, length(vec_labels))
for str in split(str_polymer,"")
    vec_counts  = fun_counter(str, vec_labels, vec_counts)
end

@time out = fun_grow_polymer_find_inserts_recursive(str_polymer, mat_pair_and_insert, n_counter, n_steps, vec_labels, vec_counts)
println("#####################################")
println("Part 1:")
println(maximum(out) - minimum(out))
println("#####################################")

