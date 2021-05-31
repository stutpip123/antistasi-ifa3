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
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> A3A_NGSA_selectedStruct;
    <STRING> A3A_NGSA_modeConnect_selMarkerName;
    <HASHMAP> A3A_NG_const_hashMap

Example:
    [] spawn A3A_fnc_NGSA_EH_add;
*/
#include "\a3\ui_f\hpp\definedikcodes.inc";

params [
    ["_navGridHM",0,[A3A_NG_const_hashMap]],
    ["_navGridPosRegionHM",0,[A3A_NG_const_hashMap]]
];

[localNamespace,"A3A_NGPP","navGridHM",_navGridHM] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","navGridPosRegionHM",_navGridPosRegionHM] call Col_fnc_nestLoc_set;

waitUntil {
    uiSleep 0.5;
    !isNull findDisplay 12 && !isNull findDisplay 46;
};
private _map = findDisplay 12;
private _mapCtrl = _map displayCtrl 51;
private _gameWindow = findDisplay 46;

A3A_NGSA_DIKToKeyName = createHashMapFromArray [
    [DIK_LSHIFT,"shift"],
    [DIK_RSHIFT,"shift"],
    [DIK_LCONTROL,"ctrl"],
    [DIK_RCONTROL,"ctrl"],
    [DIK_LALT,"alt"],
    [DIK_RALT,"alt"],
    [DIK_TAB,"tab"],
    [DIK_C,"c"],
    [DIK_D,"d"],
    [DIK_E,"e"],
    [DIK_F,"f"],
    [DIK_H,"h"],
    [DIK_R,"r"],
    [DIK_S,"s"],
    [DIK_V,"v"]
];
A3A_NGSA_depressedKeysHM = createHashMap;    // Will always be sorted, this allows direct array comparison

A3A_NGSA_dotBaseSize = 1.2;
A3A_NGSA_lineBaseSize = 4;
A3A_NGSA_nodeOnlyOnRoad = true;

A3A_NGSA_heightTester = "Land_TacticalBacon_F" createVehicle [0,0,0];

A3A_NGSA_clickModeEnum = 0;
A3A_NGSA_toolModeChanged = true;
A3A_NGSA_maxSelectionRadius = 50; // metres
A3A_NGSA_brushSelectionRadius = 50; // meters

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

A3A_NGSA_modeBrush_recentDeletion = false;
A3A_NGSA_refresh_busy = false;

private _mapEH_mouseDown = _map displayAddEventHandler ["MouseButtonDown", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    if !(A3A_NGSA_depressedKeysHM set [["mbt0","mbt1"]#_button,[_shift, _ctrl, _alt]]) exitWith {   // Will only be left or right
        _this call A3A_fnc_NGSA_onMouseClick;   // Only fires on new keys.
        true;
    };
    nil;
    true;
}];
private _mapEH_mouseUp = _map displayAddEventHandler ["MouseButtonUp", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM deleteAt (["mbt0","mbt1"]#_button);    // Will only be left or right
    nil;
}];
[localNamespace,"A3A_NGPP","mapEH_mouseDown",_mapEH_mouseDown] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","mapEH_mouseUp",_mapEH_mouseUp] call Col_fnc_nestLoc_set;
_gameWindow displayAddEventHandler ["MouseButtonDblClick", {
    params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];
    visibleMap;   // Prevent adding markers.
}];


private _missionEH_eachFrame_ID = addMissionEventHandler ["EachFrame", {
    // Alt+Tab checker. Prevents clicks are keys progressing though alt+tab
    if ("alt" in A3A_NGSA_depressedKeysHM && A3A_NGSA_LastAltTime +1 < serverTime) then {
        {
            A3A_NGSA_depressedKeysHM deleteAt _x;
        } forEach +(keys A3A_NGSA_depressedKeysHM);
    };
    //params ["_control"];
    call A3A_fnc_NGSA_onUIUpdate;
}];
[localNamespace,"A3A_NGPP","MissionEH_eachFrame_ID",_missionEH_eachFrame_ID] call Col_fnc_nestLoc_set;



private _missionEH_keyDown = _map displayAddEventHandler ["KeyDown", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    private _return = nil;
    if ((A3A_NGSA_DIKToKeyName getOrDefault [_key,"none"]) isEqualTo "alt") then {
        A3A_NGSA_LastAltTime = serverTime;
    };
    if !(A3A_NGSA_depressedKeysHM set [A3A_NGSA_DIKToKeyName getOrDefault [_key,_key],[_shift, _ctrl, _alt]]) then {
        _return = _this call A3A_fnc_NGSA_onKeyDown;   // Only fires on new keys.
    };
    _return;
}];
private _missionEH_keyUp = _map displayAddEventHandler ["KeyUp", {
    params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];
    A3A_NGSA_depressedKeysHM deleteAt (A3A_NGSA_DIKToKeyName getOrDefault [_key,_key]);
    nil;
}];
[localNamespace,"A3A_NGPP","missionEH_keyDown",_missionEH_keyDown] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","missionEH_keyUp",_missionEH_keyUp] call Col_fnc_nestLoc_set;

// ID 600 is not dropped in case there was a critical error that did not halt the process.
[0] call A3A_fnc_NGSA_action_changeTool;
[0] call A3A_fnc_NGSA_action_changeColours;
[
    "General",
    "<t color='#f0d498'>'F'</t>-Cycle Tool<br/>"+
    "<t color='#f0d498'>'ctrl'+'D'</t>-Cycle Map Legend<br/>"+
    "<t color='#f0d498'>'ctrl'+'R'</t>-Refresh Markers<br/>"+
    "<t color='#f0d498'>'ctrl'+'S'</t>-Export changes",
    true,
    300
] call A3A_fnc_customHint;
200 call A3A_fnc_customHintDrop;

true;
