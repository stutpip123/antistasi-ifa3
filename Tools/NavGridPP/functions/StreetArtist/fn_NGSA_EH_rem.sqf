/*
Maintainer: Caleb Serafin
    Adds a mouse click eventHandler to the map.

Return Value:
    <BOOLEAN> true if removed, false if one did not exist.

Scope: Client
Environment: Unscheduled
Public: No

Example:
    [] spawn A3A_fnc_NGSA_EH_rem;
*/

waitUntil {
    uiSleep 0.5;
    !isNull findDisplay 12 && !isNull findDisplay 46;
};
private _map = findDisplay 12;
private _gameWindow = findDisplay 46;

private _mapEH_mouseDown = [localNamespace,"A3A_NGPP","mapEH_mouseDown",-1] call Col_fnc_nestLoc_get;
if (_mapEH_mouseDown != -1) then {
    _map displayRemoveEventHandler ["MouseButtonDown",_mapEH_mouseDown];
};
private _mapEH_mouseUp = [localNamespace,"A3A_NGPP","mapEH_mouseUp",-1] call Col_fnc_nestLoc_get;
if (_mapEH_mouseUp != -1) then {
    _map displayRemoveEventHandler ["MouseButtonUp",_mapEH_mouseUp];
};

private _mapEH_mouseDown = [localNamespace,"A3A_NGPP","MissionEH_eachFrame_ID",-1] call Col_fnc_nestLoc_get;
if (_mapEH_mouseDown != -1) then {
    removeMissionEventHandler ["EachFrame",_mapEH_mouseDown];
};

private _missionEH_keyDown = [localNamespace,"A3A_NGPP","missionEH_keyDown",-1] call Col_fnc_nestLoc_get;
if (_missionEH_keyDown != -1) then {
    _gameWindow displayRemoveEventHandler ["KeyDown",_missionEH_keyDown];
};
private _missionEH_keyUp = [localNamespace,"A3A_NGPP","missionEH_keyUp",-1] call Col_fnc_nestLoc_get;
if (_missionEH_keyUp != -1) then {
    _gameWindow displayRemoveEventHandler ["KeyUp",_missionEH_keyUp];
};

_mapEH_mouseDown != -1 && _mapEH_mouseUp != -1;
