using Plots, PlotThemes
theme(:juno)

struct CellularAutomata
    c::Array{Int8, 1}
    N::Int
    r::Int
    Δ::Function
    t::Int
    bc::Symbol
end

function simulate(T, N, rule, r=1, Δ=x->nothing, bc=:periodic; init=:random)

    if init == :random
        c = rand((Int8(0), Int8(1)), N)
    elseif init == :one
        c = zeros(Int8, N)
        c[round(Int, N/2)] = 1
    else
        c = init
    end

    CA = CellularAutomata(c, N, r, Δ, 1, bc)
    states = zeros(Int8, T, N)
    rules = get_rule(rule)

    λ = (8 - sum(collect(values(rules))))/8
    println("λ = $(round(λ, digits=3))")

    neighbors = get_neighbours(CA)  

    states[1,:] .= c
    for t = 2:T
        new_c = [rules[CA.c[cells]] for cells in eachrow(neighbors)]
        states[t,:] .= new_c
        CA.c .= new_c
    end

    return states

end

function get_rule(rule; random=false)

    if random
        ruledict = Dict([1, 1, 1] => rand((0, 1)),
                        [1, 1, 0] => rand((0, 1)),
                        [1, 0, 1] => rand((0, 1)),
                        [1, 0, 0] => rand((0, 1)),
                        [0, 1, 1] => rand((0, 1)),
                        [0, 1, 0] => rand((0, 1)),
                        [0, 0, 1] => rand((0, 1)),
                        [0, 0, 0] => rand((0, 1)))
        return ruledict
    else
        binary = string(rule, base=2)
        n_bin = length(binary)
    
        binary = repeat("0", 8-n_bin) * binary
        binary = parse.(Int, [binary...])
        ruledict = Dict([1, 1, 1] => binary[1],
                        [1, 1, 0] => binary[2],
                        [1, 0, 1] => binary[3],
                        [1, 0, 0] => binary[4],
                        [0, 1, 1] => binary[5],
                        [0, 1, 0] => binary[6],
                        [0, 0, 1] => binary[7],
                        [0, 0, 0] => binary[8])
        return ruledict

    end

end

function get_neighbours(CA::CellularAutomata)

    if CA.bc == :periodic
        return get_neighbours_periodic(CA)
    else
        return get_neighbours_blocking(CA)
    end

end

function get_neighbours_periodic(CA::CellularAutomata)

    N = CA.N # total number of cells
    n = 2*CA.r + 1 # number of neighbours per cell

    neighbours = zeros(Int, N, n)

    neighbours[1,:] .= [N, 1, 2]
    for i ∈ 2:N-1
        neighbours[i,:] .= [i-1, i, i+1]
    end

    neighbours[N,:] .= [N-1, N, 1]

    return neighbours
end

function get_neighbours_blocking(CA::CellularAutomata)

    N = CA.N

    neighbours = []

    for i ∈ 1:N
        if i == 1
            push!(neighbours, [i, i, i+1])
        elseif i == N
            push!(neighbours, [i-1, i, i])
        else
            push!(neighbours, [i-1, i, i+1])
        end
    end

    return neighbours

end