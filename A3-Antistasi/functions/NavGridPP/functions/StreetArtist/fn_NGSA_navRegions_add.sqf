/*
Maintainer: Caleb Serafin
    Adds a _roadStruct reference to navRegions

Arguments:
    <LOCATION> _navRegions
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct

Return Value:
    <BOOLEAN> true if added.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    private _navGrid = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGrid;
*/
params [
    ["_navRegions",locationNull,[ locationNull ]],
    ["_roadStruct",[],[ [] ]]
];

private _pos = getPos (_roadStruct#0);
private _region = str [floor (_pos#0 / 100),floor (_pos#1 / 100)];
private _items = _navRegions getVariable [_region,[]];
_items pushBack _roadStruct;
_navRegions setVariable [_region,_items];

true;