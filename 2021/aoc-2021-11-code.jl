fname = "aoc-2021-11-input.txt"
mat_octopussenergy = parse.(Int, hcat(split.(readlines(fname), "")...))'
# mat_octopussenergy = parse.(Int, hcat(split.(["5483143223", "2745854711", "5264556173", "6141336146", "6357385478", "4167524645", "2176841721", "6882881134", "4846848554", "5283751526"], "")...))'

n_steps = 100
for t in 1:n_steps

    n_counter = 1
    bool_relight = true
    while bool_relight
        mat_lightup = vcat(zeros(Int, 1, size(mat_octopussenergy,1)+2), 
                            hcat(zeros(Int, size(mat_octopussenergy,1)), mat_octopussenergy .== 9, zeros(Int, size(mat_octopussenergy,1))),
                        zeros(Int, 1, size(mat_octopussenergy,1)+2));
        ### horizontal and vertical slides
        mat_horizontal_slide = mat_lightup[:, 1:(end-1)] + mat_lightup[:, 2:(end-0)];
        mat_vertical_slide   = mat_lightup[1:(end-1), :] + mat_lightup[2:(end-0), :];
        A = mat_horizontal_slide[2:(end-1), 2:(end-0)];
        B = mat_horizontal_slide[2:(end-1), 1:(end-1)];
        C = mat_vertical_slide[2:(end-0), 2:(end-1)];
        D = mat_vertical_slide[1:(end-1), 2:(end-1)];
        ### diagonal slides
        mat_diagonal_forward_slide  = mat_lightup[1:(end-1), 1:(end-1)] + mat_lightup[2:(end-0), 2:(end-0)];
        mat_diagonal_backward_slide = mat_lightup[1:(end-1), 2:(end-0)] + mat_lightup[2:(end-0), 1:(end-1)];
        E = mat_diagonal_forward_slide[1:(end-1), 1:(end-1)];
        F = mat_diagonal_forward_slide[2:(end-0), 2:(end-0)];
        G = mat_diagonal_backward_slide[1:(end-1), 2:(end-0)];
        H = mat_diagonal_backward_slide[2:(end-0), 1:(end-1)];

        mat_total_flash = A + B + C + D + E + F + G + H;

        mat_total_flash[Bool.(mat_lightup[2:(end-1), 2:(end-1)])] .= 0;

        if n_counter == 1
            mat_octopussenergy = mat_octopussenergy + mat_total_flash .+ 1;
        else
            n_counter = 0
        end

        mat_bool_octopuss_infected = (mat_octopussenergy .-1) .>= 9
        mat_bool_octopuss_initially_ripe = Bool.(mat_lightup[2:(end-1),2:(end-1)])
        if sum(mat_bool_octopuss_infected .& .!mat_bool_octopuss_initially_ripe)>0
            bool_relight = true
        else
            bool_relight = false
        end

    end
    mat_octopussenergy[mat_octopussenergy .> 9] .= 0;
    mat_octopussenergy

end
