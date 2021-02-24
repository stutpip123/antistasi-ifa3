/*
Maintainer: Caleb Serafin
    Converts navRoadHM to navGridHM.

Arguments:
    <navGrid>

Return Value:
    <navFlatHM>

Scope: Any, Global Arguments
Environment: Scheduled
Public: Yes

Example:
    private _navFlatHM = [_navGrid] call A3A_fnc_NG_convert_navGrid_navFlatHM;
*/
params [
    "_navRoadHM"
];

private _fnc_diag_render = { // ["Hi"] call _fnc_diag_render;
    params ["_diag_step_sub"];
    private _customHintParams = [
        "Nav Grid++",
        "<t align='left'>
        Converting navGrid to navFlatHM<br/>"+
        _diag_step_sub+"<br/>
        </t>",
        true
    ];
    _customHintParams call A3A_fnc_customHint;
    _customHintParams remoteExec ["A3A_fnc_customHint",-clientOwner];
};

["Creating unprocessed hashMap"] call _fnc_diag_render;
private _nameUnprocessedHM = createHashMapFromArray (keys _navRoadHM apply {[_x,true]});

private _fnc_convert_NGStruct_NFStructKV = {
    params ["_NGRoadStruct","_IslandID"];
    _NGRoadStruct params ["_road","_connectedRoads","_connectedDistances"];

    private _roadPos = getPosWorld _road select A3A_NG_const_pos2DSelect;
    private _connections = [];
    {
        _connections pushBack [getPosWorld _x select A3A_NG_const_pos2DSelect, A3A_NG_const_roadTypeEnum find (getRoadInfo _road #0), _connectedDistances#_forEachIndex];
    } forEach _connectedRoads;

    [_roadPos, [_roadPos,_islandID,(count _connectedRoads) > 2,_connections]];
};

private _islandID = 0;
private _navFlatHM = createHashMap;

private _diag_totalSegments = count _nameUnprocessedHM;
while {count _nameUnprocessedHM != 0} do {
    private _newName = keys _nameUnprocessedHM #0;
    _nameUnprocessedHM deleteAt _newName;
    private _nextNames = [_newName];// Array<road string>

    while {count _nextNames != 0} do {
        //private _diag_sub_counter = count _navFlatHM;
        //("Completion &lt;" + ((100 * _diag_sub_counter /_diag_totalSegments) toFixed 1) + "% &gt; Processing segment &lt;" + (str _diag_sub_counter) + " / " + (str _diag_totalSegments) + "&gt;") call _fnc_diag_render;

        private _currentNames = _nextNames; // Array<struct>
        _nextNames = [];

        {
            private _struct = _navRoadHM get _x;
            _navFlatHM set ([_struct,_IslandID] call _fnc_convert_NGStruct_NFStructKV);

            private _connectedNames = (_struct#1) apply {str _x} select {_nameUnprocessedHM get _x};
            { _nameUnprocessedHM deleteAt _x; } forEach _connectedNames;
            _nextNames append _connectedNames;
        } forEach _currentNames;
    };
    _islandID = _islandID +1;
};

_navFlatHM;
