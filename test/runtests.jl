using ABM4OSN
using Test
using JLD
using JLD2
using CSV
using LightGraphs

sim2 = load("sim500.jld2")
net_evolution = deepcopy(sim2["sim500"][1][3])

CSV.write("dataframe.csv", sim2["sim500"][1][1])

length(outneighbors(sim2["sim500"][1][3][10], 100))
outdegree(sim2["sim500"][1][3][10], 100)

sim2["sim500"][1][3][10]

g = ABM4OSN.create_network(100,10)

outneighbors(g,1)

outdegrees = []
for network in net_evolution
    push!(outdegrees, outdegree(network))
    avg_outdegree = mean(outdegree(network))
    std_outdegree = std(outdegree(network))
    max_outdegree = maximum(outdegree(network))
    println("Network $network: AVG outdegree is $avg_outdegree, STD outdegree is $std_outdegree, MAX outdegree is $max_outdegree.")
end

using Plots
plot(outdegrees, alpha=0.2)
outdegrees
arrtest = []
last(arrtest)

using LightGraphs
@time sim = simulate(Config(network = cfg_net(agent_count = 100), simulation=cfg_sim(n_iter=100)));

sim


mean([weight for weight in sim[1][2].Weight if weight>=0])
sim[1][1][:, [1,2,5,6,7]]

sim
save("sim500.jld2", "sim500", sim)

testing = load("sim500.jld2")
testing["sim500"]

length(sim[3][2])

@testset "ABM4OSN.jl" begin
    # Write your own tests here.
    @test typeof(Config()) == Config
    @test Config(network=cfg_net(agent_count=100)).network.agent_count == 100
    @test length(simulate()[3][2]) == 100
end

maximum([1,2,3])
