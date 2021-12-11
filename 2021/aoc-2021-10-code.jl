Parentheses = Dict([
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
])

Illegal_parentheses_points = Dict([
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
])

Completion_parentheses_points = Dict([
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
])

fun_find_illegal_parenthesis = function(fname; part1=true)
    ### parse input
    vec_stream = readlines(fname)
    # vec_stream = ["[({(<(())[]>[[{[]{<()<>>", "[(()[<>])]({[<{<<[]>>(", "{([(<{}[<>[]}>{[]{[(<()>", "(((({<>}<{<{<>}{[]{[]{}", "[[<[([]))<([[{}[[()]]]", "[{[{({}]{}}([{[{{{}}([]", "{<[[]]>}<{[{[{[]{()[[[]", "[<(<(<(<{}))><([]([]()", "<{([([[(<>()){}]>(<<{{", "<{([{{}}[<[[[<>{}]]]>[]]"]
    vec_opening_parentheses = collect(keys(Parentheses))
    vec_closing_parentheses = values(Parentheses)
    vec_illegal_parentheses = []
    vec_idx_illegal_parentheses = []
    vec_n_sum_points_expected_closing_parenthesis = []
    for i in 1:length(vec_stream)
        # i = 10
        vec_line = collect(vec_stream[i])
        vec_expected_closing_parentheses = []
        if sum(vec_opening_parentheses .∈ [[vec_line[end]]]) > 0
            n_length_vec_line = length(vec_line)
        else
            n_length_vec_line = length(vec_line) - 1
        end
        for j in 1:n_length_vec_line
            # j = 1
            char_current = vec_line[j]
            bool_closing_parenthesis = sum(vec_closing_parentheses .∈ [[char_current]])>0
            if bool_closing_parenthesis == false
                append!(vec_expected_closing_parentheses, Parentheses[char_current])
            else
                if vec_expected_closing_parentheses[end] == char_current
                    vec_expected_closing_parentheses = vec_expected_closing_parentheses[1:(end-1)]
                else
                    append!(vec_illegal_parentheses, char_current)
                    append!(vec_idx_illegal_parentheses, i)
                    break
                end
            end
        end
        if part1==false
            if sum(vec_opening_parentheses .∈ [[vec_line[end]]]) > 0
                vec_expected_closing_parentheses = reverse(vec_expected_closing_parentheses[1:(end-0)])
            else
                vec_expected_closing_parentheses = reverse(vec_expected_closing_parentheses[1:(end-1)])
            end
            vec_points = map(x -> Completion_parentheses_points[x], vec_expected_closing_parentheses)
            x = 0
            for p in vec_points
                x = (5*x) + p
            end
            append!(vec_n_sum_points_expected_closing_parenthesis, x)
            # println(vec_expected_closing_parentheses)
        end
    end
    if part1
        n_sum_points = 0
        for key in collect(keys(Illegal_parentheses_points))
            n_sum_points = n_sum_points + sum(vec_illegal_parentheses .== only(key)) * Illegal_parentheses_points[key]
        end
        println("#####################################")
        println("Part 1:")
        println(n_sum_points)
        println("#####################################")
    else
        vec_bool_idx = .!(collect(1:length(vec_stream)) .∈ [vec_idx_illegal_parentheses])
        n_middle_score = sort(vec_n_sum_points_expected_closing_parenthesis[vec_bool_idx])[Int(ceil(sum(vec_bool_idx)/2))]
        println("#####################################")
        println("Part 2:")
        println(n_middle_score)
        println("#####################################")
    end
end


fname = "aoc-2021-10-input.txt"
@time fun_find_illegal_parenthesis(fname);
@time fun_find_illegal_parenthesis(fname);
@time fun_find_illegal_parenthesis(fname, part1=false)
@time fun_find_illegal_parenthesis(fname, part1=false)

