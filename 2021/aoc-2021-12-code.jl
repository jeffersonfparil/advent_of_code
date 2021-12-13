### NOTE: We're assuming no two big caves are directly connected!
fun_cave_crawler = function(vec_vec_path, mat_str_nonstarting_caves, vec_caves_list_lowercase; part1=true)
    bool_have_we_not_reached_the_end_cave = (vec_vec_path[end][end] != "end")
    if part1
        bool_do_we_have_at_most_one_lowercase_cave_in_our_path = (sum([count(vec_vec_path[end].==x) for x in vec_caves_list_lowercase] .> 1) == 0)
        bool_test = (bool_have_we_not_reached_the_end_cave) & (bool_do_we_have_at_most_one_lowercase_cave_in_our_path)
    else
        vec_n_lowercase_caves_in_our_path = [count(vec_vec_path[end].==x) for x in vec_caves_list_lowercase]
        bool_do_we_have_lowercase_caves_appearing_more_than_twice = sum(vec_n_lowercase_caves_in_our_path .> 2) > 0
        bool_do_we_have_at_most_one_lowercase_cave_apearing_twice = sum(vec_n_lowercase_caves_in_our_path .== 2) <= 1
        bool_test = (bool_have_we_not_reached_the_end_cave) & (bool_do_we_have_lowercase_caves_appearing_more_than_twice==false) & (bool_do_we_have_at_most_one_lowercase_cave_apearing_twice==true)
    end
    # println(vec_vec_path)
    # println(bool_do_we_have_at_most_one_lowercase_cave_in_our_path)
    if bool_test
        vec_idx_connected_caves = Bool.(sum(mat_str_nonstarting_caves .== [vec_vec_path[end][end]], dims=1)[1,:])
        mat_str_connected_caves = mat_str_nonstarting_caves[:, vec_idx_connected_caves]
        for j in 1:size(mat_str_connected_caves,2)
            # j = 1
            # println("Connected caves:")
            # println(mat_str_connected_caves)
            vec_next_caves = mat_str_connected_caves[:, j]
            vec_idx_bool_connected_caves = vec_next_caves .!= vec_vec_path[end][end]
            # println(vec_idx_bool_connected_caves)
            append!(vec_vec_path[end], vec_next_caves[vec_idx_bool_connected_caves])
            vec_vec_path = fun_cave_crawler(vec_vec_path, mat_str_nonstarting_caves, vec_caves_list_lowercase, part1=part1)
        end
        if vec_vec_path[end][end] != "end"
            vec_vec_path[end] = vec_vec_path[end][1:(end-1)]
        end
    elseif bool_have_we_not_reached_the_end_cave == false
        vec_vec_path = vcat(vec_vec_path, [vec_vec_path[end][1:(end-1)]])
    else
        # println("Double small caves!")
        # println(vec_vec_path)
        vec_vec_path[end] = vec_vec_path[end][1:(end-1)]
        # println(vec_vec_path)
        # println("#########################################")
    end
    # println("return")
    # println("#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    # println("#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    # println("#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    return(vec_vec_path)
end

fun_find_all_paths = function(fname; part1=true)
    mat_str_caves = hcat(split.(readlines(fname), "-")...)
    # mat_str_caves = hcat(split.(["dc-end", "HN-start", "start-kj", "dc-start", "dc-HN", "LN-dc", "HN-end", "kj-sa", "kj-HN", "kj-dc"], "-")...)
    # mat_str_caves = hcat(split.(["fs-end", "he-DX", "fs-he", "start-DX", "pj-DX", "end-zg", "zg-sl", "zg-pj", "pj-he", "RW-he", "fs-DX", "pj-RW", "zg-RW", "start-pj", "he-WI", "zg-he", "pj-fs", "start-RW"], "-")...)
    # part1 = false

    vec_caves_list_all = unique(mat_str_caves)
    vec_caves_list_uppercase = vec_caves_list_all[[uppercase(x)==x for x in vec_caves_list_all]]
    vec_caves_list_lowercase = vec_caves_list_all[[uppercase(x)!=x for x in vec_caves_list_all]]
    vec_caves_list_lowercase = vec_caves_list_lowercase[.!in.(vec_caves_list_lowercase, [["start", "end"]])]

    idx_starting_caves = collect(1:size(mat_str_caves,2))[sum(mat_str_caves .== "start", dims=1)[1,:] .== 1]
    idx_nonstarting_caves = collect(1:size(mat_str_caves,2))[sum(mat_str_caves .!= "start", dims=1)[1,:] .== 2]
    mat_str_starting_caves = mat_str_caves[:, idx_starting_caves]
    mat_str_nonstarting_caves = mat_str_caves[:, idx_nonstarting_caves]
    vec_vec_all_paths = []
    for i in idx_starting_caves
        # i = idx_starting_caves[1]
        vec_vec_path = [[mat_str_caves[mat_str_caves[:,i] .== "start", i][1], mat_str_caves[mat_str_caves[:,i] .!= "start", i][1]]]
        X = fun_cave_crawler(vec_vec_path, mat_str_nonstarting_caves, vec_caves_list_lowercase, part1=part1)[1:(end-1)]
        vec_vec_all_paths = vcat(vec_vec_all_paths, X)
    end
    if part1
        println("#####################################")
        println("Part 1:")
        println(length(vec_vec_all_paths))
        println("#####################################")
    else
        println("#####################################")
        println("Part 2:")
        println(length(vec_vec_all_paths))
        println("#####################################")
    end
end


fname = "aoc-2021-12-input.txt"
@time fun_find_all_paths(fname)
@time fun_find_all_paths(fname)
@time fun_find_all_paths(fname, part1=false)
@time fun_find_all_paths(fname, part1=false)
