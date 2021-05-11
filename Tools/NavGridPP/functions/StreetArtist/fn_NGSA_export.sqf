/*
Maintainer: Caleb Serafin
    Exports current modifications in _navGridHM as navGridDB formatted to clipboard.

Return Value:
    <ANY> Undefined

Scope: Clients, Global Arguments, Local Effect
Environment: Scheduled
Public: Yes

Example:
    [] spawn A3A_fnc_NGSA_export;
*/

private _diag_step_main = "";
private _fnc_diag_render = { // call _fnc_diag_render;
    [
        "Street Artist Exporter",
        "<t align='left'>" +
        _diag_step_main+"<br/>"+
        "</t>",
        true
    ] remoteExec ["A3A_fnc_customHint",0];
};

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",[]] call Col_fnc_nestLoc_get;

_diag_step_sub = "navGridHM to navGridDB";
call _fnc_diag_render;
[4,"A3A_fnc_NG_convert_navGridHM_navGridDB","fn_NGSA_export"] call A3A_fnc_log;
private _navGridDB = [_navGridHM] call A3A_fnc_NG_convert_navGridHM_navGridDB;

//*
_diag_step_sub = "Unit Test Running<br/>navGridDB to navIsland";  // Serves as a self check
call _fnc_diag_render;
[4,"A3A_fnc_NG_convert_navGridDB_navGridHM","fn_NGSA_export"] call A3A_fnc_log;
_navGridHM = [_navGridDB] call A3A_fnc_NG_convert_navGridDB_navGridHM;
//*/

private _flatMaxDrift = -1;
private _juncMergeDistance = -1;
private _navGridDB_formatted = ("/*{""systemTimeUCT_G"":"""+(systemTimeUTC call A3A_fnc_systemTime_format_G)+""",""worldName"":"""+worldName+""",""NavGridPP_Config"":{""_flatMaxDrift"":"+str _flatMaxDrift+",""_juncMergeDistance"":"+str _juncMergeDistance+"}}*/
") + ([_navGridDB] call A3A_fnc_NG_format_navGridDB);
copyToClipboard _navGridDB_formatted;

[localNamespace,"A3A_NGPP","navGridHM",_navGridHM] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","navGridDB_formatted",_navGridDB_formatted] call Col_fnc_nestLoc_set;
[nil,false,false] spawn A3A_fnc_NG_draw_main;

[4,"Done","fn_NGSA_export"] call A3A_fnc_log;
_diag_step_main = "Done";
_diag_step_sub = "navGridDB copied to clipboard!<br/><br/>If you have lost your clipboard, you can grab the navGridDB_formatted with<br/>`copyToClipboard ([localNamespace,'A3A_NGPP','navGridDB_formatted',''] call Col_fnc_nestLoc_get)`";
call _fnc_diag_render;
