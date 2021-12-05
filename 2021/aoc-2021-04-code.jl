fun_parser = function(idx, vec_stream)
    ##################################
    ### TEST:
    # idx = 3
    # fname = "aoc-2021-04-input.txt"
    # vec_stream = readlines(fname)
    ##################################
    vec_row = parse.(Int, split(vec_stream[idx])) ### splits by spaces and removes all the white spaces too!    
    mat_board = nothing
    while (length(vec_row) > 0) & ((idx+1) <= length(vec_stream))
        if mat_board  == nothing
            mat_board = vec_row'
        else
            mat_board = vcat(mat_board, vec_row')
        end
        idx = idx + 1
        vec_row = parse.(Int, split(vec_stream[idx]))
    end
    return(mat_board, idx+1)
end

fun_find_matches = function(mat_board, vec_draw)
    ############################################
    ### TEST:
    # fname = "aoc-2021-04-input.txt"
    # vec_stream = readlines(fname)
    # idx = 3
    # mat_board, idx = fun_parser(idx, vec_stream)
    # vec_draw = parse.(Int, split(vec_stream[1], ","))
    ############################################
    n_draw = length(vec_draw)
    n_row, n_col = size(mat_board)
    min_n_draws = n_draw
    for i in 1:n_row
        idx_bin = vec_draw .∈ [mat_board[i,:]] ### broadcasting trick
        if sum(idx_bin) == n_row
            max_n_draws_ith = maximum(collect(1:n_draw)[idx_bin]); # println(max_n_draws_ith)
            if max_n_draws_ith < min_n_draws
                min_n_draws = max_n_draws_ith
            end
        end
    end
    for j in 1:n_col
        idx_bin = vec_draw .∈ [mat_board[:,j]] ### broadcasting trick
        if sum(idx_bin) == n_row
            max_n_draws_jth = maximum(collect(1:n_draw)[idx_bin]); # println(max_n_draws_jth)
            if max_n_draws_jth < min_n_draws
                min_n_draws = max_n_draws_jth
            end
        end
    end
    return(min_n_draws)
end

fun_find_winning_board_and_calculate_score = function(fname; bool_find_winning_board=true, idx_init=3)
    ### Load input
    vec_stream = readlines(fname)
    vec_draw = parse.(Int, split(vec_stream[1], ","))
    ### Initialise winning stats
    mat_target_board = nothing
    if bool_find_winning_board
        min_n_draws = length(vec_draw)
    else
        min_n_draws = 1
    end
    while idx_init < length(vec_stream)
        mat_board, idx_next = fun_parser(idx_init, vec_stream)
        min_n_draws_nth = fun_find_matches(mat_board, vec_draw)
        if bool_find_winning_board
            if min_n_draws_nth < min_n_draws
                mat_target_board = mat_board
                min_n_draws = min_n_draws_nth
            end
        else
            if min_n_draws_nth > min_n_draws
                mat_target_board = mat_board
                min_n_draws = min_n_draws_nth
            end
        end
        idx_init = idx_next
    end
    idx_winning_matches = mat_target_board .∈ [vec_draw[1:min_n_draws]]
    n_sum_unmarked = sum(mat_target_board[idx_winning_matches .== 0])
    n_winning_number = vec_draw[min_n_draws]
    println("#####################################")
    if bool_find_winning_board
        println("Part 1:")
    else
        println("Part 2:")
    end
    println(n_sum_unmarked * n_winning_number)
    println("#####################################")
end

fname = "aoc-2021-04-input.txt"
@time fun_find_winning_board_and_calculate_score(fname)
@time fun_find_winning_board_and_calculate_score(fname)
@time fun_find_winning_board_and_calculate_score(fname, bool_find_winning_board=false)
