/*
Maintainer: Caleb Serafin
    Gets the closest road struct within 9 regions centred on pos.

Arguments:
    <HASHMAP> _posRegionHM
    <POS2D> map position.

Return Value:
    <POS2D> Pos of closest navGridHM element If Found   |  <ARRAY> Empty array if not found.

Scope: Client, Global Arguments, Local Effect
Environment: Any.
Public: Yes

Example:
    [_posRegionHM,_pos] call allAdjacent.
*/
params [
    "_posRegionHM",
    "_pos"
];

private _region_x = floor (_pos#0 / 100) -1;
private _centreRegion_y = floor (_pos#1 / 100);

// Unrolled loop since it is small and finite.
private _structs = [];
_structs append (_posRegionHM get [_region_x,_centreRegion_y-1]);    // Does not matter if it goes out of map range, append handles nil.
_structs append (_posRegionHM get [_region_x,_centreRegion_y  ]);
_structs append (_posRegionHM get [_region_x,_centreRegion_y+1]);
_region_x = _region_x +1;
_structs append (_posRegionHM get [_region_x,_centreRegion_y-1]);
_structs append (_posRegionHM get [_region_x,_centreRegion_y  ]);
_structs append (_posRegionHM get [_region_x,_centreRegion_y+1]);
_region_x = _region_x +1;
_structs append (_posRegionHM get [_region_x,_centreRegion_y-1]);
_structs append (_posRegionHM get [_region_x,_centreRegion_y  ]);
_structs append (_posRegionHM get [_region_x,_centreRegion_y+1]);

_structs;
