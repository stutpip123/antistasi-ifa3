
# navGridHM
_Speedy and fast access version of navGridDB_
```
HASHMAP<          NavFlatHM
  POS2D             Key is Road pos.
  ARRAY<
    <POS2D>           Road pos.
    <SCALAR>          Island ID.
    <BOOLEAN>         isJunction.
    <ARRAY<           Connections:
      <POS2D>         Connected road position.
      <SCALAR>          Road type Enumeration. {TRACK = 0; ROAD = 1; MAIN ROAD = 2} at time of writing.
      <SCALAR>          True driving distance to connection, includes distance of roads swallowed in simplification.
    >>
  >
>
```
`[_pos2D,[_pos2D,_islandID,_isJunction,[_conPos2D,_roadEnum,_distance]]]`
# navRoadHM
_From road extraction and distance application._
```
<HASHMAP<         navGrid:
  <STRING>          Road string.
  <
    <OBJECT>          Road
    <ARRAY<OBJECT>>     Connected roads.
    <ARRAY<SCALAR>>     True driving distance in meters to connected roads.
  >
>>
```
`[_name_,[_road_,_connectedRoads,_connectedDistances]]`

# navIslands
_Seperation of navGrid into islands._
```
ARRAY<           navIslands:
  <ARRAY<           A single road network island:
    <OBJECT>        Road
    <ARRAY<OBJECT>>   Connected roads.
    <ARRAY<SCALAR>>   True driving distance in meters to connected roads.
  >>
>
```

# navGrdDB
_Desired Output format used by Antistasi._
```
ARRAY<           navGridDB:
  <POS2D|POSAGL>    Road pos.
  <SCALAR>          Island ID.
  <BOOLEAN>         isJunction.
  <ARRAY<           Connections:
    <SCALAR>          Index in navGridDB of connected road.
    <SCALAR>          Road type Enumeration. {TRACK = 0; ROAD = 1; MAIN ROAD = 2} at time of writing.
    <SCALAR>          True driving distance to connection, includes distance of roads swallowed in simplification.
  >>
  <STRING|SCALAR>   Road name or 0 if name not needed for finding road (Ie. name is need if roadAt cannot find road). Will be deprecated and removed soon.
>
```
