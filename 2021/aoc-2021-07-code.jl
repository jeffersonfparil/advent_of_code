fun_crab_fuel_consumption = function(n_steps)
    sum(collect(1:n_steps))
end

fun_calculate_minimum_crab_step_cost = function(fname; bool_crab_fuel_cost=false)
    vec_pos = sort!(parse.(Int, split(readlines(fname)[1], ",")))
    vec_pos = sort!(rand(0:100000, 101))
    pos_focus = 0
    if bool_crab_fuel_cost == false
        n_distance_from_focus = sum(vec_pos)
    else
        n_distance_from_focus = sum(fun_crab_fuel_consumption.(vec_pos))
    end
    for i in 1:Int(ceil(length(vec_pos)/2))
        idx = vec_pos .>= i
        if bool_crab_fuel_cost == false
            n_distance_from_focus_ith = sum(vec_pos[idx] .- i) + sum(abs.(i .- vec_pos[.!idx]))
        else
            n_distance_from_focus_ith = sum(fun_crab_fuel_consumption.(vec_pos[idx] .- i)) + sum(fun_crab_fuel_consumption.(abs.(i .- vec_pos[.!idx])))
        end
        if n_distance_from_focus > n_distance_from_focus_ith
            pos_focus = i
            n_distance_from_focus = n_distance_from_focus_ith
        end
    end

    println("#####################################")
    if bool_crab_fuel_cost == false
        println("Part 1:")
    else
        println("Part 2:")
    end
    sum(n_distance_from_focus)
    println("#####################################")
    println(vec_pos[pos_focus])
    println(Statistics.median(vec_pos))
    println(vec_pos[Int(ceil(length(vec_pos)/2))])
    println(vec_pos[Int(floor(length(vec_pos)/2))])
    println(Statistics.mean(vec_pos))
end

fname = "aoc-2021-07-input.txt"
@time fun_calculate_minimum_crab_step_cost(fname)
@time fun_calculate_minimum_crab_step_cost(fname)
@time fun_calculate_minimum_crab_step_cost(fname, bool_crab_fuel_cost=true)
@time fun_calculate_minimum_crab_step_cost(fname, bool_crab_fuel_cost=true)
