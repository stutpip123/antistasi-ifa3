/*
Maintainer: Caleb Serafin
    Starts the StreetArtist Editor.

Return Value:
    <ANY> Undefined

Scope: Clients, Global Arguments, Local Effect
Environment: Scheduled
Public: Yes

Example:
    ["something", player, 2.718281828, 4, nil, ["Tom","Dick","Harry"], ["UID123Money",0], "hint ""Hello World!"""] call A3A_fnc_standardizedHeader; // false
*/


if (!canSuspend) exitWith {
    throw ["NotScheduledEnvironment","Please execute NG_main in a scheduled environment as it is a long process: `[] spawn A3A_fnc_NGSA_main;`."];
};

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
if (_navGridHM isEqualType 0) then {
    _navGridHM = (call A3A_fnc_NG_import #1);
};

private _navRegions = [_navGridHM] call A3A_fnc_NGSA_navRegions_generate;

[4,false,false,1.2,2] spawn A3A_fnc_NG_draw_main;

[_navGridHM,_navRegions] call A3A_fnc_NGSA_EH_add;