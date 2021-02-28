/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from navRegions

Arguments:
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct 1
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct 2

Return Value:
    <BOOLEAN> true if deleted, false if not found.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: No
Dependencies:
    <LOCATION> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "NavRegions")

Example:
    findDisplay 12 displayAddEventHandler ["MouseButtonDown", {
        if (!XXX_Slayer_MouseDown) then {
            XXX_Slayer_MouseDown = true;
            _this call A3A_fnc_NGSA_onMouseClick;
        };
    }];
*/
params [
    ["_myStruct",[],[ [] ], [3]],
    ["_otherStruct",[],[ [] ], [3]]
];

private _myRoad = _myStruct#0;
private _otherRoad = _otherStruct#0;

private _myName = str _myRoad;
private _otherName = str _otherRoad;

private _myConnections = _myStruct#1;
private _otherConnections = _otherStruct#1;

private _myDistances = _myStruct#2;
private _otherDistances = _otherStruct#2;

private _marker_lines = [localNamespace,"A3A_NGPP","draw","linesBetweenRoads_markers_line",[]] call Col_fnc_nestLoc_get;    // Prefixed with NGPP_line_ + (_myName + _otherName) (we will exclude distance)
private _marker_distances = [localNamespace,"A3A_NGPP","draw","linesBetweenRoads_markers_distance",[]] call Col_fnc_nestLoc_get;    // Prefixed with NGPP_line_ + (_myName + _otherName) (we will exclude distance)

if (_myRoad in _otherConnections) then { // If connected, then disconnect.
    ["Street Artist","Disconnected"] call A3A_fnc_customHint;
    while {_myRoad in _otherConnections || _otherRoad in _myConnections} do {  // sometimes due to simplification or map roads, nodes may be connected multiple times.
        private _otherInMy = _myConnections find _otherRoad;
        _myConnections deleteAt _otherInMy;
        _myDistances deleteAt _otherInMy;

        private _myInOther = _otherConnections find _myRoad;
        _otherConnections deleteAt _myInOther;
        _otherDistances deleteAt _myInOther;
    };
    if (_myRoad in _otherConnections || _otherRoad in _myConnections) then {
        throw ["CouldNotDisconnectStructs","CouldNotDisconnectStructs."];
        [1,"CouldNotDisconnectStructs " + str (getPosWorld _myRoad) + ", " + str (getPosWorld _otherRoad) + ".","fn_NG_simplify_junc"] call A3A_fnc_log;
        ["fn_NG_simplify_junc Error","Please check RPT."] call A3A_fnc_customHint;
    };

    private _probableNames = ["NGPP_line_" + (_myName + _otherName),"NGPP_line_" + (_otherName + _myName)];   // We try both
    deleteMarker (_probableNames#0);   // We try both
    deleteMarker (_probableNames#1);
    {
        _marker_lines deleteAt (_marker_lines find _x);   // We try both
    } forEach _probableNames;

} else {    // If not connected, then connect.
    ["Street Artist","Connected"] call A3A_fnc_customHint;
    private _distance = _myRoad distance2D _otherRoad;
    _myConnections pushBack _otherRoad;
    _myDistances pushBack _distance;

    _otherConnections pushBack _myRoad;
    _otherDistances pushBack _distance;

    private _roadColourClassification = [["MAIN ROAD", "ROAD", "TRACK"],["ColorGreen","ColorYellow","ColorOrange"]];
    _marker_lines pushBack ([_myRoad,_otherRoad,_myName + _otherName,_roadColourClassification,4,false] call A3A_fnc_NG_draw_line);
};
