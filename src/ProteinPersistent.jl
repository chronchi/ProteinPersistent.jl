# A module that returns the zeroth and first persistent diagram
# of a given protein. It uses the ripser algorithm which utilizes the
# vietoris-rips complex filtration

#__precompile__()

module ProteinPersistent

export returndiagram, valuesvariable, coordpdb

using PyCall
using DataFrames

const ripser = PyNULL()
const pdb = PyNULL()
const re = PyNULL()

function __init__()
    copy!(ripser, pyimport("ripser"))
    copy!(pdb, pyimport("Bio.PDB"))
    copy!(re, pyimport("re"))
end

# define the functions to load the pdb file as a dataframe with
# coordinates, atoms and van der waals radii

# return the shortname of the atom (e.g. CA returns C)
function atom_shortname(s)
    pos = re[:search]("[A-Z]", s)
    pos = pos[:start]()
    return s[pos+1]
end

# return van der Waals radius associated with 'atom_name'
function vanderWaalsRadius(atom_name)
    d = Dict('H' => 1.2, 'C' => 1.7 , 'N' => 1.55, 'O' => 1.52,
             'S' => 1.8, 'P' => 1.8, 'M' => 1.73)
    return d[atom_name]
end

# return the coordinates, atom sequence and van der wall radii as a Dataframe
function coordpdb(filename)

    parser = pdb[:PDBParser]()
    structure = parser[:get_structure]("", filename)

    df = DataFrame(Any, 0, 5)

    for atom in structure[:get_atoms]()
        coordinates = atom[:get_coord]()
        atom_short = atom_shortname(atom[:get_name]())
        radius = vanderWaalsRadius(atom_short)
        list_to_df = [coordinates[1], coordinates[2],
                      coordinates[3], atom_short, radius]
        push!(df, list_to_df)
    end
    return df
end

# define the variables to ripser

mutable struct Variables
    maxdim::Int
end

# define values to our variables
valuesvariable = Variables(1)

# returns the zeroth and first persistent diagram of the given pdb file
function returndiagram(pdbfile::String; maxdim = valuesvariable.maxdim)
    # get the coordinates of the protein
    coordinates = coordpdb(pdbfile)
    # convert to an array
    coordinates = convert(Array{Float64, 2}, coordinates)
    # calculate the 0th and 1st persistent diagram
    diagrams = ripser[:ripser](coordinates, maxdim=maxdim)
    return diagrams["dgms"]
end

end
