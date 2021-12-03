using DelimitedFiles

find_power_consumption = function(fname)
    # fname = "aoc-2021-03-input.txt"
    dat = DelimitedFiles.readdlm(fname, '\t', AbstractString, header=false)
    X = parse.(Int, hcat(split.(dat, "")[:,1]...))'
    vec_gamma = vcat(digits.(sum(X, dims=1) .> (size(X)[1]/2))...)
    vec_epsilon = abs.(vec_gamma .- 1)
    gamma = parse(Int64, string(vec_gamma...), base=2)
    epsilon = parse(Int64, string(vec_epsilon...), base=2)
    println("#####################################")
    println("Part 1:")
    println(gamma * epsilon)
    println("#####################################")
end


find_the_row = function(X; CO2=false)
    n_rows, n_cols = size(X)
    idx_col = 1
    while (n_rows != 1) & (idx_col <= n_cols)
        filter = Int(sum(X[:, idx_col]) >= Int(ceil(size(X,1)/2)));
        if CO2
            filter = abs(filter -1)
        end
        vec_idx_filter = X[:, idx_col] .== filter;
        X = X[vec_idx_filter, :]
        idx_col = idx_col + 1;
        n_rows, n_cols = size(X);
    end
    # println(idx_col)
    # println(X)
    out = parse(Int64, string(X...), base=2)
    return(out)
end

find_life_support_rating = function(fname)
    # fname = "aoc-2021-03-input.txt"
    dat = DelimitedFiles.readdlm(fname, '\t', AbstractString, header=false)
    X = parse.(Int, hcat(split.(dat, "")[:,1]...))'
    reading_oxygen = find_the_row(X, CO2=false)
    reading_CO2 = find_the_row(X, CO2=true)
    println("#####################################")
    println("Part 2:")
    println(reading_oxygen * reading_CO2)
    println("#####################################")
end


fname = "aoc-2021-03-input.txt"
@time find_power_consumption(fname)
@time find_power_consumption(fname)

@time find_life_support_rating(fname)
@time find_life_support_rating(fname)
