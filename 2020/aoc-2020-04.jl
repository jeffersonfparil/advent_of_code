# aoc-2020-04

x = readlines("aoc-2020-04.txt")
# x = readlines("test.txt")

### parse input text file
y = [x[1]]
for i in 2:length(x)
    # i = 3
    if x[i] != ""
        if y[end] == ""
            y[end] = x[i]
        else 
            y[end] = string(y[end], " ", x[i])
        end
    else
        push!(y, "")
    end
end

vec_valid = []
for i in 1:length(y)
    # i = 1
    z0 = vcat([split(a, ":") for a in split(y[i], " ")]...)
    z1 = reshape(z0, 2, Int(length(z0)/2))
    if (length(z1[1,:]) == 8)
        push!(vec_valid, z1)
    else
        if (length(z1[1,:]) == 7) & (sum(z1[1,:] .!= "cid") == 7)
            push!(vec_valid, z1)
        end
    end
end

length(vec_valid)


function checker(vec)
    id = vec[1]
    value = vec[2]
    out = []
    if id == "byr"
        value = parse(Int64, value)
        append!(out, (value >= 1920) & (value <= 2002))
    elseif id == "iyr"
        value = parse(Int64, value)
        append!(out, (value >= 2010) & (value <= 2020))
    elseif id == "eyr"
        value = parse(Int64, value)
        append!(out, (value >= 2020) & (value <= 2030))
    elseif (id == "hgt") & (match(r"cm", value) != nothing)
        value = parse(Int64, value[1:(end-2)])
        append!(out, (value >= 150) & (value <= 193))
    elseif (id == "hgt") & (match(r"in", value) != nothing)
        value = parse(Int64, value[1:(end-2)])
        append!(out, (value >= 59) & (value <= 76))
    elseif (id == "hcl")
        append!(out, (match(r"^#", value) != nothing) & (length(value)==7) & (match(r"^#[0-9a-f]*$", value) != nothing))
    elseif (id =="ecl")
        append!(out, sum(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"] .== value)==1)
    elseif (id == "pid")
        append!(out, (length(value) == 9) & (match(r"^[0-9]*$", value) != nothing))
    elseif (id == "cid")
        append!(out, true)
    else
        append!(out, false)
    end
    return(out[1])
end

out = []
for ID in vec_valid
    # ID = vec_valid[1]
    ID_bool = []
    for j in 1:size(ID,2)
        # j = 2
        vec = ID[:,j]
        append!(ID_bool, checker(vec))
    end
    append!(out, sum(ID_bool)==size(ID,2))
end
sum(out)

