fun_add_margin_of_zeros = function(X)
    vcat(
        zeros(Int, 1, size(X,1)+2), 
            hcat(zeros(Int, size(X,1)), X, zeros(Int, size(X,1))),
        zeros(Int, 1, size(X,1)+2)
        )
end

fun_lightup_recursive = function(mat_lightup_old, mat_octopussenergy)
    mat_lightup_new =  fun_add_margin_of_zeros((mat_octopussenergy .> 9) .& (.!mat_lightup_old))
    ### horizontal and vertical slides
    mat_horizontal_slide = mat_lightup_new[:, 1:(end-1)] + mat_lightup_new[:, 2:(end-0)];
    mat_vertical_slide   = mat_lightup_new[1:(end-1), :] + mat_lightup_new[2:(end-0), :];
    A = mat_horizontal_slide[2:(end-1), 2:(end-0)];
    B = mat_horizontal_slide[2:(end-1), 1:(end-1)];
    C = mat_vertical_slide[2:(end-0), 2:(end-1)];
    D = mat_vertical_slide[1:(end-1), 2:(end-1)];
    ### diagonal slides
    mat_diagonal_forward_slide  = mat_lightup_new[1:(end-1), 1:(end-1)] + mat_lightup_new[2:(end-0), 2:(end-0)];
    mat_diagonal_backward_slide = mat_lightup_new[1:(end-1), 2:(end-0)] + mat_lightup_new[2:(end-0), 1:(end-1)];
    E = mat_diagonal_forward_slide[1:(end-1), 1:(end-1)];
    F = mat_diagonal_forward_slide[2:(end-0), 2:(end-0)];
    G = mat_diagonal_backward_slide[1:(end-1), 2:(end-0)];
    H = mat_diagonal_backward_slide[2:(end-0), 1:(end-1)];
    ### sum up lightups
    mat_total_flash = A + B + C + D + E + F + G + H
    ### update energies
    mat_octopussenergy = mat_octopussenergy + mat_total_flash
    ### to recurse or not to recurse
    mat_bool_octopuss_all_ripe = mat_octopussenergy .> 9
    mat_bool_octopuss_initially_ripe_including_old_ones = Bool.(mat_lightup_old .+ mat_lightup_new[2:(end-1), 2:(end-1)])
    if sum(mat_bool_octopuss_all_ripe .& (.!mat_bool_octopuss_initially_ripe_including_old_ones))>0
        mat_lightup_old = Bool.(mat_lightup_old .+ mat_lightup_new[2:(end-1), 2:(end-1)])
        mat_lightup_old, mat_octopussenergy = fun_lightup_recursive(mat_lightup_old, mat_octopussenergy)
    end
    ### output for recursion input
    return(mat_lightup_old, mat_octopussenergy)
end

fun_let_octopussies_lightup = function(fname; part1=true)
    ### parse input file
    mat_octopussenergy = parse.(Int, hcat(split.(readlines(fname), "")...))'
    # mat_octopussenergy = parse.(Int, hcat(split.(["5483143223", "2745854711", "5264556173", "6141336146", "6357385478", "4167524645", "2176841721", "6882881134", "4846848554", "5283751526"], "")...))'
    if part1
        n_steps = 100
        n_flashes = 0
        for t in 1:n_steps
            mat_octopussenergy = mat_octopussenergy .+ 1
            mat_lightup_old = zeros(Bool, size(mat_octopussenergy))
            mat_lightup_old, mat_octopussenergy = fun_lightup_recursive(mat_lightup_old, mat_octopussenergy)
            vec_idx_flashes = mat_octopussenergy .> 9
            mat_octopussenergy[vec_idx_flashes] .= 0
            n_flashes = n_flashes + sum(vec_idx_flashes)
        end
        println("#####################################")
        println("Part 1:")
        println(n_flashes)
        println("#####################################")
    else
        vec_idx_flashes = [0]
        n_steps_until_all_octopussies_flash = 0
        while sum(vec_idx_flashes) < prod(size(mat_octopussenergy))
            mat_octopussenergy = mat_octopussenergy .+ 1
            mat_lightup_old = zeros(Bool, size(mat_octopussenergy))
            mat_lightup_old, mat_octopussenergy = fun_lightup_recursive(mat_lightup_old, mat_octopussenergy)
            vec_idx_flashes = mat_octopussenergy .> 9
            mat_octopussenergy[vec_idx_flashes] .= 0
            n_steps_until_all_octopussies_flash += 1
        end
        println("#####################################")
        println("Part 2:")
        println(n_steps_until_all_octopussies_flash)
        println("#####################################")
    end
end

fname = "aoc-2021-11-input.txt"
@time fun_let_octopussies_lightup(fname)
@time fun_let_octopussies_lightup(fname)
@time fun_let_octopussies_lightup(fname, part1=false)
@time fun_let_octopussies_lightup(fname, part1=false)
