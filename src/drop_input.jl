"""
    drop_input!(state, agent_idx, config)

Drop input for specific agent (~unfollow in Twitter).

# Arguments
- `state`: a tuple of the current graph and agent_list
- `agent_idx`: agent index
- `config`: Config object as provided by Config

See also: [`Config`](@ref), [`add_input!`](@ref)
"""
function drop_input!(
    state::Tuple{AbstractGraph, AbstractArray}, agent_idx::Integer,
    config::Config
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    # look for current input tweets that have too different opinion compared to own
    # and remove them if source agent opinion is also too different
    unfollow_candidates = Array{Tuple{Int64, Int64}, 1}()
    for tweet in this_agent.feed
        if abs(tweet.opinion - this_agent.opinion) > config.opinion_treshs.unfollow
            if abs(agent_list[tweet.source_agent].opinion - this_agent.opinion) > config.opinion_treshs.unfollow
                # Remove agents with higher follower count than own only with certain probability?
                if (outdegree(graph, tweet.source_agent) / outdegree(graph, agent_idx) > 1 && rand() > 0.5)
                    push!(unfollow_candidates, (tweet.source_agent, indegree(graph, tweet.source_agent)))
                elseif (outdegree(graph, tweet.source_agent) / outdegree(graph, agent_idx) <= 1)
                    push!(unfollow_candidates, (tweet.source_agent, indegree(graph, tweet.source_agent)))
                end
            end
        end
    end
    sort!(unfollow_candidates, by=last)
    for i in 1:min(length(unfollow_candidates), ceil(Int64, indegree(graph,agent_idx) * config.agent_props.unfollow_rate))
        rem_edge!(graph, unfollow_candidates[i][1],agent_idx)
    end
    return state
end

# suppress output of include()
;
