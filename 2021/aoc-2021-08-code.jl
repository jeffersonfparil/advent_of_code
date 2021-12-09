fun_parser = function(fname)
    vec_stream = readlines(fname)
    # vec_stream = ["be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe", "edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc", "fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg", "fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb", "aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea", "fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb", "dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe", "bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef", "egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb", "gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce"]
    mat_signals_output = reshape(vcat(split.(vec_stream, " | ")...), (2, length(vec_stream)))
    vec_signals = mat_signals_output[1,:]
    vec_outputs = mat_signals_output[2,:]
    return(vec_signals, vec_outputs)
end

dic_segments_to_digit  = Dict([
    "cf" => 1,
    "acf" => 7,
    "bcdf" => 4,
    "acdfg" => 3,
    "acdeg" => 2,
    "abdfg" => 5,
    "abcefg" => 0,
    "abdefg" => 6,
    "abcdfg" => 9,
    "abcdefg" => 8
])

fun_vec_segments_to_mat_counts = function(vec_segments; bool_convert_segments_to_digits=false, vec_correct_segment=nothing)
    n_total_segments = 7
    mat_counts = zeros(Int, length(vec_segments), n_total_segments)
    n_digit = []
    for i in 1:size(mat_counts)[1]
        # i = 1
        # println(vec_segments[i])
        vec_idx_segments = ["a", "b", "c", "d", "e", "f", "g"] .∈ [split(vec_segments[i], "")]
        vec_idx_mat_col = collect(1:size(mat_counts)[2])[vec_idx_segments]
        mat_counts[i, vec_idx_mat_col] .= 1
        if bool_convert_segments_to_digits
            str_segments = string(sort(vec_correct_segment[Bool.(mat_counts[i,:])])...)
            append!(n_digit, dic_segments_to_digit[str_segments])
        end
    end
    if bool_convert_segments_to_digits
        n_digit = parse(Int, string(n_digit...))
        # println(n_digit)
    end
    return(mat_counts, n_digit)
end

fun_total_digital_output = function(fname; part1=true)
    ### parse signals and outputs into a vector
    vec_signals, vec_outputs = fun_parser(fname)
    if part1
        vec_n_segments = [2, 3, 4, 7] ### 2:number-1, 3:number-7, 4:number-4, and 7:number-8
        n_1_4_7_8_output = 0
        for row in vec_outputs
            vec_row_output = split.(row, " ")
            n_1_4_7_8_output = n_1_4_7_8_output + sum(length.(vec_row_output) .∈ [vec_n_segments])
        end
        println("#####################################")
        println("Part 1:")
        println(n_1_4_7_8_output)
        println("#####################################")
    else
        n_sum_digits = 0
        for i in 1:length(vec_signals)
            # i = 1
            ### parse signals and outputs per row
            vec_signals_ith = split.(vec_signals[i], " ")
            vec_outputs_ith = split.(vec_outputs[i], " ")
            vec_signals_ith = vec_signals_ith[sortperm(length.(vec_signals_ith))]
            mat_counts, _ = fun_vec_segments_to_mat_counts(vec_signals_ith)
            ### compute column sums for all, and products for five-segments and six-segments
            vec_sums = sum(mat_counts, dims=1)
            vec_fives_products = prod(mat_counts[4:6, :], dims=1)
            vec_sixes_products = prod(mat_counts[7:9, :], dims=1)
            ### define the correct segment IDs
            vec_correct_segment = Array{Union{Nothing, String}}(nothing, 7)
            vec_correct_segment[(vec_sums .== 6)[1,:]] .= "b"
            vec_correct_segment[(vec_sums .== 4)[1,:]] .= "e"
            vec_correct_segment[(vec_sums .== 9)[1,:]] .= "f"
            vec_correct_segment[(vec_sums .* vec_fives_products .== 8)[1,:]] .= "a"
            vec_correct_segment[((vec_sums .* vec_fives_products .== 0) .& (vec_sums .== 8))[1,:]] .= "c"
            vec_correct_segment[(vec_sums .* vec_sixes_products .== 7)[1,:]] .= "g"
            vec_correct_segment[((vec_sums .* vec_sixes_products .== 0) .& (vec_sums .== 7))[1,:]] .= "d"
            ### convert the outputs into digits
            mat_counts_output, n_digit = fun_vec_segments_to_mat_counts(vec_outputs_ith, bool_convert_segments_to_digits=true, vec_correct_segment=vec_correct_segment)
            n_sum_digits = n_sum_digits + n_digit
        end
        println("#####################################")
        println("Part 1:")
        println(n_sum_digits)
        println("#####################################")
    end
end


fname = "aoc-2021-08-input.txt"
@time fun_total_digital_output(fname)
@time fun_total_digital_output(fname)
@time fun_total_digital_output(fname, part1=false)
@time fun_total_digital_output(fname, part1=false)
