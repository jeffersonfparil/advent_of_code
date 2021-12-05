using ProgressMeter

fun_parser = function(idx, vec_stream)
    ##################################
    ### TEST:
    # idx = 3
    # fname = "aoc-2021-05-input.txt"
    # vec_stream = readlines(fname)
    ##################################
    vec_row = split(vec_stream[idx])
    x1, y1 = parse.(Int, split(vec_row[1], ','))
    x2, y2 = parse.(Int, split(vec_row[3], ','))
    return(x1, y1, x2, y2)
end

fun_ranger = function(init, fin)
    ############################
    ### TEST:
    # init, fin = (12, 34)
    ############################
    vec_range = collect(init:fin)
        if (length(vec_range)==0)
            vec_range = reverse(collect(fin:init))
        end
    return(vec_range)
end

fun_counter_number_of_stable_points = function(fname; include_45degree_diagonals=false)
    ###################################################################################
    ### TEST:
    # fname = "aoc-2021-05-input.txt"
    # include_45degree_diagonals = true
    ###################################################################################
    vec_stream = readlines(fname)
    vec_coordinates = nothing
    for idx in 1:length(vec_stream)
        x1, y1, x2, y2 = fun_parser(idx, vec_stream)
        if x1 == x2
            vec_y_range = fun_ranger(y1, y2)
            vec_x_range = repeat([x1], length(vec_y_range))
        elseif y1 == y2
            vec_x_range = fun_ranger(x1, x2)
            vec_y_range = repeat([y1], length(vec_x_range))
        else
            n_slope = abs((y2-y1)/(x2-x1))
            if (include_45degree_diagonals) & (n_slope == 1)
                vec_x_range = fun_ranger(x1, x2)
                vec_y_range = fun_ranger(y1, y2)
            else
                continue
            end
        end
        vec_coordinates_ith = map(string, vec_x_range, repeat([","], length(vec_x_range)), vec_y_range)
        if vec_coordinates == nothing
            vec_coordinates = vec_coordinates_ith
        else
            vec_coordinates = vcat(vec_coordinates, vec_coordinates_ith)
        end
    end

    vec_unique = unique(vec_coordinates)
    n_counter = 0
    @showprogress for n_unique in vec_unique
        if sum(vec_coordinates .== n_unique) > 1
            n_counter = n_counter + 1
        end
    end

    println("#####################################")
    if include_45degree_diagonals==false
        println("Part 1:")
    else
        println("Part 2:")
    end
    println(n_counter)
    println("#####################################")
end

fname = "aoc-2021-05-input.txt"
@time fun_counter_number_of_stable_points(fname)
@time fun_counter_number_of_stable_points(fname)
@time fun_counter_number_of_stable_points(fname, include_45degree_diagonals=true)
