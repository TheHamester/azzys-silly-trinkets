------------------------------------------------------------------------------------------------------------------------------------------------------
-- Azzy's Silly Trinkets (AST)
------------------------------------------------------------------------------------------------------------------------------------------------------
-- lua_hooks.lua 
-- Functions facilitating creating hooks for in-game functions
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

------------------------------------------------------------------------------------------------------------------------------------------------------
-- lua_hooks.lua End
------------------------------------------------------------------------------------------------------------------------------------------------------
