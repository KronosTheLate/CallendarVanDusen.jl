# CallendarVanDusen
A simple Julia package that implements the [Callendar Van Dusen equation](https://en.wikipedia.org/wiki/Callendar%E2%80%93Van_Dusen_equation). This equation applies to Platinum Resistive Thermometers (PRTs), and related temperature and resistance. 

This package does not export the main functions `R` and `t`, due to possibility of name-clashing. It instead exports `CVD` as an alias for `CallendarVanDusen`, allowing users to write `CVD.R` and `CVD.t` to access the functions.

## Docstrings and explanation
There is really not much to this package. In this section we will look at the docstrings, and give a little interpretation about what it means.

First, we load the package
```julia
julia> using CallendarVanDusen
```

The first function is `CVD.R`, which returnes the resistance (in Ohm's), for a given temperature. Let's look at its docstring:
```
help?> CVD.R
  R(t, R0)
  R(t, R0; A, B, C)

  Calculate the resistance (in Ohm's) of a Platinum Resistive
  Thermometer (PRT) at a given temperature t (intepreted as °C),
  according to the Callendar Van Dusen equation. The second
  argument R0 is the resistance at 0°C, and is typically used in
  the naming of the PRT. For example, for a PRT100, R0 = 100.

  The coefficients A, B, and C that enter the equation can be
  set as keyword arguments. They do however have reasonable
  default values. Quoting from [1]:

  │  Typically, industrial PRTs have a nominal alpha
  │  value of α = 3.85 × 10-3 per °C. For this grade of
  │  PRT, standard EN 60751:1995 provides values for 
  |  the coefficients of:
  │
  │    •  A = 3.9083 × 10⁻³ °C⁻¹
  │
  │    •  B = -5.775 × 10⁻⁷ °C⁻²
  │
  │    •  C = -4.183 × 10⁻¹² °C⁻⁴

  [1]: Source 1 in
  https://en.wikipedia.org/wiki/Callendar-Van_Dusen_equation.

  Examples
  ≡≡≡≡≡≡≡≡≡≡

  julia> CVD.R(0, 100)
  100.0
```

So let's say we have a given PRT. It will have a resistance at 0 °C, denoted `R0`. `R0` is typically given in the datasheet, and determines the second argument to `CVD.R`. So we can find the resistance at any temperature `t` within the valid range of (-200 °C, 661 °C) by running `CVD.R(t, R0)`, assuming that the PRT is up to the relevant industry standard.

The next relevant function is `CVD.t`. Let's check its docstring:
```
help?> CVD.t
  t(R_meas, R0)
  t(R_meas, R0; A, B, C)

  Calculate the temperature that would result in a resistance R_meas
  for a Platinum Resistive Thermometer (PRT), according to the
  Callendar Van Dusen equation. The second argument R0 is the
  resistance at 0°C, and is typically used in the naming of the PRT.
  For example, for a PRT100, R0 = 100.

  The output temperature is given in units of °C.

  The coefficients A, B, and C that enter the equation can be set as
  keyword arguments. They do however have reasonable default values.
  Quoting from [1]:

  │  Typically, industrial PRTs have a nominal alpha
  │  value of α = 3.85 × 10-3 per °C. For this grade of
  │  PRT, standard EN 60751:1995 provides values for 
  |  the coefficients of:
  │
  │    •  A = 3.9083 × 10⁻³ °C⁻¹
  │
  │    •  B = -5.775 × 10⁻⁷ °C⁻²
  │
  │    •  C = -4.183 × 10⁻¹² °C⁻⁴

  [1]: Source 1 in
  https://en.wikipedia.org/wiki/Callendar-Van_Dusen_equation.

  Examples
  ≡≡≡≡≡≡≡≡≡≡

  julia> CVD.t(100, 100)
  0.0
```

`CVD.t(R_meas, R0)` finds and returns the temperature `t` that corresponds to a resistance of `R_meas`. It does this by solving `CVD.R(t, R0) - R_meas = 0` for `t`, numerically.

If anything is still confusing, do not hesitate to open up an issue about what is confusing.