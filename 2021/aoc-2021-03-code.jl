using DelimitedFiles

fname = "aoc-2021-03-input.txt"
dat = DelimitedFiles.readdlm(fname, '\t', AbstractString, header=false)
X = parse.(Int, hcat(split.(dat, "")[:,1]...))'

gamma = parse(Int64, string.(digits.(sum(X, dims=1) .> (size(X)[1]/2))...)[1], base=2)
epsilon = parse(Int64, string.(digits.(sum(X, dims=1) .<= (size(X)[1]/2))...)[1], base=2)



println("#####################################")
println("Part 1:")
println(gamma * epsilon)
println("#####################################")
