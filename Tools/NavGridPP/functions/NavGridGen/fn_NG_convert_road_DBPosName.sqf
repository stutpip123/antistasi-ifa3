/*
Maintainer: Caleb Serafin
    Converts a road into a save position, this handles overlapping roads at that position.

Arguments:
    <OBJECT> road, objNull if road cannot be found

Return Value:
    <POS2D|POSAGL> DB position of road.
    <STRING> Name of road | <SCALAR> 0, No name needed

Scope: Any, Global Arguments
Environment: Any
Public: No

Example:
    private _road = nearestTerrainObjects [getPosWorld player,A3A_NG_const_roadTypeEnum,1000] #0;
    private _roadPosName = _road call A3A_NG_convert_road_DBPosName;
    [_roadPosName#0, _roadPosName#1] call A3A_fnc_NG_convert_DBStruct_road;   // original road
*/
params ["_road"];

private _pos = getPosWorld _road;
private _name = 0;      // Type may change to string if name is required
if (isNull roadAt _pos && !(roadAt _pos isEqualTo _road)) then {
    _pos = _pos select A3A_NG_const_pos2DSelect;
};
if (isNull roadAt _pos && !(roadAt _pos isEqualTo _road)) then {    // Now we go all out and try a bunch of values from an offset matrix.
    {
        private _newPos = _pos vectorAdd _x select A3A_NG_const_pos2DSelect;  // vectorAdd puts the z back
        if (roadAt _newPos isEqualTo _road) exitWith { _pos = _newPos };   // isEqual check in case a different road was found.
    } forEach A3A_NG_const_posOffsetMatrix;
};
if (isNull roadAt _pos && !(roadAt _pos isEqualTo _road)) then {
    _name = str _road;
};
[_pos,_name];
