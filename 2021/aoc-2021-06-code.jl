using DataFrames

count_fishes = function(fname; n_days, n_days_to_reproduction=7, n_day_to_sexual_maturity=2)
    vec_stream = parse.(Int, split(readlines(fname)[1], ","))
    @time df_initial_counts = combine(groupby(DataFrames.DataFrame(x=vec_stream), :x), nrow)
    vec_counter = repeat([0], n_days_to_reproduction + n_day_to_sexual_maturity)
    vec_idx = df_initial_counts.x .+ 1 ### add one since we're counting day 0
    vec_counter[vec_idx] = df_initial_counts.nrow
    for t in 1:n_days
        vec_counter_old = copy(vec_counter)
        for i in 1:(n_days_to_reproduction+n_day_to_sexual_maturity-1)
            vec_counter[i] = vec_counter_old[i+1]
        end
        vec_counter[9] = vec_counter_old[1] ### generate new fishes
        vec_counter[7] = vec_counter[7] + vec_counter_old[1] ### reset oldies
    end
    println("#####################################")
    if n_days==80
        println("Part 1:")
    else
        println("Part 2:")
    end
    sum(vec_counter)
    println("#####################################")
end

fname = "aoc-2021-06-input.txt"
n_days_to_reproduction = 7
n_day_to_sexual_maturity = 2
n_days = 256

@time count_fishes(fname, n_days=80)
@time count_fishes(fname, n_days=80)
@time count_fishes(fname, n_days=256)
