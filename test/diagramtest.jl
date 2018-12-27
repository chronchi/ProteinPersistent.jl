# file test/diagramtest.jl

srcroot = "$(dirname(@__FILE__))"

using ProteinPersistent
using Test

# tests the ProteinPersistent module with proteins from the PDB archive

pdbs = readdir("$srcroot/proteins/")

for pdb in pdbs
    # calculate the zeroth and first persistence diagram
    diagrams = returndiagram("$srcroot/proteins/" * pdb)
    # check whether it returns it as an array with 2 columns and
    # as a float64 array
    @test typeof(diagrams[1]) == Array{Float64, 2}
    @test typeof(diagrams[2]) == Array{Float64, 2}
end
