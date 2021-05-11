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

[nil,false,false] call A3A_fnc_NG_draw_main;
[_navGridHM,_navGridPosRegionHM] call A3A_fnc_NGSA_EH_add;
call A3A_fnc_NGSA_refreshMarkerOrder;
