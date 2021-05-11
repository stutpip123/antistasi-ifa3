/*
Maintainer: Caleb Serafin
    If two real roads are connected with the navGrid, but are not connected IRL, they have an intermediary node added in the middle.
    This is required by the AI systems to determine whether they need a different path finding technique.

Arguments:
  HASHMAP<          NavFlatHM
    POS2D             Key is Road pos.
    ARRAY<
        <POS2D>           Road pos.
        <SCALAR>          Island ID.
        <BOOLEAN>         isJunction.
        <ARRAY<           Connections:
        <POS2D>           Connected road position.
        <SCALAR>          Road type Enumeration. {TRACK = 0; ROAD = 1; MAIN ROAD = 2} at time of writing.
        <SCALAR>          True driving distance to connection, includes distance of roads swallowed in simplification.
        >>
    >
>

Return Value:
    <ARRAY> the midpoint if is was added. empty if nothing was added.

Scope: Local Arguments, Local Effect
Environment: Scheduled
Public: Yes/No
Dependencies:
    <ARRAY<STRING>> A3A_NG_const_roadTypeEnum
    <ARRAY> A3A_NG_const_emptyArray

Example:
    [_leftStruct,_rightStruct,_navGridHM,_posRegionHM] call A3A_fnc_NGSA_checkFix_forcedConnection;
*/

params ["_myStruct","_otherStruct","_navGridHM","_posRegionHM"];   //  [_pos2D,[_pos2D,_islandID,_isJunction,[_conPos2D,_roadEnum,_distance]]]

private _myPos = _myStruct#0;
private _islandID = _myStruct#1;
private _myConnections = _myStruct#3;

private _otherPos = _otherStruct#0;
if (_myConnections findIf {(_x#0) isEqualTo _otherPos} == -1) exitWith {};
private _middlePos = _myPos vectorAdd _otherPos vectorMultiply 0.5 select A3A_NG_const_pos2DSelect;

if (
    nearestTerrainObjects [_myPos, A3A_NG_const_roadTypeEnum, A3A_NG_const_positionInaccuracy, false, true] isEqualTo A3A_NG_const_emptyArray ||
    {nearestTerrainObjects [_otherPos, A3A_NG_const_roadTypeEnum, A3A_NG_const_positionInaccuracy, false, true] isEqualTo A3A_NG_const_emptyArray}  // If the returned array has items, it means the road exists.
) exitWith {};
private _roadEnum = _x#1;
private _halfDistance = (_x#2) / 2;
private _otherStruct = (_navGridHM get _otherPos);

private _middleStruct = [_middlePos,_islandID,false,[]];
[_navGridHM,_posRegionHM,_middlePos,_middleStruct] call A3A_fnc_NGSA_pos_add;    // Island ID will not be accurate.

private _markerStructs = [localNamespace,"A3A_NGPP","draw","markers_road", 0] call Col_fnc_nestLoc_get;
private _name = "A3A_NG_Dot_"+str _middlePos;
if !(_markerStructs set [_name,true]) then {
    createMarkerLocal [_name,_middlePos];
};
_name setMarkerTypeLocal "mil_dot";
_name setMarkerSizeLocal [A3A_NGSA_dotBaseSize,A3A_NGSA_dotBaseSize];
_name setMarkerColor "ColorBlack";

[_middleStruct,_myStruct,_roadEnum,_halfDistance] call A3A_fnc_NGSA_toggleConnection;
[_middleStruct,_otherStruct,_roadEnum,_halfDistance] call A3A_fnc_NGSA_toggleConnection;

[_myStruct,_otherStruct,_roadEnum] call A3A_fnc_NGSA_toggleConnection;
