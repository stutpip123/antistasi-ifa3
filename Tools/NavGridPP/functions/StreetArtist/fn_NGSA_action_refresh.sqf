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
    [
        "Street Artist",
        "<t align='left'>" +
        _diag_step_main+"<br/>"+
        "</t>",
        true
    ];
    [
        "Street Artist Help",
        "<t size='1' align='left'><t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Refresh</t><br/>"+
        _diag_step_main+"<br/>"+
        "<br/>"+
        "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>General</t><br/>"+
        "<t color='#f0d498'>'F'</t>-Cycle tool<br/>"+
        "<t color='#f0d498'>'ctrl'+'S'</t>-Export changes<br/>"+
        "<t color='#f0d498'>'ctrl'+'D'</t>-Cycle Island Colour Division.<br/>"+
        "<t color='#f0d498'>'ctrl'+'R'</t>-Refresh Markers<br/>"+
        "</t>",
        true
    ] call A3A_fnc_customHint;
};

if (A3A_NGSA_refresh_busy) exitWith {
    "Auto refresh is busy running. Wait a second then run again." call _fnc_diag_report;
};
A3A_NGSA_refresh_busy = true;
"Refreshing All Markers." call _fnc_diag_report;

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
_navGridHM call A3A_fnc_NGSA_navGridHM_refresh_islandID;
[_navGridHM,A3A_NGSA_dotBaseSize] call A3A_fnc_NG_draw_islands;

[A3A_NGSA_lineBaseSize,false,false,A3A_NGSA_dotBaseSize,A3A_NGSA_dotBaseSize] call A3A_fnc_NG_draw_main;

A3A_NGSA_refresh_busy = false;
"Islands refreshed." call _fnc_diag_report;
