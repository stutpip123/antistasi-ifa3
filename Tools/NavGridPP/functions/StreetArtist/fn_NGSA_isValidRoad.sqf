/*
Maintainer: Caleb Serafin
    Checks if a position can allow a road node. There must be a road under the pos and it must be in A3A_NG_const_roadTypeEnum.
    Always returns true if A3A_NGSA_nodeOnlyOnRoad is false.

Return Value:
    <BOOLEAN> Whether it is a valid road pos.

Scope: Any
Environment: Any
Public: No

Dependencies:
    <SCALAR> A3A_NG_const_roadTypeEnum Road types.

Example:
    [_worldPos] call A3A_fnc_NGSA_isValidRoad;
*/
params ["_pos"];

if !(A3A_NGSA_nodeOnlyOnRoad) exitWith {true;};
private _road = roadAt _pos;
if (isNull _road) exitWith {false;};
getRoadInfo _road #0 in A3A_NG_const_roadTypeEnum;
