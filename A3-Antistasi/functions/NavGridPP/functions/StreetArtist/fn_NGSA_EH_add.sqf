/*
Maintainer: Caleb Serafin
    Adds a mouse click eventHandler to the map.

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
[localNamespace,"NavGridPP","MapEH_down_ID",_mapEH_down_ID] call Col_fnc_nestLoc_set;

private _mapEH_up_ID = _map displayAddEventHandler ["MouseButtonUp", {if (A3A_NGSA_mouseDown) then {A3A_NGSA_mouseDown = false};}];
[localNamespace,"NavGridPP","MapEH_up_ID",_mapEH_up_ID] call Col_fnc_nestLoc_set;

true;
