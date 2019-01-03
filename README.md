ProteinPersistent
---

[![Build Status](https://travis-ci.org/chronchi/ProteinPersistent.jl.svg?branch=master)](https://travis-ci.org/chronchi/ProteinPersistent.jl)
[![Coverage Status](https://coveralls.io/repos/github/chronchi/ProteinPersistent.jl/badge.svg?branch=master)](https://coveralls.io/github/chronchi/ProteinPersistent.jl?branch=master)

Calculate the persistent diagrams of proteins.

# Installation

Follow the steps below to install the package.

```julia
using Pkg
Pkg.add("https://github.com/chronchi/ProteinPersistent.jl")
```

# Usage

## Persistence Diagrams

To calculate the persistence diagram of a protein you can call the function ` returndiagram` and pass as input the path to the protein PDB file.

```julia
pathpdb = path_to_pdbprotein
diagrams = returndiagram(pathpdb)
```

As default it will return the 0th and 1st persistence diagram using the Vietoris-Rips complex.
To specify the dimensions to be calculated you can pass as an optional argument as below.

```julia
pathpdb = path_to_pdbprotein
diagrams = returndiagram(pathpdb, maxdim = k)
```
The above snippet will return all the persistence diagrams up to the dimension `k`.
The default `k` is 1.

## Protein Coordinates

If you want to get the coordinates and use another persistent homology algorithm you can call `coordpdb` and as previously pass the protein PDB file path.

```julia
pathpdb = path_to_pdbprotein
proteincoordinates = coordpdb(pathpdb)
```

The output will be a DataFrame with five columns, where the first three columns are the atom coordinates from the protein, the fourth column corresponds to the respective atoms and the van der Waals radii are given in the last column.
The values can be see as in the following code.

```julia
pathpdb = path_to_pdbprotein
proteincoordinates = coordpdb(pathpdb)

# return the 1st coordinate
proteincoordinates[:coord1]

# return the 2nd coordinate
proteincoordinates[:coord2]

# return the 3rd coordinate
proteincoordinates[:coord3]

# return the respective atom
proteincoordinates[:atom_name]

# return the respective van der Waals radius
proteincoordinates[:radius]
```
