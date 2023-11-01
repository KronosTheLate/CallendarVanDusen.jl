module CallendarVanDusen

include("root_finding.jl")
"""
    CVD

Alias for `CallendarVanDusen`. Intented usage:
- `CVD.R`
- `CVD.t`
"""
const CVD = CallendarVanDusen
export CVD

"""
    R(t, R0)
    R(t, R0; A, B, C)

Calculate the resistance (in Ohm's) of a 
Platinum Resistive Thermometer (PRT) at a 
given temperature `t` (intepreted as °C), according to the 
Callendar Van Dusen equation. The second argument `R0` is the 
resistance at 0°C, and is typically used in the naming of 
the PRT. For example, for a PRT100, R0 = 100.

The coefficients A, B, and C that enter the equation can be set as 
keyword arguments. They do however have reasonable default values. 
Quoting from [1]:
> Typically, industrial PRTs have a nominal alpha value of
> `α = 3.85 × 10-3 per °C`.
> For this grade of PRT, standard EN 60751:1995 provides
> values for the coefficients of:
> - A = 3.9083 × 10⁻³ °C⁻¹
> - B = -5.775 × 10⁻⁷ °C⁻²
> - C = -4.183 × 10⁻¹² °C⁻⁴

[1]: Source 1 in `https://en.wikipedia.org/wiki/Callendar-Van_Dusen_equation`.

# Examples
```jldoctest
julia> CVD.R(0, 100)
100.0
```
"""
function R(t, R0; A=3.9083e-3, B=-5.775e-7, C=-4.183e-12)  # Coefficients according to ASTM 1137   and    IEC 60751
    if -200 ≤ t ≤ 0
        return R0 * (1 + A * t + B * t^2 + C * (t - 100) * t^3)
    elseif 0 < t ≤ 661
        return R0 * (1 + A * t + B * t^2)
    else
        throw(ArgumentError("Temperature t (=$t) must be between -200°C and 661°C"))
    end
end


# _R′ is an internal function used 
# for finding temperature via root-finding.
# It is defined as dR/dt.
function _R′(t, R0; A, B, C)
    if -200 ≤ t ≤ 0
        return R0 * (A + B * 2t + C * 4t^3 - 300C*t^2)
    elseif 0 < t ≤ 661
        return R0 * (A + B * 2t)
    else
        throw(ArgumentError("Temperature t (=$t) must be between -200°C and 661°C"))
    end
end

"""
    t(R_meas, R0)
    t(R_meas, R0; A, B, C)

Calculate the temperature that would result in a resistance `R_meas` 
for a Platinum Resistive Thermometer (PRT), according to the 
Callendar Van Dusen equation. The second argument `R0` is 
the resistance at 0°C, and is typically used in the naming 
of the PRT. For example, for a PRT100, R0 = 100.

The output temperature is given in units of °C.

The coefficients A, B, and C that enter the equation can be set as 
keyword arguments. They do however have reasonable default values. 
Quoting from [1]:
> Typically, industrial PRTs have a nominal alpha value of
> `α = 3.85 × 10-3 per °C`.
> For this grade of PRT, standard EN 60751:1995 provides
> values for the coefficients of:
> - A = 3.9083 × 10⁻³ °C⁻¹
> - B = -5.775 × 10⁻⁷ °C⁻²
> - C = -4.183 × 10⁻¹² °C⁻⁴

[1]: Source 1 in `https://en.wikipedia.org/wiki/Callendar-Van_Dusen_equation`.

# Examples
```jldoctest
julia> CVD.t(100, 100)
0.0
```
"""
function t(R_meas, R0; A=3.9083e-3, B=-5.775e-7, C=-4.183e-12)
    #? When f(t)=0, we have found the temperature that would give the measured R
    f(t) = R(t, R0; A, B, C) - R_meas
    f′(t) = _R′(t, R0; A, B, C)
    x = _find_roots(f, f′, 0.0)
    return x
end

#= 
This version uses Roots. I replaced it with a simple 
internal implementation of newtons method for root-finding

import Roots: find_zeros

function old_t(R_meas, R0; A=3.9083e-3, B=-5.775e-7, C=-4.183e-12)
    #? When f(t)=0, we have found the temperature that would give the measured R
    f(t) = R(t, R0; A, B, C) - R_meas
    zeros_ = find_zeros(f, -200 |> float |> nextfloat, 661 |> float |> prevfloat)
    if length(zeros_) == 1
        #? Return value as scalar instead of array. Type-instable, but convenient
        return only(zeros_)
    elseif length(zeros_) == 0
        @warn "No temperature found that would give a resistance of $R. Returning an empty Vector"
    else
        @warn "Found multiple temperatures that would give the measured resistance.\nReturning all $(length(zeros_)) in a Vector"
    end
    return zeros_
end
=#

end
