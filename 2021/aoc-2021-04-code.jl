
fname = "aoc-2021-04-input.txt"
dat = readlines(fname)

vec_draw = parse.(Int, split(dat[1], ","))

fun_parser = function(idx, vec_stream)
    idx = 3
    vec_stream = dat

    vec_row = parse.(Int, split(vec_stream[idx])) ### splits by spaces and removes all the white spaces too!    
    mat_board = nothing
    while length(vec_row) > 0
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

X, idx = fun_parser(idx, vec_stream)