/*
Maintainer: Caleb Serafin
    Places a map marker on points.
    Previous markers make by this function are deleted.
    Colour depends on number of connections:
        0  -> Black
        1  -> Red
        2  -> Orange
        3  -> Yellow
        4  -> Green
        >4 -> Blue

Arguments:
    <_navGridHM>
    <SCALAR> Size of road node dots. (Set to 0 to disable) (Default = 0.8)
    <SCALAR> Size of island dots. (Set to 0 to disable) (Default = 1)

Return Value:
    <ANY> undefined.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled (Recommended) | Any (If small navGrid like Stratis, Malden)
Public: Yes

Example:
    [_navGridHM] call A3A_fnc_NG_draw_dotOnRoads;
*/
params [
    "_navGridHM",
    ["_dot_size",0.8,[ 0 ]],
    ["_islandDot_size",1,[ 0 ]]
];

private _markers_old = [localNamespace,"A3A_NGPP","draw","dotOnRoads_markers", createHashMap] call Col_fnc_nestLoc_get;
private _markers_new = createHashMap;
[localNamespace,"A3A_NGPP","draw","dotOnRoads_markers",_markers_new] call Col_fnc_nestLoc_set;

if (_dot_size > 0) then {
    private _const_countColours = createHashMapFromArray [[0,"ColorBlack"],[1,"ColorRed"],[2,"ColorOrange"],[3,"ColorYellow"],[4,"ColorGreen"]];
    private _const_dot_size = [_dot_size, _dot_size];
    private _const_islandDot_size = [_islandDot_size, _islandDot_size];

    private _islandIDs = [];

    {
        private _struct = _navGridHM get _x;
        private _name = "A3A_NG_Dot_"+str _x;

        private _exists = _name in _markers_old;
        _markers_old deleteAt _name;
        _markers_new set [_name,true];

        if !(_exists) then {
            createMarkerLocal [_name,_x];
            _name setMarkerTypeLocal "mil_dot";
        };
        _name setMarkerSizeLocal _const_dot_size;
        _name setMarkerColor (_const_countColours getOrDefault [count (_struct#3) ,"ColorBlue"]);

        private _islandID = _struct#1;
        if !(_islandID in _islandIDs) then {
            _islandIDs pushBack _islandID;
            private _islandName = "A3A_NG_DotIsland_"+str _islandID;

             private _exists = _islandName in _markers_old;
            _markers_old deleteAt _islandName;
            _markers_new set [_islandName,true];

            if !(_exists) then {
                createMarkerLocal [_islandName,_x];
                _islandName setMarkerTypeLocal "mil_objective";
                _islandName setMarkerTextLocal ("Island <" + str (_struct#1) +">");
                _islandName setMarkerColor "colorCivilian";
            };
            _islandName setMarkerSizeLocal _const_islandDot_size;
            _islandName setMarkerPos _x
        };
    } forEach _navGridHM;
};

{
    deleteMarker _x;
} forEach _markers_old;
