using CSV
using DataFrames


### PART 1:
count_increase = function(fname)
    dat = CSV.read(fname, DataFrame, header=false)
    vec_x1 = dat.Column1[1:(end-1)]
    vec_x2 = dat.Column1[2:(end-0)]
    println("##################################")
    println("Part 1:")
    println(sum(vec_x2 - vec_x1 .> 0))
    println("##################################")
end

fname = "aoc-01-input.txt"
@time count_increase(fname)
@time count_increase(fname)

### PART 2:
count_triple_increase = function(fname)
    dat = CSV.read(fname, DataFrame, header=false)
    vec_y1 = dat.Column1[1:(end-2)]
    vec_y2 = dat.Column1[2:(end-1)]
    vec_y3 = dat.Column1[3:(end-0)]
    vec_y4 = vec_y1 + vec_y2 + vec_y3
    vec_y5 = vec_y4[1:(end-1)]
    vec_y6 = vec_y4[2:(end-0)]
    println("##################################")
    println("Part 2:")
    println(sum(vec_y6 - vec_y5 .> 0))
    println("##################################")
end

fname = "aoc-01-input.txt"
@time count_triple_increase(fname)
@time count_triple_increase(fname)


### **Execute:**
### time julia aoc-01-code.jl