ProteinPersistent
---

[![Build Status](https://travis-ci.org/chronchi/ProteinPersistent.jl.svg?branch=master)](https://travis-ci.org/chronchi/ProteinPersistent.jl)
[![Coverage Status](https://coveralls.io/repos/github/chronchi/ProteinPersistent.jl/badge.svg?branch=master)](https://coveralls.io/github/chronchi/ProteinPersistent.jl?branch=master)

Calculate the persistent diagrams of proteins.

# Usage

To calculate the persistence diagram of a protein you can call the function ` returndiagram` and pass as input the path to the protein PDB file.

`julia

pathpdb = path_to_pdbprotein
diagrams = returndiagram(pathpdb)
`

As default it will return the 0th and 1st persistence diagram.  
