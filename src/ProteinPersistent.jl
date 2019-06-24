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
const warnings = PyNULL()

function __init__()
    copy!(warnings, pyimport("warnings"))
    warnings[:filterwarnings]("ignore")
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
    d = Dict('H' => 1.2, 'C' => 1.7, 'N' => 1.55, 'O' => 1.52,
             'S' => 1.8, 'P' => 1.8, 'M' => 1.73)
    return d[atom_name]
end

# return the coordinates, atom sequence and van der wall radii as a Dataframe
function coordpdb(filename; kwargs...)

    atoms = ["CA", "C", "N", "H"]

    for (p,v) in kwargs
        if p == :atoms
            atoms = v
        end
    end

    parser = pdb[:PDBParser]()
    structure = parser[:get_structure]("", filename)

    df = DataFrame(Any, 0, 5)

    for atom in structure[:get_atoms]()
        coordinates = atom[:get_coord]()
        name_atom = atom[:get_name]()
        if name_atom in atoms
            atom_short = atom_shortname(atom[:get_name]())
            radius = vanderWaalsRadius(atom_short)
            list_to_df = [coordinates[1], coordinates[2],
                          coordinates[3], name_atom, radius]
            push!(df, list_to_df)
        end
    end
    name = zip([:x1, :x2, :x3, :x4, :x5], [:coord1, :coord2, :coord3,
                                           :atom_name, :radius])
    rename!(df, f => t for (f,t) = name)
    return df
end

# returns the zeroth and first persistent diagram of the given pdb file
function returndiagram(pdbfile::String; kwargs...)

    maxdim = 1
    for (p,v) in kwargs
        if p == :maxdim
            maxdim = v
        end
    end

    # get the coordinates of the protein
    coordinates = coordpdb(pdbfile)
    # convert to an array
    coordinates = Matrix{Float64}(coordinates[[:coord1, :coord2, :coord3]])
    # calculate the 0th and 1st persistent diagram using Vietoris Rips
    diagrams = ripser[:ripser](coordinates, maxdim=maxdim)
    return diagrams["dgms"]
end

end
