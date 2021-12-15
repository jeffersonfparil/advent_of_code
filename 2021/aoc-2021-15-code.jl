fname = "aoc-2021-15-input.txt"
vec_input = readlines(fname)
# vec_input = ["1163751742", "1381373672", "2136511328", "3694931569", "7463417111", "1319128137", "1359912421", "3125421639", "1293138521", "2311944581"]
mat_map = parse.(Int, reshape(vcat(split.(vec_input, "")...), (length(vec_input), length(vec_input))))'


sum(mat_map, dims=1)
sum(mat_map, dims=2)


