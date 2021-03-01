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
    !isNull findDisplay 12;
};
private _map = findDisplay 12;

A3A_NGSA_mouseDown = false;

A3A_NGSA_dotBaseSize = 1.2;
A3A_NGSA_lineBaseSize = 4;

A3A_NGSA_modeConnect_selectedNode = [];
A3A_NGSA_modeConnect_roadTypeEnum = 2;
A3A_NGSA_modeConnect_selMarkerPos = [0,0];
A3A_NGSA_modeConnect_selectedExists = false;
A3A_NGSA_modeConnect_selMarkerName = "A3A_NG_modeConnect_sel_marker";
createMarkerLocal [A3A_NGSA_modeConnect_selMarkerName,A3A_NGSA_modeConnect_selMarkerPos];
A3A_NGSA_modeConnect_selMarkerName setMarkerTypeLocal "Empty";
A3A_NGSA_modeConnect_selMarkerName setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
A3A_NGSA_modeConnect_selMarkerName setMarkerColor "colorBlack"; // Broadcasts here

A3A_NGSA_clickModeEnum = 1;
A3A_NGSA_maxSelectionRadius = 50; // metres
A3A_NGSA_onUIUpdate_refresh = true;


A3A_NGSA_hoverLineEnabled = false;
A3A_NGSA_hoverLineStartPos = [0,0];
A3A_NGSA_hoverLineEndPos = [0,0];
A3A_NGSA_hoverLineColour = "colorCivilian";
A3A_NGSA_hoverLineBrush = "SolidFull";
A3A_NGSA_hoverLineName = "A3A_NG_UIHover_line";
createMarkerLocal [A3A_NGSA_hoverLineName,A3A_NGSA_hoverLineStartPos];


A3A_NGSA_hoverMarkerCurrentPos = [0,0];
A3A_NGSA_hoverMarkerCurrentName = "A3A_NG_UIHover_marker";
createMarkerLocal [A3A_NGSA_hoverMarkerCurrentName,A3A_NGSA_hoverMarkerCurrentPos];
A3A_NGSA_hoverMarkerCurrentName setMarkerTypeLocal "Empty";
A3A_NGSA_hoverMarkerCurrentName setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
A3A_NGSA_hoverMarkerCurrentName setMarkerColor "ColorBlack"; // Broadcasts here


private _mapEH_down_ID = _map displayAddEventHandler ["MouseButtonDown", {
    if (!A3A_NGSA_MouseDown) then {
        A3A_NGSA_MouseDown = true;
        _this call A3A_fnc_NGSA_onMouseClick;
    };
}];
[localNamespace,"A3A_NGPP","MapEH_down_ID",_mapEH_down_ID] call Col_fnc_nestLoc_set;
private _mapEH_up_ID = _map displayAddEventHandler ["MouseButtonUp", {if (A3A_NGSA_mouseDown) then {A3A_NGSA_mouseDown = false};}];
[localNamespace,"A3A_NGPP","MapEH_up_ID",_mapEH_up_ID] call Col_fnc_nestLoc_set;

private _missionEH_draw_ID = addMissionEventHandler ["EachFrame", {
    //params ["_control"];
    call A3A_fnc_NGSA_onUIUpdate;
}];
[localNamespace,"A3A_NGPP","MissionEH_draw_ID",_missionEH_draw_ID] call Col_fnc_nestLoc_set;



true;
