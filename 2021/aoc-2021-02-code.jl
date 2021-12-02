using CSV
using DataFrames

navigation_elves_wrong = function(fname)
    dat = CSV.read(fname, DataFrame, header=false)

    vec_forward = dat.Column2[dat.Column1 .== "forward"]
    pos_horizontal = sum(vec_forward)

    vec_down = dat.Column2[dat.Column1 .== "down"]
    vec_up = dat.Column2[dat.Column1 .== "up"]
    pos_depth = sum(vec_down) - sum(vec_up)

    println("#####################################")
    println("Part 1:")
    println(pos_horizontal * pos_depth)
    println("#####################################")
end

navigation_elves_right = function(fname)
    dat = CSV.read(fname, DataFrame, header=false)

    n = nrow(dat)
    vec_forward = zeros(Int, n)
    vec_up = zeros(Int, n)
    vec_down = zeros(Int, n)
    vec_aim = zeros(Int, n)

    idx_forward = dat.Column1 .== "forward";
    vec_forward[idx_forward] = dat.Column2[idx_forward];

    idx_up = dat.Column1 .== "up";
    vec_up[idx_up] = dat.Column2[idx_up];

    idx_down = dat.Column1 .== "down";
    vec_down[idx_down] = dat.Column2[idx_down];
    
    vec_aim = cumsum(vec_down - vec_up)
    vec_depth = vec_forward .* vec_aim

    println("#####################################")
    println("Part 2:")
    println(sum(vec_forward) * sum(vec_depth))
    println("#####################################")
end

### **Execute:**
fname = "aoc-2021-02-input.txt"
@time navigation_elves_wrong(fname)
@time navigation_elves_wrong(fname)

@time navigation_elves_right(fname)
@time navigation_elves_right(fname)

# ### **In bash:**
# time julia aoc-2021-02-code.jl