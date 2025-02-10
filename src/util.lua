-- Azzy's Silly Trinkets (AST)
-- util.lua 

function AST.is_prime(n)
    for i = 2, n^(1/2) do
        if (n % i) == 0 then
            return false
        end
    end
    return true
end
