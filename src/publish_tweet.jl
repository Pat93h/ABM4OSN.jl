"""
    publish_tweet!(state, tweet_list, agent_idx, tick_nr)
Publish a tweet to the network.
# Arguments
- `state`: a tuple of the current graph and agent_list
- `tweet_list`: List of all published tweets in network
- `agent_idx`: agent index
- `tick_nr`: Number of current simulation tick
See also: [`Config`](@ref), [`Agent`](@ref)
"""
function publish_tweet!(
    state::Tuple{AbstractGraph, AbstractArray}, tweet_list::AbstractArray, agent_idx::Integer,
    tick_nr::Integer=0
)
    graph, agent_list = state
    this_agent = agent_list[agent_idx]
    tweet_opinion = this_agent.opinion + 0.1 * (2 * rand() - 1)
    # upper opinion limit is 1
    if tweet_opinion > 1
        tweet_opinion = 1.0
    # lower opinion limit is -1
    elseif tweet_opinion < -1
        tweet_opinion = -1.0
    end
    tweet = Tweet(tweet_opinion, length(outneighbors(graph, agent_idx)), agent_idx, tick_nr)

    # send tweet to each outneighbor
    tweet_published = false
    for neighbor in outneighbors(graph, agent_idx)
        if(tweet.weight >= agent_list[neighbor].feed_min_weight)
            push!(agent_list[neighbor].feed, tweet)
            tweet_published = true
        end
    end
    if tweet_published
        push!(tweet_list, tweet)
    end
    return state, tweet_list
end

# suppress output of include()
;
