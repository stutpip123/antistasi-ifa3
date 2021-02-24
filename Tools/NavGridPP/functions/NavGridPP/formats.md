
# NavFlatHM
_Speedy and fast access version of navGridDB_
```
<HASHMAP<         NavFlatHM, referenced by serialisation of position.
  <POS2D|POSAGL>    Road pos.
  <SCALAR>          Island ID.
  <BOOLEAN>         isJunction.
  <ARRAY<           Connections:
    <STRING>          Serialisation of connected road position.
    <SCALAR>          Road type Enumeration. {TRACK = 0; ROAD = 1; MAIN ROAD = 2} at time of writing.
    <SCALAR>          True driving distance to connection, includes distance of roads swallowed in simplification.
  >>
>>
```


# NavMetaIslands
_Speedy and fast access version of navGridDB_
```
<ARRAY<           NavFlatHM, referenced by serialisation of position.
  ARRAY<STRING>     Serialisation of road position for each Island.
>>
```

# navGrid
_From road extraction and distance application._
```
<ARRAY<           navGrid:
  <OBJECT>          Road
  <ARRAY<OBJECT>>     Connected roads.
  <ARRAY<SCALAR>>     True driving distance in meters to connected roads.
>>
```

# navIslands
_Seperation of navGrid into islands._
```
<ARRAY<           navIslands:
  <ARRAY<           A single road network island:
    <OBJECT>        Road
    <ARRAY<OBJECT>>   Connected roads.
    <ARRAY<SCALAR>>   True driving distance in meters to connected roads.
  >>
>>
```

# navGrdDB
_Desired Output format used by Antistasi._
```
<ARRAY<           navGridDB:
  <POS2D|POSAGL>    Road pos.
  <SCALAR>          Island ID.
  <BOOLEAN>         isJunction.
  <ARRAY<           Connections:
    <SCALAR>          Index in navGridDB of connected road.
    <SCALAR>          Road type Enumeration. {TRACK = 0; ROAD = 1; MAIN ROAD = 2} at time of writing.
    <SCALAR>          True driving distance to connection, includes distance of roads swallowed in simplification.
  >>
  <STRING|SCALAR>   Road name or 0 if name not needed for finding road (Ie. name is need if roadAt cannot find road). Will be deprecated and removed soon.
>>
```
