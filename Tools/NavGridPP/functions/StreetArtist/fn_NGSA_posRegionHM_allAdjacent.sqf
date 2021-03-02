/*
Maintainer: Caleb Serafin
    Gets positions within 9 regions centred on pos.
    Much faster than fn_NGSA_posRegionHM_pixelRadius with 100m radius.

Arguments:
    <HASHMAP> _posRegionHM
    <POS2D> map position.

Return Value:
    <POS2D> Pos of closest navGridHM element If Found   |  <ARRAY> Empty array if not found.

Scope: Any
Environment: Any.
Public: Yes

Example:
    [_posRegionHM,_pos] call A3A_fnc_NGSA_posRegionHM_allAdjacent.
*/
params [
    "_posRegionHM",
    "_pos"
];

private _region_x = floor (_pos#0 / 100) -1;
private _region_y_centre = floor (_pos#1 / 100);

// Unrolled loop since it is small and finite.
private _structs = [];
_structs append (_posRegionHM get [_region_x,_region_y_centre-1]);    // Does not matter if it goes out of map range, append handles nil.
_structs append (_posRegionHM get [_region_x,_region_y_centre  ]);
_structs append (_posRegionHM get [_region_x,_region_y_centre+1]);
_region_x = _region_x +1;
_structs append (_posRegionHM get [_region_x,_region_y_centre-1]);
_structs append (_posRegionHM get [_region_x,_region_y_centre  ]);
_structs append (_posRegionHM get [_region_x,_region_y_centre+1]);
_region_x = _region_x +1;
_structs append (_posRegionHM get [_region_x,_region_y_centre-1]);
_structs append (_posRegionHM get [_region_x,_region_y_centre  ]);
_structs append (_posRegionHM get [_region_x,_region_y_centre+1]);

_structs;
