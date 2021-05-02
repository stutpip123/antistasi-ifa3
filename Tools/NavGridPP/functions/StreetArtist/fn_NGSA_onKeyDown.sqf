/*
Maintainer: Caleb Serafin
    Called by keyDown event handler. Only fires on new keys.
    Calls specific modes.

Arguments:
    <SCALAR> _button
    <BOOLEAN> _shift
    <BOOLEAN> _ctrl
    <BOOLEAN> _alt

Return Value:
    <ANY> nil.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: No

Dependencies:
    <SCALAR> A3A_NGSA_clickModeEnum Currently select click mode

Example:
    private _missionEH_keyDown = _gameWindow displayAddEventHandler ["KeyDown", A3A_fnc_NGSA_onKeyDown];
*/
params ["_displayOrControl", "_key", "_shift", "_ctrl", "_alt"];

if (!visibleMap) exitWith {nil};

// Non-cancelling/conflicting items
private _actionExecuted = false;

if ("f" in A3A_NGSA_depressedKeysHM) then {
    A3A_NGSA_clickModeEnum = ((A3A_NGSA_clickModeEnum + 1) mod 3) max 1;  // 1 or 2
    A3A_NGSA_toolModeChanged = true;
    _actionExecuted = true;
};
if ("c" in A3A_NGSA_depressedKeysHM) then {
    A3A_NGSA_modeConnect_roadTypeEnum = (A3A_NGSA_modeConnect_roadTypeEnum + 1) mod 3; // 0, 1 ,2
    _actionExecuted = true;
};


switch (true) do {
    case ((A3A_NGSA_depressedKeysHM getOrDefault ["s",[]]) isEqualTo [false,true,false]): {   // ctrl + s
        call A3A_fnc_NGSA_action_save;
        _actionExecuted = true;
    };
    case ((A3A_NGSA_depressedKeysHM getOrDefault ["r",[]]) isEqualTo [false,true,false]): {   // ctrl + r
        call A3A_fnc_NGSA_action_refresh;
        _actionExecuted = true;
    };
};

_actionExecuted;
