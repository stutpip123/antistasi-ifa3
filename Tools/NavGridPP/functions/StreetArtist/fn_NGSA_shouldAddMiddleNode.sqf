/*
Maintainer: Caleb Serafin
    Checks if two navGrid points are connected by road without going through other points or bridging gaps.
    If the two points are on roads, but not connected. It returns true, indicating that a middle road should be added.

Arguments:
    <HASHMAP> The first argument
    <POS3D> Position 1
    <POS3D> Position 2

Return Value:
    <BOOL> True if middle point is needed, false if it is not needed.

Scope: Local Arguments
Environment: Scheduled
Public: No
Dependencies:
    <ARRAY<STRING>> A3A_NG_const_roadTypeEnum
    <ARRAY> A3A_NG_const_emptyArray
    <HASHMAP> A3A_NG_const_hashMap

Example:
    [_navGridHM, _leftPos, _rightPos] call A3A_fnc_NGSA_shouldAddMiddleNode;
*/
params [
    ["_navGridHM",0,[A3A_NG_const_hashMap]],
    "_leftPos",
    "_rightPos"
];

private _leftRoad = nearestTerrainObjects [_leftPos, A3A_NG_const_roadTypeEnum, 0, false, true];
private _rightRoad = nearestTerrainObjects [_rightPos, A3A_NG_const_roadTypeEnum, 0, false, true];
if (_leftRoad isEqualTo A3A_NG_const_emptyArray || _rightRoad isEqualTo A3A_NG_const_emptyArray) exitWith {
    systemChat ("They are offroad.");
    false;   // If one is already off a road, then there is no need to add a middle pos.
};
_leftRoad = _leftRoad#0;
_rightRoad = _rightRoad#0;

private _checkedPositionsHM = createHashMapFromArray [[getPos _leftRoad select A3A_NG_const_pos2DSelect,true]];
private _nextRoads = [_leftRoad];
private _addMiddleNode = true;
while {count _nextRoads > 0} do {
    _nextRoads = flatten (_nextRoads apply {
        private _current = _x;
        roadsConnectedTo [_current,true] select {
            _current in roadsConnectedTo [_x,true] &&   // Checks return connection
            !((getPos _x select A3A_NG_const_pos2DSelect) in _checkedPositionsHM)
        };
    });
    _checkedPositionsHM insert ( _nextRoads apply {[getPos _x select A3A_NG_const_pos2DSelect,true]} );
    if (_rightRoad in _connectedRoads) exitWith {
        systemChat ("They are connected!.");
        _addMiddleNode = false;
    };
    _nextRoads = _nextRoads select {!((getPos _x select A3A_NG_const_pos2DSelect) in _navGridHM)};
};
_addMiddleNode;
