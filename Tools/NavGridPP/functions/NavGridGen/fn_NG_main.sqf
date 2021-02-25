/*
Maintainer: Caleb Serafin
    See `Please Read Me.md` in root folder for clear instructions
    Main process that organises the creation of the navGrid.
    Calls many NavGridPP functions.
    Output navGridDB string includes creation time and config;
    NavGridDB is copied to clipboard.

Arguments:
    <SCALAR> Max drift is how far the simplified line segment can stray from the road in metres. (Default = 50)
    <SCALAR> Junctions are only merged if within this distance from each other. (Default = 15)
    <BOOLEAN> True to start the drawing script automatically. (Default = false)

Return Value:
    <ANY> Undefined

Scope: Client, Global Arguments
Environment: Scheduled
Public: Yes

Example:
    Tweak parameters:
    [50,35] spawn A3A_fnc_NG_main;

    Or draw when finished:
    [nil,nil,true] spawn A3A_fnc_NG_main;

    To avoid regenerating the nev grid for drawing, you can omit A3A_fnc_NG_main after running it once. Or import from clipboard if this is a new map load.
    [] spawn A3A_fnc_NG_import_clipboard;
*/

params [
    ["_flatMaxDrift",50,[ 0 ]],
    ["_juncMergeDistance",15,[ 0 ]],
    ["_autoDraw",false,[ false ]]
];

if (!canSuspend) exitWith {
    throw ["NotScheduledEnvironment","Please execute NG_main in a scheduled environment as it is a long process: `[] spawn A3A_fnc_NG_main;`."];
};

private _fnc_diag_report = {
    params ["_diag_step_main","_diag_step_sub"];

    [3,_diag_step_main+" | "+_diag_step_sub,"fn_NG_main"] call A3A_fnc_log;
    private _hintData = [
        "Nav Grid++",
        "<t align='left'>" +
        _diag_step_main+"<br/>"+
        _diag_step_sub+"<br/>"+
        "</t>",
        true
    ];
    _hintData call A3A_fnc_customHint;
    _hintData remoteExec ["A3A_fnc_customHint",-clientOwner];
};

["Extraction","Extracting roads"] call _fnc_diag_report;
private _halfWorldSize = worldSize/2;
private _worldCentre = [_halfWorldSize,_halfWorldSize];
private _worldMaxRadius = sqrt(0.5 * (worldSize^2));

private _allRoadObjects = nearestTerrainObjects [_worldCentre, A3A_NG_const_roadTypeEnum, _worldMaxRadius, false, true];

["Extraction","Applying connections and distances"] call _fnc_diag_report;
private _navRoadHM = createHashMapFromArray (_allRoadObjects apply {
    private _road = _x;
    private _connections = roadsConnectedTo [_road,true] select {getRoadInfo _x #0 in A3A_NG_const_roadTypeEnum};
    [str _road,[_road,_connections,_connections apply {_x distance2D _road}]]
});


try {
    ["Fixing","One ways"] call _fnc_diag_report;
    [_navRoadHM] call A3A_fnc_NG_fix_oneWays;

    ["Fixing","Simplifying Connection Duplicates"] call _fnc_diag_report;
    [_navRoadHM] call A3A_fnc_NG_simplify_conDupe;         // Some maps have duplicates even before simplification

    ["Fixing","Dead Ends"] call _fnc_diag_report;
    [_navRoadHM] call A3A_fnc_NG_fix_deadEnds;

    ["Simplification","Simplifying "+str count _navRoadHM+" straight roads."] call _fnc_diag_report;
    [_navRoadHM,_flatMaxDrift] call A3A_fnc_NG_simplify_flat;    // Gives less markers for junc to work on. (junc is far more expensive)
    ["Simplification","Simplification returned "+str count _navRoadHM+" straight roads."] call _fnc_diag_report;

    ["Simplification","Simplifying "+str count _navRoadHM+" junctions."] call _fnc_diag_report;
    [_navRoadHM,_juncMergeDistance] call A3A_fnc_NG_simplify_junc;
    ["Simplification","Simplification returned "+str count _navRoadHM+"road segments."] call _fnc_diag_report;

    ["Format Conversion","Converting navRoadHM to navGridHM."] call _fnc_diag_report;
    private _navGridHM = [_navRoadHM] call A3A_fnc_NG_convert_navRoadHM_navGridHM;

    ["Format Conversion","Converting navGridHM to navGridDB."] call _fnc_diag_report;
    private _navGridDB = [_navGridHM] call A3A_fnc_NG_convert_navGridHM_navGridDB;

    private _navGridDB_formatted = ("/*{""systemTimeUCT_G"":"""+(systemTimeUTC call A3A_fnc_systemTime_format_G)+""",""worldName"":"""+worldName+""",""NavGridPP_Config"":{""_flatMaxDrift"":"+str _flatMaxDrift+",""_juncMergeDistance"":"+str _juncMergeDistance+"}}*/
") + ([_navGridDB] call A3A_fnc_NG_format_navGridDB);

    [localNamespace,"A3A_NGPP","navGridDB_formatted",_navGridDB_formatted] call Col_fnc_nestLoc_set;

    ["Done","navGridDB copied to clipboard!<br/><br/>If you have lost your clipboard, you can grab the navGridDB_formatted with<br/>`copyToClipboard ([localNamespace,'A3A_NGPP','navGridDB_formatted',''] call Col_fnc_nestLoc_get)`"] call _fnc_diag_report;
    copyToClipboard _navGridDB_formatted;
/*
    ["Unit Test","Converting navGridDB to navIsland."] call _fnc_diag_report;
    _navIslands = [_navGridDB] call A3A_fnc_NG_convert_navGridDB_navIslands;
    [localNamespace,"A3A_NGPP","navIslands",_navIslands] call Col_fnc_nestLoc_set;
//*/

    if (_autoDraw) then {
        [] call A3A_fnc_NG_draw_main;
    };
} catch {
    ["NavGrid Error",str _exception] call A3A_fnc_customHint;
};
