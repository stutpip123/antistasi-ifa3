/*
Maintainer: Caleb Serafin
    Refreshes islandIDs.
    Redraws islands.

Return Value:
    <ANY> undefined.

Scope: Client, Local Arguments, Local Effect
Environment: Any
Public: No

Dependencies:
    <SCALAR> A3A_NGSA_clickModeEnum Currently select click mode

Example:
    call A3A_fnc_NGSA_action_refresh;
*/

private _fnc_diag_report = {
    params ["_diag_step_main"];

    [3,_diag_step_main,"fn_NGSA_action_refresh"] call A3A_fnc_log;
    private _hintData = [
        "Street Artist",
        "<t align='left'>" +
        _diag_step_main+"<br/>"+
        "</t>",
        true
    ];
    _hintData call A3A_fnc_customHint;
    _hintData remoteExec ["A3A_fnc_customHint",-clientOwner];
};

if (A3A_NGSA_autoRefresh_busy) exitWith {
    "Auto refresh is busy running." call _fnc_diag_report;
};

"Refreshing Islands." call _fnc_diag_report;

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
_navGridHM call A3A_fnc_NGSA_navGridHM_refresh_islandID;
[_navGridHM,A3A_NGSA_dotBaseSize] call A3A_fnc_NG_draw_islands;

"Islands refreshed." call _fnc_diag_report;
