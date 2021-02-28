/*
Maintainer: Caleb Serafin
    Gets the closest road struct within 9 regions centred on pos.

Arguments:
    <HASHMAP> _navRegions
    <POS2D> map position.

Return Value:
    <POS2D> Pos of closest navGridHM element If Found   |  <ARRAY> Empty array if not found.

Scope: Client, Global Arguments, Local Effect
Environment: Unscheduled, make sure operation finishes before addition or removal.
Public: Yes

Example:
    [_navRegions,_pos] call A3A_fnc_NGSA_navRegions_getPos.
*/
params [
    "_navRegions",
    "_pos"
];

private _region_x = floor (_pos#0 / 100) -1;
private _centreRegion_y = floor (_pos#1 / 100);

// Unrolled loop since it is small and finite.
private _structs = [];
_structs append (_navRegions get [_region_x,_centreRegion_y-1]);    // Does not matter if it goes out of map range, append handles nil.
_structs append (_navRegions get [_region_x,_centreRegion_y  ]);
_structs append (_navRegions get [_region_x,_centreRegion_y+1]);
_region_x = _region_x +1;
_structs append (_navRegions get [_region_x,_centreRegion_y-1]);
_structs append (_navRegions get [_region_x,_centreRegion_y  ]);
_structs append (_navRegions get [_region_x,_centreRegion_y+1]);
_region_x = _region_x +1;
_structs append (_navRegions get [_region_x,_centreRegion_y-1]);
_structs append (_navRegions get [_region_x,_centreRegion_y  ]);
_structs append (_navRegions get [_region_x,_centreRegion_y+1]);

private _closestPos = [];
private _closestDistance = 1e6;
{
    private _distance = _x distance2D _pos;
    if (_distance < _closestDistance) then {
        _closestDistance = _distance;
        _closestPos = _x;
    };
} forEach _structs;

_closestPos;
