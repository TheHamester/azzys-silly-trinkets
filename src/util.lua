------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- main.lua 
-- Miscallaneous general purpose functions
--
-- Hamester, 2025
------------------------------------------------------------------------------------------------------------------------------------------------------

LuaHooks = {}

-- Injecting code before the function call, optionally modifying arguments
function LuaHooks.Inject_Head(config)
    local namespace = config.namespace or _G
    local original_func = namespace[config.original_func_name]
    local injected_code = config.injected_code or function(...) end

    namespace[config.original_func_name] = function(...)
        local context = { arguments = { ... } }
        injected_code(context, ...)
        return original_func(unpack(context.arguments))
    end
end

-- Injecting code after the function call, optionally modifying the return value
function LuaHooks.Inject_Tail(config)
    local namespace = config.namespace or _G
    local original_func = namespace[config.original_func_name]
    local injected_code = config.injected_code or function(...) end

    namespace[config.original_func_name] = function(...)
        local ret = original_func(...)
        ret = injected_code(ret, ...) or ret
        return ret
    end
end

-- Injecting code both before and after, optionally modifying arguments or the return value
function LuaHooks.Inject(config)
    local namespace = config.namespace or _G
    local original_func = namespace[config.original_func_name]
    local injected_code_head = config.injected_code_head or function(...) end
    local injected_code_tail = config.injected_code_tail or function(...) end
    namespace[config.original_func_name] = function(...)
        local context = { arguments = { ... } }
        injected_code_head(context, ...)

        local ret = original_func(unpack(context.arguments))
        context.ret = ret
        ret = injected_code_tail(context, ...) or ret
        return ret
    end
end

-- Redirecting the function call of a target function during some function to a replacement function
function LuaHooks.Redirect(config)
    local target_func_namespace = config.target_func_namespace or _G
    local target_func_old = target_func_namespace[config.target_func_name]

    LuaHooks.Inject {
        namespace = config.original_func_namespace,
        original_func_name = config.original_func_name,
        argument_count = config.original_func_argument_count,
        injected_code_head = function(...)
            local context = config.init_context(...)
            target_func_namespace[config.target_func_name] = function(...)
                context.target_func_old = target_func_old
                config.replacement_func(context, ...)
            end
        end,
        injected_code_tail = function(...)
            target_func_namespace[config.target_func_name] = target_func_old
        end
    }
end


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
