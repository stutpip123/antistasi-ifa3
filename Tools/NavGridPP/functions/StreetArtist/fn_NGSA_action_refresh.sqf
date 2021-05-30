/*
Maintainer: Caleb Serafin
    Refreshes islandIDs.
    Redraws all markers.

Arguments:
    <BOOLEAN> true to make silent. [Default = false]

Return Value:
    <ANY> undefined.

Scope: Client, Local Arguments, Local Effect
Environment: Any
Public: No

Example:
    call A3A_fnc_NGSA_action_refresh;
*/
params [
    ["_silent",false]
];

private _fnc_diag_report = {
    params ["_diag_step_main"];
    [
        "Refresh",
        "<t size='"+str(A3A_NGSA_baseTextSize)+"' align='left'>"+_diag_step_main+"</t>",
        true,
        200
    ] call A3A_fnc_customHint;
};
if (_silent) then {
    _fnc_diag_report = {};
};

if (A3A_NGSA_refresh_busy) exitWith {
    "Auto refresh is busy running. Wait a second then run again." call _fnc_diag_report;
};
A3A_NGSA_refresh_busy = true;
"Refreshing All Markers." call _fnc_diag_report;

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
_navGridHM call A3A_fnc_NGSA_navGridHM_refresh_islandID;
[_navGridHM,A3A_NGSA_dotBaseSize] call A3A_fnc_NG_draw_islands;

[nil,false,false] call A3A_fnc_NG_draw_main;

A3A_NGSA_refresh_busy = false;
"Islands refreshed!" call _fnc_diag_report;
