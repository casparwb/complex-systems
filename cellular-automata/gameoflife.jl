using Plots


struct Life
    grid :: Tuple{Int}
    state :: Array{Int8, 2}
    t :: Int
end

function get_neighbours(system, i, j)

    ni, nj = system.grid

    if i == ni
        up = 

end

function step(system::Life)

    where_alive = findall(system)



end

function simulate(system::Life, T)



end