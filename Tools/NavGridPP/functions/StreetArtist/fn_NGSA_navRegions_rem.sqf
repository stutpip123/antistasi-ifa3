/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from navRegions

Arguments:
    <LOCATION> _navRegions
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct

Return Value:
    <BOOLEAN> true if deleted, false if not found.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    private _navGrid = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGrid;
*/
params [
    ["_navRegions",0],//ToDo
    ["_roadStruct",[],[ [] ]]
];

private _pos = getPos (_roadStruct#0);
private _region = str [floor (_pos#0 / 100),floor (_pos#1 / 100)];
private _items = _navRegions getOrDefault [_region,[]];
private _index = _items find [_pos,_roadStruct];
_items deleteAt _index;     // No need to set after deletion.

_index != -1;
