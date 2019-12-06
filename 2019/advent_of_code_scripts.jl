"""
# Advent of code 2019
- jeffParil github

"""

##########################################################################################
##############
### DAY 01 ###
##############
using DelimitedFiles
function calc_fuel(input)
    input_day01 = DelimitedFiles.readdlm(input, '\t')
    ### part 1
    x = input_day01[:, 1]
    solution_d1p1 = sum(floor.(x ./ 3) .- 2)
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
    solution_d1p2 = sum(recursive_fuel_calculation.(x))
    return(solution_d1p1, solution_d1p2)
end
input = "advent_of_code_day_01.txt"
@time solution_d1p1, solution_d1p2 = calc_fuel(input)
##########################################################################################

##########################################################################################
##############
### DAY 02 ###
##############
### part 1
using DelimitedFiles
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
raw_x = convert(Array{Int64, 1}, DelimitedFiles.readdlm("advent_of_code_day_02.csv", ',')[1,:])
solution_d2p1 = Intcode_computer([12, 2], raw_x)[1]
### part 2
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
solution_d2p2 = 100 * params[1] + params[2]
##########################################################################################

##########################################################################################
##############
### DAY 03 ###
##############
### part 1
using DelimitedFiles
input = DelimitedFiles.readdlm("advent_of_code_day_03.csv", ',')
a_raw = convert(Array{String,1}, input[1,:])
b_raw = convert(Array{String,1}, input[2,:])

# a_raw = ["R8", "U5", "L5", "D3"]
# b_raw = ["U7", "R6", "D4", "L4"]
# # #
# a_raw = ["R75","D30","R83","U83","L12","D49","R71","U7","L72"]
# b_raw = ["U62","R66","U55","R34","D71","R55","D58","R83"]
# # #
# a_raw = ["R98","U47","R26","D63","R33","U87","L62","D20","R33","U53","R51"]
# b_raw = ["U98","R91","D20","R16","D67","R40","U7","R15","U6","R7"]
# # #
# a_raw = ["R4", "U2", "L2", "D1", "R4", "D2", "L4"]
# b_raw = ["D3", "R7", "U3", "L2", "D2"]

function func_parse(coor_raw::String)::Array{Int64,1}
    out = [0, 0]
    coor_split = convert(Array{String}, split(coor_raw, ""))
    direction = coor_split[1]
    magnitude = parse(Int64, join(coor_split[2:end]))
    if direction == "R"
        out = [magnitude, 0]
    elseif direction == "L"
        out = [-magnitude, 0]
    elseif direction == "U"
        out = [0, magnitude]
    elseif direction == "D"
        out = [0, -magnitude]
    end
    return(out)
end
A_coor = reshape(reduce(vcat, func_parse.(a_raw)), 2, length(a_raw))'
B_coor = reshape(reduce(vcat, func_parse.(b_raw)), 2, length(b_raw))'

A_cumdist = cumsum(A_coor, dims=1)
B_cumdist = cumsum(B_coor, dims=1)
C_cumdist = vcat(A_cumdist, B_cumdist)

ncols, nrows = maximum(C_cumdist, dims=1) .- minimum(C_cumdist, dims=1) .+ 1
origin = [nrows + minimum([0, minimum(C_cumdist[:,2])]),
          ncols - minimum([ncols-1, maximum(C_cumdist[:,1])])]

function func_matrixize(X_cumdist, origin, nrows, ncols; stop_x=ncols+1, stop_y=nrows+1)
    X = convert(Array{Int64, 2}, zeros(nrows, ncols))
    for i in 1:size(X_cumdist, 1)
        # i = 1
        # println(i)
        coordinate = X_cumdist[i,:]
        if i == 1
            x = convert(Array{Int64,1}, collect(range(0,coordinate[1], length=abs(0-coordinate[1])+1))) .+ origin[2]
            y = .-convert(Array{Int64,1}, collect(range(0,coordinate[2], length=abs(0-coordinate[2])+1))) .+ origin[1]
        elseif coordinate[2] == X_cumdist[i-1, 2]
            prev_coordinate = X_cumdist[i-1,:]
            x = convert(Array{Int64,1}, collect(range(prev_coordinate[1], coordinate[1], length=abs(prev_coordinate[1]-coordinate[1])+1))) .+ origin[2]
            y = -coordinate[2] + origin[1]
        else
            prev_coordinate = X_cumdist[i-1,:]
            x = coordinate[1] + origin[2]
            y = .-convert(Array{Int64,1}, collect(range(prev_coordinate[2], coordinate[2], length=abs(prev_coordinate[2]-coordinate[2])+1))) .+ origin[1]
        end
        stop_bool_x = x .== [stop_x]
        stop_bool_y = y .== [stop_y]
        if (sum(stop_bool_x)>0) & (sum(stop_bool_y)>0)
            # println("BREAK!")
            x = try
                    x[1:collect(1:length(stop_bool_x))[stop_bool_x][1]]
                catch
                    [x][1:collect(1:length(stop_bool_x))[stop_bool_x][1]]
                end
            y = try
                    y[1:collect(1:length(stop_bool_y))[stop_bool_y][1]]
                catch
                    [y][1:collect(1:length(stop_bool_y))[stop_bool_y][1]]
                end
            # X[y, x] .= 1
            if length(x) > 1
                X[y, x] = X[y[1], x] + vcat([0], ones(Int64, length(x)-1)) # exclude origin and corners: 0 in front
            else
                X[y, x] = X[y, x[1]] + vcat([0], ones(Int64, length(y)-1)) # exclude origin and corners: 0 in front
            end
            ### when the intersection is met break!
            break
        end
        # X[y, x] .= 1
        if length(x) > 1
            X[y, x] = X[y[1], x] + vcat([0], ones(Int64, length(x)-1))
        else
            X[y, x] = X[y, x[1]] + vcat([0], ones(Int64, length(y)-1))
        end
    end
    return(X)
