/*
Maintainer: Caleb Serafin
    Adds a mouse click eventHandler to the map.

Return Value:
    <BOOLEAN> true if removed, false if one did not exist.

Scope: Client
Environment: Unscheduled
Public: No
Dependants Created:
    <BOOLEAN> A3A_NGSA_MouseDown;

Example:
    [] spawn A3A_fnc_NGSA_EH_rem;
*/

waitUntil {
    uiSleep 0.5;
    !isNull findDisplay 12;
};
private _map = findDisplay 12;


private _mapEH_down_ID = [localNamespace,"A3A_NGPP","MapEH_down_ID",-1] call Col_fnc_nestLoc_get;
if (_mapEH_down_ID != -1) then {
    _map displayRemoveEventHandler ["MouseButtonDown",_mapEH_down_ID];
};

private _mapEH_up_ID = [localNamespace,"A3A_NGPP","MapEH_up_ID",-1] call Col_fnc_nestLoc_get;
if (_mapEH_up_ID != -1) then {
    _map displayRemoveEventHandler ["MouseButtonUp",_mapEH_up_ID];
};

_mapEH_down_ID != -1 && _mapEH_up_ID != -1;
