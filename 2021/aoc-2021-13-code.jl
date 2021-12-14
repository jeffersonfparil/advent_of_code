using UnicodePlots

fun_parse = function(vec_input)
    ### dot coordinates
    vec_x = []
    vec_y = []
    i = 1
    while vec_input[i] != ""
        line = vec_input[i]
        vec_coordinates = parse.(Int, split(line, ","))
        append!(vec_x, vec_coordinates[1])
        append!(vec_y, vec_coordinates[2])
        i += 1
    end
    ### convert from 0-index into 1-index
    vec_x = vec_x .+ 1
    vec_y = vec_y .+ 1
    ### folds
    vec_folds = []
    for j in (i+1):length(vec_input)
        # j = i + 1
        line = vec_input[j]
        push!(vec_folds, string(split(line, " ")[end]))
    end
    return(hcat(vec_x, vec_y), vec_folds)
end

fun_fold_once_or_fold_and_read_message = function(fname; part1=true)
    vec_input = readlines(fname)
    # vec_input = ["6,10","0,14","9,10","0,3","10,4","4,11","6,0","6,12","4,1","0,13","10,12","3,4","3,0","8,4","1,10","2,14","8,10","9,0","","fold along y=7","fold along x=5"]
    # part1 = false
    mat_coordinates, vec_folds = fun_parse(vec_input)
    if part1
        vec_folds = [vec_folds[1]]
    end
    for str_fold in vec_folds
        # str_fold = vec_folds[1]
        vec_str_fold = split(str_fold, "=")
        str_axis_fold = vec_str_fold[1]
        int_coordinate_fold = parse(Int, vec_str_fold[end]) + 1 ### Convert from 0-index into 1-index
        if str_axis_fold == "y"
            vec_bool_coordinates_below_fold_line = mat_coordinates[:, 2] .> int_coordinate_fold
            mat_coordinates[vec_bool_coordinates_below_fold_line, 2] = int_coordinate_fold .- (mat_coordinates[vec_bool_coordinates_below_fold_line, 2] .- int_coordinate_fold)
        else
            vec_bool_coordinates_below_fold_line = mat_coordinates[:, 1] .> int_coordinate_fold
            mat_coordinates[vec_bool_coordinates_below_fold_line, 1] = int_coordinate_fold .- (mat_coordinates[vec_bool_coordinates_below_fold_line, 1] .- int_coordinate_fold)
        end
    end
    if part1
        println("#####################################")
        println("Part 1:")
        vec_str_folded = [string(mat_coordinates[i, 1], "-", mat_coordinates[i, 2]) for i in 1:size(mat_coordinates,1)]
        println(length(unique(vec_str_folded)))
        println("#####################################")
    else
        println("#####################################")
        println("Part 2:")
        println(UnicodePlots.scatterplot(mat_coordinates[:,1], .-mat_coordinates[:,2], width=100, canvas=HeatmapCanvas))
        println("#####################################")
    end
end
        
fname = "aoc-2021-13-input.txt"
@time fun_fold_once_or_fold_and_read_message(fname)
@time fun_fold_once_or_fold_and_read_message(fname)
@time fun_fold_once_or_fold_and_read_message(fname, part1=false)
@time fun_fold_once_or_fold_and_read_message(fname, part1=false)
