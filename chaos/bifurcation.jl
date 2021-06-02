using Plots, PlotThemes
theme(:juno)

function circle_map(t0, N, K, Ω=1/3)
    t = t0
    for i = 1:N
        t = t + Ω + K/(2π)*sin(2π*t)
    end
    
    return t
end

function circle_map2(t0, N, K, Ω=1/3)

    t = zeros(N)
    t[1] = t0
    for i = 2:N
        t[i] = t[i-1] + Ω + K/(2π)*sin(2π*t[i-1])
    end
    
    return t
end


function bifurcate(N)

    Ks = 0:0.01:4π

    ts = []

    for K in Ks
        push!(ts, circle_map(-0.5, N, K))
    end

    plot(Ks, ts)

end

function initials(N, K)

    inits = range(-1, stop=1, length=20)

    res = zeros(20, N)

    for i = 1:length(inits)
        res[i,:] .= circle_map2(inits[i], N, K)
    end

    p = plot()
    for r in eachrow(res)
        plot!(p, r, label=false)
    end
    
    p
end