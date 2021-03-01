/*
Maintainer: Caleb Serafin
    Places a island markers on map.

Arguments:
    <navGridHM>
    <SCALAR> Size of island dots. (Set to 0 to disable) (Default = 0.8)

Return Value:
    <ANY> undefined.

Scope: Server/Server&HC/Clients/Any, Local Arguments/Global Arguments, Local Effect/Global Effect
Environment: Scheduled (Recommended) | Any (If small navGrid like Stratis, Malden)
Public: Yes

Example:
    [_navGridHM] call A3A_fnc_NG_draw_islands;
*/
params [
    "_navGridHM",
    ["_islandDot_size",0.8,[ 0 ]]
];

private _markerStructs_old = [localNamespace,"A3A_NGPP","draw","markers_island", createHashMap] call Col_fnc_nestLoc_get;
private _markerStructs_new = createHashMap;
[localNamespace,"A3A_NGPP","draw","markers_island",_markerStructs_new] call Col_fnc_nestLoc_set;

if (_islandDot_size > 0) then {
    private _const_islandDot_size = [_islandDot_size, _islandDot_size];
    private _islandIDs = [];
    {
        private _islandID = (_navGridHM get _x)#1;
        if !(_islandID in _islandIDs) then {
            _islandIDs pushBack _islandID;
            private _islandName = "A3A_NG_DotIsland_"+str _islandID;

             private _exists = _islandName in _markerStructs_old;
            _markerStructs_old deleteAt _islandName;
            _markerStructs_new set [_islandName,true];

            if !(_exists) then {
                createMarkerLocal [_islandName,_x];
                _islandName setMarkerTypeLocal "mil_flag";
                _islandName setMarkerTextLocal ("Island <" + str _islandID +">");
                _islandName setMarkerColor "colorCivilian";
            };
            _islandName setMarkerSizeLocal _const_islandDot_size;
            _islandName setMarkerPos _x;
        };
    } forEach _navGridHM;
};

{
    deleteMarker _x;
} forEach _markerStructs_old;
