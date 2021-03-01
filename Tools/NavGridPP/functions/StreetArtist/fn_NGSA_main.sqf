/*
Maintainer: Caleb Serafin
    Starts the StreetArtist Editor.

Return Value:
    <ANY> Undefined

Scope: Clients, Global Arguments, Local Effect
Environment: Scheduled
Public: Yes

Example:
    [] spawn A3A_fnc_NGSA_main;
*/


if (!canSuspend) exitWith {
    throw ["NotScheduledEnvironment","Please execute NG_main in a scheduled environment as it is a long process: `[] spawn A3A_fnc_NGSA_main;`."];
};

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
if (_navGridHM isEqualType 0) then {
    _navGridHM = (call A3A_fnc_NG_import #1);
};

private _navGridPosRegionHM = [_navGridHM] call A3A_fnc_NGSA_posRegionHM_generate;
[localNamespace,"A3A_NGPP","navGridPosRegionHM",_navGridPosRegionHM] call Col_fnc_nestLoc_set;

if (isNil {A3A_NGSA_dotBaseSize} || isNil {A3A_NGSA_lineBaseSize}) then {
    A3A_NGSA_dotBaseSize = 1.2;
    A3A_NGSA_lineBaseSize = 4;
};
[_navGridHM,_navGridPosRegionHM] call A3A_fnc_NGSA_EH_add;
[A3A_NGSA_lineBaseSize,false,false,A3A_NGSA_dotBaseSize,A3A_NGSA_dotBaseSize*1.6] spawn A3A_fnc_NG_draw_main;
call A3A_fnc_NGSA_refreshMarkerOrder;
