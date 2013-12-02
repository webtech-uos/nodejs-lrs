# Test data

The test data folder contains test cases for various api versions. 

# File structure

- `1.0.0` data for API version 1.0.0
    - `invalid` invalid data
        - `statement` invalid statement cases
    - `valid`
        - `statement` valid statement cases
            - `minimal-with-variations` the minimal statements with systematic variations for agents, verbs and objects
            - `various-verbs` real world examples from the public lrs at tincan.com, representing different verbs

# File format

All files are json documents.

# File names

File names should reflect the properties of the file at hand with respect to current directory.

Examples:
- `1.0.0/valid/statement/minimal-with-variations/minimal-agent-group-identified.json` minimal example with an identified group as actor
- `1.0.0/invalid/statement/minimal-missing-actor.json` invalid example derived from minimal statement but actor is missing

