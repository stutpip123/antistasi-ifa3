/*
Maintainer: Caleb Serafin
    Converts a road into a save position.

Arguments:
    <OBJECT> road.

Return Value:
    <POS2D|POSAGL> DB position of road.

Scope: Any, Global Arguments
Environment: Any
Public: No

Example:
    private _road = nearestTerrainObjects [getPos player,["MAIN ROAD","ROAD","TRACK"],1000] #0;
    private _roadPosName = _road call A3A_NG_convert_road_pos;
*/
params ["_road"];

private _pos = getPos _road;
if (isNull roadAt _pos && !(roadAt _pos isEqualTo _road)) then {
    _pos = _pos select A3A_NG_const_pos2DSelect;
};
if (isNull roadAt _pos && !(roadAt _pos isEqualTo _road)) then {    // Now we go all out and try a bunch of values from an offset matrix.
    {
        private _newPos = _pos vectorAdd _x select A3A_NG_const_pos2DSelect;  // vectorAdd puts the z back
        if (roadAt _newPos isEqualTo _road) exitWith { _pos = _newPos };   // isEqual check in case a different road was found.
    } forEach A3A_NG_const_posOffsetMatrix;
};
_pos;
