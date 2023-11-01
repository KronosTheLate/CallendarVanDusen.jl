using CallendarVanDusen
using Test

#TODO: Set up tests

@testset "CallendarVanDusen.jl" begin
    @test CVD.R(0, 100) == 100.0
    @test CVD.t(100, 100) == 0.0
end
