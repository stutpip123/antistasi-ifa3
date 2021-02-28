/*
Maintainer: Caleb Serafin
    Generates a region lookup table for navGridHM positions. This allows fast fetching of nearMarkers to a map point.
    The lookup table does not create any references to the original navGridHM.

Arguments:
    <navGridHM>

Return Value:
    <HASHMAP> same _navRegions as found in localNamespace >> "A3A_NGPP" >> "NavRegions".
        Each var element: <Array<Pos> navGridHM element pos> bucket

Scope: Client, Global Arguments, Local Effect
Environment: Any
Public: Yes

Example:
    private _navRegions = [_navGridHM] call A3A_fnc_NGSA_navRegions_generate;
*/
params [
    "_navGridHM"
];

private _navRegions = createHashMap;
[localNamespace,"A3A_NGPP","NavRegions",_navRegions] call Col_fnc_nestLoc_set;

{
    private _region = [floor (_x#0 / 100),floor (_x#1 / 100)];
    if (_region in _navRegions) then {
        (_navRegions get _region) pushBack _x;
    } else {
        _navRegions set [_region,[_x]];
    };
} forEach +(keys _navGridHM);

_navRegions
