/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from posRegions

Arguments:
    <POS2D> _worldPos
    <BOOLEAN> _shift
    <BOOLEAN> _ctrl
    <BOOLEAN> _alt

Return Value:
    <BOOLEAN> true if deleted, false if not found.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: No
Dependencies:
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "posRegionHM")
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "navGridHM")

Example:
    [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_click_modeConnect;
*/
params ["_worldPos", "_shift", "_ctrl", "_alt"];

private _deselect = {
    A3A_NGSA_modeConnect_selectedExists = false;
    A3A_NGSA_modeConnect_selectedNode = [];
};
private _select = {
    A3A_NGSA_modeConnect_selectedNode = A3A_NGSA_modeConnect_targetNode;
    A3A_NGSA_modeConnect_selectedExists = true;

    A3A_NGSA_UI_marker1_pos = A3A_NGSA_modeConnect_selectedNode#0;
    A3A_NGSA_UI_marker1_name setMarkerPos A3A_NGSA_UI_marker1_pos; // Broadcasts here
};

switch (true) do {       // Broadcast here.
    case ("shift" in A3A_NGSA_depressedKeysHM && [_worldPos] call A3A_fnc_NGSA_isValidRoad): {
        A3A_NGSA_modeConnect_targetNode = [_worldPos,0,false,[]];
        private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
        private _navGridPosRegionHM = [localNamespace,"A3A_NGPP","navGridPosRegionHM",0] call Col_fnc_nestLoc_get;
        [_navGridHM,_navGridPosRegionHM,_worldPos,A3A_NGSA_modeConnect_targetNode] call A3A_fnc_NGSA_pos_add;    // Island ID will not be accurate.

        private _markerStructs = [localNamespace,"A3A_NGPP","draw","markers_road", 0] call Col_fnc_nestLoc_get;
        private _name = "A3A_NG_Dot_"+str _worldPos;
        if !(_markerStructs set [_name,true]) then {
            createMarkerLocal [_name,_worldPos];
        };
        _name setMarkerTypeLocal "mil_dot";
        _name setMarkerSizeLocal [A3A_NGSA_dotBaseSize,A3A_NGSA_dotBaseSize];
        _name setMarkerColor "ColorBlack";

        if (A3A_NGSA_modeConnect_selectedExists) then {
            [A3A_NGSA_modeConnect_selectedNode,A3A_NGSA_modeConnect_targetNode,A3A_NGSA_modeConnect_roadTypeEnum] call A3A_fnc_NGSA_toggleConnection;
        };
        call _select;
        call A3A_fnc_NGSA_refreshMarkerOrder;
        call A3A_fnc_NGSA_action_autoRefresh;
    };
    case (!A3A_NGSA_modeConnect_targetExists): _deselect;
    case ("alt" in A3A_NGSA_depressedKeysHM): {
        private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
        private _navGridPosRegionHM = [localNamespace,"A3A_NGPP","navGridPosRegionHM",0] call Col_fnc_nestLoc_get;
        [_navGridHM,A3A_NGSA_UI_marker0_pos] call A3A_fnc_NGSA_node_disconnect;
        [_navGridHM,_navGridPosRegionHM,A3A_NGSA_UI_marker0_pos] call A3A_fnc_NGSA_pos_rem;    // Island ID will not be accurate.

        private _markerStructs = [localNamespace,"A3A_NGPP","draw","markers_road", 0] call Col_fnc_nestLoc_get;
        private _name = "A3A_NG_Dot_"+str A3A_NGSA_UI_marker0_pos;
        deleteMarker _name;
        _markerStructs deleteAt _name;
        call A3A_fnc_NGSA_action_autoRefresh;
    };
    case (!A3A_NGSA_modeConnect_selectedExists): _select;
    case (A3A_NGSA_modeConnect_selectedNode isEqualTo A3A_NGSA_modeConnect_targetNode): _deselect;
    default {
        [A3A_NGSA_modeConnect_selectedNode,A3A_NGSA_modeConnect_targetNode,A3A_NGSA_modeConnect_roadTypeEnum] call A3A_fnc_NGSA_toggleConnection;
        call _select;
        call A3A_fnc_NGSA_refreshMarkerOrder;
        call A3A_fnc_NGSA_action_autoRefresh;
    };
};
