------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- main.lua 
-- Miscallaneous general purpose functions
--
-- Hamester, 2025
------------------------------------------------------------------------------------------------------------------------------------------------------

-- Function for finding joker in the deck by it's unique value
function AST.find_joker_by_unique_val(unique_val) 
    for _, v in ipairs(G.jokers.cards) do
        if v.unique_val == G.GAME.current_round.last_obtained_joker_unique_val then
            return v
        end
    end
    return nil
end

-- Function to determine weather the number is prime, not really optimized but... it will do (?)
function AST.is_prime(n)
    for i = 2, n^(1/2) do
        if (n % i) == 0 then
            return false
        end
    end
    return true
end

------------------------------------------------------------------------------------------------------------------------------------------------------
-- util.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
