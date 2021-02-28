/*
Maintainer: Caleb Serafin
    Adds a mouse click eventHandler to the map.

Arguments:
    <navGridHM> Needed for mouse event code
    <navRegions> Needed for mouse event code

Return Value:
    <BOOLEAN> true if added.

Scope: Client
Environment: Unscheduled
Public: No
Dependants Created:
    <BOOLEAN> A3A_NGSA_mouseDown;
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> A3A_NGSA_selectedStruct;
    <STRING> A3A_NGSA_selectionMarker;

Example:
    [] spawn A3A_fnc_NGSA_EH_add;
*/
params [
    "_navGridHM",
    "_navRegions"
];

[localNamespace,"A3A_NGPP","navGridHM",_navGridHM] call Col_fnc_nestLoc_set;
[localNamespace,"A3A_NGPP","navRegions",_navRegions] call Col_fnc_nestLoc_set;

waitUntil {
    uiSleep 0.5;
    !isNull findDisplay 12;
};
private _map = findDisplay 12;

A3A_NGSA_mouseDown = false;
A3A_NGSA_selectedStruct = [];
A3A_NGSA_selectionMarker = "";

private _mapEH_down_ID = _map displayAddEventHandler ["MouseButtonDown", {
    if (!A3A_NGSA_MouseDown) then {
        A3A_NGSA_MouseDown = true;
        _this call A3A_fnc_NGSA_onMouseClick;
    };
}];
[localNamespace,"A3A_NGPP","MapEH_down_ID",_mapEH_down_ID] call Col_fnc_nestLoc_set;

private _mapEH_up_ID = _map displayAddEventHandler ["MouseButtonUp", {if (A3A_NGSA_mouseDown) then {A3A_NGSA_mouseDown = false};}];
[localNamespace,"A3A_NGPP","MapEH_up_ID",_mapEH_up_ID] call Col_fnc_nestLoc_set;

true;
