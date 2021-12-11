fun_parser = function(fname)
    # fname = "aoc-2021-09-input.txt"
    vec_stream = readlines(fname)
    # vec_stream = ["2199943210", "3987894921", "9856789892", "8767896789", "9899965678"]
    mat_heightmap = parse.(Int, hcat(collect.(vec_stream)...))'
    return(mat_heightmap)
end

fun_crawl_recursive = function(x, y, X, X_map)
    n, m = size(X)
    if (x > 0) & (y > 0) & (x <= n) & (y <= m)
         if (X[x, y] == 1) & (X_map[x, y]==0)
             X_map[x, y] =  1
             X_map = fun_crawl_recursive(x-1, y+0, X, X_map)
             X_map = fun_crawl_recursive(x+1, y+0, X, X_map)
             X_map = fun_crawl_recursive(x+0, y-1, X, X_map)
             X_map = fun_crawl_recursive(x+0, y+1, X, X_map)
         end
     end
     return(X_map)
end

fun_find_lowest_point_and_basin_sizes = function(fname; part1=true)
    ### parse
    mat_heightmap = fun_parser(fname)
    ### add a border of 10's
    mat_heightmap_margined = hcat(repeat([10], size(mat_heightmap, 1),1), mat_heightmap, repeat([10], size(mat_heightmap, 1),1))
    mat_heightmap_margined = vcat(repeat([10], 1, size(mat_heightmap_margined, 2)), mat_heightmap_margined, repeat([10], 1, size(mat_heightmap_margined, 2)))
    ### find lowest points
    A = sign.(mat_heightmap_margined[:, 1:(end-1)] .- mat_heightmap_margined[:, 2:(end-0)])[2:(end-1), 2:(end-0)]
    B = sign.(mat_heightmap_margined[:, 2:(end-0)] .- mat_heightmap_margined[:, 1:(end-1)])[2:(end-1), 1:(end-1)]
    C = sign.(mat_heightmap_margined[1:(end-1), :] .- mat_heightmap_margined[2:(end-0), :])[2:(end-0), 2:(end-1)]
    D = sign.(mat_heightmap_margined[2:(end-0), :] .- mat_heightmap_margined[1:(end-1), :])[1:(end-1), 2:(end-1)]
    mat_idx = A .+ B .+ C .+ D .== -4
    if part1==true
        n_sum_risk_levels = sum(mat_heightmap[mat_idx] .+ 1)
        println("#####################################")
        println("Part 1:")
        println(n_sum_risk_levels)
        println("#####################################")
    end
    ### find the coordinates of the lowest points
    mat_coordinates_row = reshape(repeat(1:size(mat_heightmap,1), size(mat_heightmap,2)), size(mat_heightmap))
    mat_coordinates_col = reshape(repeat(1:size(mat_heightmap,2), size(mat_heightmap,1)), reverse(size(mat_heightmap)))'
    mat_coordinates = hcat(mat_coordinates_row[mat_idx], mat_coordinates_col[mat_idx])
    ### define the contours of the landscape using the highest points
    X = Int.(.!(mat_heightmap .>= 9))
    ### find the basin sizes
    vec_basin_size = Int.([])
    for i in 1:size(mat_coordinates,1)
        # i = 2
        x = mat_coordinates[i, 1]
        y = mat_coordinates[i, 2]
        X_map = zeros(Int, size(X))
        append!(vec_basin_size, sum(fun_crawl_recursive(x, y, X, X_map)))
    end
    if part1==false
        n_product_top_3_basin_sizes = prod(sort!(vec_basin_size)[(end-2):end])
        println("#####################################")
        println("Part 2:")
        println(n_product_top_3_basin_sizes)
        println("#####################################")
    end
end

fname = "aoc-2021-09-input.txt"
@time fun_find_lowest_point_and_basin_sizes(fname)
@time fun_find_lowest_point_and_basin_sizes(fname)
@time fun_find_lowest_point_and_basin_sizes(fname, part1=false)
@time fun_find_lowest_point_and_basin_sizes(fname, part1=false)
