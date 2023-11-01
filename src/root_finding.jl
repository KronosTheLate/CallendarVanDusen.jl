
function _find_roots(f, f′, x0; atol=0, rtol=0, maxiter=50)
    xmin = -200
    xmax = 661
    counter = 0
    x = x0
    while true
        # f(x) + Δx*f′(x) = 0
        # Δx*f′(x) = -f(x)
        # Δx = -f(x)/f′(x)
        Δx = -f(x)/f′(x)
        x += Δx
        x = x < xmin ? xmin : x  # bound x so as to not error
        x = x > xmax ? xmax : x  # in CVD.R
        counter += 1
        
        isapprox(f(x), 0; atol, rtol) && break
        counter ≥ maxiter  &&  break
    end
    x == xmin  &&  (@warn "The temperature found ($x) is equal to the lower border of valid temperatures.")
    x == xmax  &&  (@warn "The temperature found ($x) is equal to the upper border of valid temperatures.")
    xmin ≤ x ≤ xmax  &&  error("The temperature found ($x) is outside the valid interval (-200, 661)")
    return x
end