end
A = (func_matrixize(A_cumdist, origin, nrows, ncols) .!= 0) .* 1
B = (func_matrixize(B_cumdist, origin, nrows, ncols) .!= 0) .* 1
C = A .+ B

intersections_i = []
intersections_j = []
for i in 1:nrows
    for j in 1:ncols
        if C[i, j] == 2
            push!(intersections_i, i)
            push!(intersections_j, j)
        end
    end
end

ORIGIN = reshape(repeat(origin, outer=length(intersections_i)), 2, length(intersections_i))'
INTERSECTIONS = hcat(intersections_i, intersections_j)
distances = sum(abs.(INTERSECTIONS .- ORIGIN), dims=2)
solution_d3p1 = minimum(distances[distances .!= 0])

### part 2
nsteps = []
for i in 1:size(INTERSECTIONS,1)
    # i = 2
    A = func_matrixize(A_cumdist, origin, nrows, ncols, stop_x=INTERSECTIONS[i,2], stop_y=INTERSECTIONS[i,1])
    B = func_matrixize(B_cumdist, origin, nrows, ncols, stop_x=INTERSECTIONS[i,2], stop_y=INTERSECTIONS[i,1])
    push!(nsteps, sum(A) + sum(B))
end
nsteps_less_origin = nsteps[nsteps .!= 0]
solution_d3p2 = minimum(nsteps_less_origin)
##########################################################################################

##########################################################################################
##############
### DAY 04 ###
##############
### part 1
using ProgressMeter
pb = ProgressMeter.Progress(595730-136760, dt=1, barglyphs=BarGlyphs("[=> ]"), barlen=50, color=:yellow)
passwords = []
for i in 136760:595730
    # i = 136760
    # println(i)
    i_split = parse.(Int64, convert(Array{String,1}, split(string(i), "")))
    i_test1 = i_split[1:(end-1)] .<= i_split[2:end]
    i_test2 = i_split[1:(end-1)] .== i_split[2:end]
    if (sum(i_test1) == length(i_test1)) & (sum(i_test2) > 0)
        push!(passwords, i)
    end
    ProgressMeter.update!(pb, i-136760)
end
solution_d4p1 = length(passwords)

### part2
using StatsBase
pb = ProgressMeter.Progress(length(passwords), dt=1, barglyphs=BarGlyphs("[=> ]"), barlen=50, color=:yellow); counter = [1]
passwords_2 = []
for i in passwords
    # i = passwords[1]
    # println(i)
    i_split = parse.(Int64, convert(Array{String,1}, split(string(i), "")))
    counts_vector = [val for (key, val) in StatsBase.countmap(i_split)]
    if (maximum(counts_vector) == 2) | (sum(counts_vector .== 2) > 0)
        println(i)
        push!(passwords_2, i)
    end
    ProgressMeter.update!(pb, counter[1]); counter[1] =  counter[1] + 1
end
solution_d4p2 = length(passwords_2)
##########################################################################################

##########################################################################################
##############
### DAY 05 ###
##############
### part 1
using DelimitedFiles

function modop_parser(x, idx)
    # idx = 1
    # x = 1002 # x = 3 # x = 4
    x_split = parse.(Int64, split(string(x), ""))
    opcode = try
                (x_split[end-1] * 10) + x_split[end]
            catch
                x_split[1]
            end
    modes_init = x_split[1:end-2]
    if (opcode == 1) | (opcode == 2) | (opcode == 7) | (opcode == 8)
        params_length = 3
    elseif (opcode == 3) | (opcode == 4)
        params_length = 1
    elseif (opcode == 5) | (opcode == 6)
        params_length = 2
    elseif opcode == 99
        params_length = 0
    else
        println("Invalid opcode!")
        params_length = 0
    end
    immediate = reverse(convert(Array{Int64,1}, vcat(zeros(params_length-length(modes_init)), modes_init)))
    positional = (immediate .== 0) .* convert(Array{Int64,1}, ones(params_length))
    idx_out = convert(Array{Int64}, collect(1:params_length)) .+ idx
    out = (opcode, hcat(idx_out, immediate, positional))
    return(out)
