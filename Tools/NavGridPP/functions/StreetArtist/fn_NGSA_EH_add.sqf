/*
Maintainer: Caleb Serafin
    Adds a mouse click eventHandler to the map.

Arguments:
    <navGridHM> Needed for mouse event code
    <posRegions> Needed for mouse event code

Return Value:
    <BOOLEAN> true if added.

Scope: Client
Environment: Unscheduled
Public: No
Dependants Created:
    <BOOLEAN> A3A_NGSA_mouseDown;
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> A3A_NGSA_selectedStruct;
    <STRING> A3A_NGSA_modeConnect_selMarkerName;

Example:
    [] spawn A3A_fnc_NGSA_EH_add;
*/
params [
    "_navGridHM",
    "_navGridPosRegionHM"
];

[localNamespace,"A3A_NGPP","navGridHM",_navGridHM] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","navGridPosRegionHM",_navGridPosRegionHM] call Col_fnc_nestLoc_set;

waitUntil {
    uiSleep 0.5;
    !isNull findDisplay 12 && !isNull findDisplay 46;
};
private _map = findDisplay 12;
private _gameWindow = findDisplay 46;

A3A_NGSA_DIKToKeyHM = createHashMapFromArray [
    [42, "shift"],
    [54, "shift"],
    [29, "ctrl"],
    [157,"ctrl"],
    [56, "alt"],
    [184,"alt"]
];
A3A_NGSA_depressedKeysHM = createHashMap;
A3A_NGSA_depressedKeysHM set ["shift",false];
A3A_NGSA_depressedKeysHM set ["ctrl",false];
A3A_NGSA_depressedKeysHM set ["alt",false];
A3A_NGSA_mouseDown = false;

A3A_NGSA_dotBaseSize = 1.2;
A3A_NGSA_lineBaseSize = 4;
A3A_NGSA_nodeOnlyOnRoad = true;

A3A_NGSA_clickModeEnum = 1;
A3A_NGSA_maxSelectionRadius = 50; // metres
A3A_NGSA_fullSelectionRadius = 50; // metres unlimited by region size

A3A_NGSA_UI_marker0_name = "A3A_NGSA_UI_marker0";
A3A_NGSA_UI_marker0_pos = [0,0];
createMarker [A3A_NGSA_UI_marker0_name,A3A_NGSA_UI_marker0_pos];
A3A_NGSA_UI_marker1_name = "A3A_NGSA_UI_marker1";
A3A_NGSA_UI_marker1_pos = [0,0];
createMarker [A3A_NGSA_UI_marker1_name,A3A_NGSA_UI_marker1_pos];

A3A_NGSA_modeConnect_roadTypeEnum = 0;
A3A_NGSA_modeConnect_targetExists = false;
A3A_NGSA_modeConnect_targetNode = [];
A3A_NGSA_modeConnect_selectedExists = false;
A3A_NGSA_modeConnect_selectedNode = [];

A3A_NGSA_modeConnect_lineName = "A3A_NGSA_UI_modeConnect_line";
createMarkerLocal [A3A_NGSA_modeConnect_lineName,[0,0]];


private _mapEH_mouseDown = _map displayAddEventHandler ["MouseButtonDown", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM set [["LeftMouseButton","RightMouseButton"]#_button,true];
    if (!A3A_NGSA_MouseDown) then {
        A3A_NGSA_MouseDown = true;
        _this call A3A_fnc_NGSA_onMouseClick;
    };
    nil;
}];
private _mapEH_mouseUp = _map displayAddEventHandler ["MouseButtonUp", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM set [["LeftMouseButton","RightMouseButton"]#_button,false];// Will only be left or right
    if (A3A_NGSA_mouseDown) then {
        A3A_NGSA_mouseDown = false;
    };
    nil;
}];
[localNamespace,"A3A_NGPP","mapEH_mouseDown",_mapEH_mouseDown] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","mapEH_mouseUp",_mapEH_mouseUp] call Col_fnc_nestLoc_set;


private _missionEH_eachFrame_ID = addMissionEventHandler ["EachFrame", {
    //params ["_control"];
    call A3A_fnc_NGSA_onUIUpdate;
}];
[localNamespace,"A3A_NGPP","MissionEH_eachFrame_ID",_missionEH_eachFrame_ID] call Col_fnc_nestLoc_set;



private _missionEH_keyDown = _gameWindow displayAddEventHandler ["KeyDown", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM set [A3A_NGSA_DIKToKeyHM getOrDefault [_key,_key],true];
    nil;
}];
private _missionEH_keyUp = _gameWindow displayAddEventHandler ["KeyUp", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM set [A3A_NGSA_DIKToKeyHM getOrDefault [_key,_key],false];
    nil;
}];
[localNamespace,"A3A_NGPP","missionEH_keyDown",_missionEH_keyDown] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","missionEH_keyUp",_missionEH_keyUp] call Col_fnc_nestLoc_set;


true;
