/*
Maintainer: Caleb Serafin
    Gets the closest road struct within 100m radius of pos.

Arguments:
    <LOCATION> _navRegions
    <POS2D | POSAGL> map position.
Return Value:
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct If Found   |  <ARRAY> Empty array if not found.

Scope: Client, Global Arguments, Local Effect
Environment: Unscheduled
Public: Yes

Example:
    [_navRegions,_pos] call A3A_fnc_NGSA_navRegions_getStruct.
*/
params [
    ["_navRegions",0],//ToDo
    ["_pos",[], [ [] ]]
];
private _filename = "fn_NGSA_navRegions_getStruct";

if (_pos isEqualTo A3A_NG_const_emptyArray) exitWith {
    [1,"Position not provided.",_filename] call A3A_fnc_log;
};

private _regionPos = [floor (_pos#0 / 100),floor (_pos#1 / 100)];
private _regionRange = [];
for "_j" from -1 to 1 do {
    for "_k" from -1 to 1 do {  // Does not matter if it goes out of map range, the getVariable will just return empty array asif it were empty.
        _regionRange pushBack (_regionPos vectorAdd [_j,_k] select A3A_NG_const_pos2DSelect);
    };
};

private _structs = [];
{
    _structs append (_navRegions getOrDefault [str _x,[]]);
} forEach _regionRange;

private _closestStruct = [];
private _closestDistance = 1e6;
{
    private _distance = getPosWorld (_x#0) distance2D _pos;
    if (_distance < _closestDistance) then {
        _closestDistance = _distance;
        _closestStruct = _x;
    };
} forEach _structs;

_closestStruct;