end

function opcode_function(idx, opcode, X, program; input=missing)
    nrows = size(X,1)
    params_row_idx = nrows > 1 ? collect(1:nrows-1) : 1
    params_imm = try;         collect(skipmissing(X[params_row_idx, 1]));       catch;         collect(skipmissing(X[[params_row_idx], 1]));        end
    params_pos = try; program[collect(skipmissing(X[params_row_idx, 2])) .+ 1]; catch; program[collect(skipmissing(X[[params_row_idx], 2])) .+ 1];  end
    idx_destin = try; collect(skipmissing(X[nrows, 2]))[1] + 1;                 catch; missing;                                                     end
    val_destin = try; collect(skipmissing(X[nrows, 1]))[1] + 1;                 catch; missing;                                                     end
    idx_out = idx + size(X,1) + 1
    if opcode == 1
        out = sum(vcat(params_imm, params_pos))
    elseif opcode == 2
        out = prod(vcat(params_imm, params_pos))
    elseif opcode == 3
        out = input
    elseif opcode == 4
        out = try; program[idx_destin]; catch; params_imm[1]; end
    elseif opcode == 5
        out = missing
        (vcat(params_imm, params_pos)[1] != 0) ? (ismissing(idx_destin)==false) ? idx_out = program[idx_destin] + 1 : idx_out = val_destin : nothing
    elseif opcode == 6
        out = missing
        (vcat(params_imm, params_pos)[1] == 0) ? (ismissing(idx_destin)==false) ? idx_out = program[idx_destin] + 1 : idx_out = val_destin : nothing
    elseif opcode == 7
        out = missing
        .!ismissing.(X[1, 1]) == true ? val1 = params_imm[1] : val1 = params_pos[1]         ### check if the first element of the positional colulmn is not missing
        .!ismissing.(X[2, 1]) == true ? val2 = params_imm[end] : val2 = params_pos[end]     ### check if the second element of the positional column is not missing
        val1 < val2 ? out = 1 : out = 0
    elseif opcode == 8
        out = missing
        .!ismissing.(X[1, 1]) == true ? val1 = params_imm[1] : val1 = params_pos[1]         ### check if the first element of the positional colulmn is not missing
        .!ismissing.(X[2, 1]) == true ? val2 = params_imm[end] : val2 = params_pos[end]     ### check if the second element of the positional column is not missing
        val1 == val2 ? out = 1 : out = 0
    end
    try; program[idx_destin] = out; catch; nothing; end
    return(program, out, idx_out)
end

function Intcode_compuper2(program::Array{Int64,1}, input::Int64)
    # program = [1002,4,3,4,33]; input = 1 # program = [3,0,4,0,99]; input = 1 # program = [104,0,1101,65,73,225]; input = 1
    # program = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]; input = 0
    # program = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]; input = 1
    idx = 1 # idx=3
    output_vector = []; output_idx = []
    while idx < length(program)
        println(idx)
        opcode, idx_imm_pos = modop_parser(program[idx], idx)
        opcode == 99 ? break : nothing
        values = hcat(program[idx_imm_pos[:,1]], program[idx_imm_pos[:,1]])
        imm_pos = convert(Array{Any,2}, idx_imm_pos[:,2:3]); imm_pos[imm_pos .== 0] .= missing
        X = values .* imm_pos
        program, out, idx_out = opcode_function(idx, opcode, X, program, input=input)
        if (opcode == 1) | (opcode == 2) | (opcode == 3)
            out = missing
        end
        if ismissing(out) == false
            push!(output_vector, out)
            push!(output_idx, idx)
        end
        idx = idx_out
    end
    println("Outputting!")
    OUTPUT = hcat(output_idx, output_vector)
    return(OUTPUT)
end

program = convert(Array{Int64,1}, DelimitedFiles.readdlm("advent_of_code_day_05.csv", ',')[1,:])
input = 1
@time solution_d5p1 = Intcode_compuper2(program, input)

### part 2
program = convert(Array{Int64,1}, DelimitedFiles.readdlm("advent_of_code_day_05.csv", ',')[1,:])
input = 5
@time solution_d5p2 = Intcode_compuper2(program, input)
##########################################################################################

##########################################################################################
##############
### DAY 06 ###
##############
### part 1
using DelimitedFiles
input = convert(Array{String,2}, string.(DelimitedFiles.readdlm("advent_of_code_day_06.psv", ')'))) ### parentheis-separated-values: "*.psv"
# input = permutedims(reshape(["COM","B","B","C","C","D","D","E","E","F","B","G","G","H","D","I","E","J","J","K","K","L"], 2, 11))



### part 2
##########################################################################################
