"""
# Advent of code 2019
- jeffParil github

"""

##########################################################################################
##############
### DAY 01 ###
##############
### part 1
using DelimitedFiles
input_day01 = DelimitedFiles.readdlm("advent_of_code_day_01.txt", '\t')
x = input_day01[:, 1]
solution_01 = sum(floor.(x ./ 3) .- 2)
### part 2
function recursive_fuel_calculation(fuel::Any)::Int64
    total = 0
    remaining = convert(Int64, (floor(fuel / 3)) - 2 )
    while remaining[1] > 0
        total += convert(Int64, remaining)
        remaining = convert(Int64, (floor(remaining / 3)) - 2 )
    end
    return(total)
end
solution_02 = sum(recursive_fuel_calculation.(x))
##########################################################################################

##########################################################################################
##############
### DAY 02 ###
##############
### part 1
using DelimitedFiles
raw_x = convert(Array{Int64, 1}, DelimitedFiles.readdlm("advent_of_code_day_02.csv", ',')[1,:])
function Intcode_computer(param::Array{Int64,1}, raw_x::Array{Int64,1})::Array{Int64, 1}
    raw_x[2] = convert(Int64, param[1])
    raw_x[3] = convert(Int64, param[2])
    len_x = length(raw_x)
    x = convert(Array{Int64}, zeros(convert(Int64, ceil(len_x/4)*4)))
    x[1:len_x] .= copy(raw_x)
    m = 4
    n = convert(Int64, length(x)/4)
    X = reshape(x, m, n)'
    for i in 1:n
        # i = 1
        operator = X[i,1]
        a = X[i,2] + 1
        b = X[i,3] + 1
        c = X[i,4] + 1
        if (operator == 99)
            break
        elseif (operator == 1)
            x[c] = x[a] + x[b]
        elseif (operator == 2)
            x[c] = x[a] * x[b]
        end
    end
    out = x[1:len_x]
    return(out)
end
@time out = Intcode_computer([12, 2], raw_x)[1]
### part 2
# using Optim
# function cost(param::Array{Float64,1}, raw_x::Array{Int64,1})::Float64
#     convert(Float64, abs(19690720 - Intcode_computer(convert(Array{Int64,1}, round.(param)), raw_x)[1]))
# end
# lower_limits = [0.0, 0.0]
# upper_limits = [99.0, 99.0]
# initial_values = [50.0, 50.0]
# Optim.optimize(param->cost(param, raw_x), lower_limits, upper_limits, initial_values)
params = []
for i in 0:99
    for j in 0:99
        out = Intcode_computer([i, j], raw_x)[1]
        if out == 19690720
            println(string("params ", i, " and ", j, " generates ", out, "!"))
            push!(params, i)
            push!(params, j)
            break
        end
    end
end
solution_03 = 100 * params[1] + params[2]
##########################################################################################

##########################################################################################
##############
### DAY 03 ###
##############
### part 1

### part 2
##########################################################################################
