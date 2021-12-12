fname = "aoc-2021-12-input.txt"
mat_str_caves = hcat(split.(readlines(fname), "-")...)
# mat_str_caves = hcat(split.(["dc-end", "HN-start", "start-kj", "dc-start", "dc-HN", "LN-dc", "HN-end", "kj-sa", "kj-HN", "kj-dc"], "-")...)

vec_caves_list_all = unique(mat_str_caves)
vec_caves_list_uppercase = vec_caves_list_all[[uppercase(x)==x for x in vec_caves_list_all]]
vec_caves_list_lowercase = vec_caves_list_all[[uppercase(x)!=x for x in vec_caves_list_all]]

idx_starting_caves = collect(1:size(mat_str_caves,2))[sum(mat_str_caves .== "start", dims=1)[1,:] .== 1]
idx_nonstarting_caves = collect(1:size(mat_str_caves,2))[sum(mat_str_caves .!= "start", dims=1)[1,:] .== 2]
mat_str_nonstarting_caves = mat_str_caves[:, idx_nonstarting_caves]


# for i in idx_starting_caves
i = idx_starting_caves[1]
vec_vec_path = [[mat_str_caves[mat_str_caves[:,i] .== "start", i][1], mat_str_caves[mat_str_caves[:,i] .!= "start", i][1]]]


idx_unused_caves_col = sum((mat_str_nonstarting_caves .== [        vec_vec_path[end][(i-1):i]  for i in 2:length(vec_vec_path[end])]) .|
                           (mat_str_nonstarting_caves .== [reverse(vec_vec_path[end][(i-1):i]) for i in 2:length(vec_vec_path[end])]), dims=1)[1,:] .< 2
mat_unused_potential_caves  = mat_str_nonstarting_caves[:, idx_unused_caves_col]


fun_caving_recursion = function(vec_vec_path, mat_unused_potential_caves, mat_str_nonstarting_caves)
    if (vec_vec_path[end][end] != "end") & (sum([count(vec_vec_path[end].==x) for x in vec_caves_list_lowercase] .> 1) == 0)
        n_counter = 0 ### messing up
        while (length(mat_unused_potential_caves) > 0) & (n_counter <= length(mat_unused_potential_caves))
            vec_bool_connected_caves = mat_unused_potential_caves[:,1] .== vec_vec_path[end][end]
            if sum(vec_bool_connected_caves) > 0
                vec_vec_path[end] = vcat(vec_vec_path[end], mat_unused_potential_caves[.!vec_bool_connected_caves, 1])
                println(mat_unused_potential_caves)
                mat_unused_potential_caves = mat_unused_potential_caves[:,2:end]
                vec_vec_path, mat_unused_potential_caves = fun_caving_recursion(vec_vec_path,
                                                                                mat_unused_potential_caves,
                                                                                mat_str_nonstarting_caves)
            else
                n_counter = n_counter + 1
                mat_unused_potential_caves = hcat(mat_unused_potential_caves[:,2:end], mat_unused_potential_caves[:,1])
            end
        end
    elseif vec_vec_path[end][end] == "end"
        append!(vec_vec_path, [vec_vec_path[end][1:(end-1)]])
    end
    return(vec_vec_path, mat_unused_potential_caves)
end


X, Y = fun_caving_recursion(vec_vec_path, mat_unused_potential_caves, mat_str_nonstarting_caves)



# end

