/*
Maintainer: Caleb Serafin
    Called by keyDown event handler. Only fires on new keys.
    Calls specific modes.
    All combinations with alt should have it as the first key.

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


if ("f" in A3A_NGSA_depressedKeysHM) then {
    A3A_NGSA_clickModeEnum = ((A3A_NGSA_clickModeEnum + 1) mod 3) max 1;  // 1 or 2
    A3A_NGSA_toolModeChanged = true;
};
if ("c" in A3A_NGSA_depressedKeysHM) then {
    A3A_NGSA_modeConnect_roadTypeEnum = (A3A_NGSA_modeConnect_roadTypeEnum + 1) mod 3; // 0, 1 ,2
};

// Non-cancelling/conflicting items
private _actionExecuted = true;
switch (true) do {
    case ((A3A_NGSA_depressedKeysHM getOrDefault ["s",[]]) isEqualTo [false,true,false]): {   // ctrl + s
        call A3A_fnc_NGSA_action_save;
    };
    case ((A3A_NGSA_depressedKeysHM getOrDefault ["r",[]]) isEqualTo [false,true,false]): {   // ctrl + r
        [] spawn A3A_fnc_NGSA_action_refresh;
    };
    case ((A3A_NGSA_depressedKeysHM getOrDefault ["d",[]]) isEqualTo [false,true,false]): {   // ctrl + d
        switch ([localNamespace,"A3A_NGPP","draw","specialColouring", "none"] call Col_fnc_nestLoc_get) do {
            case "none": {[localNamespace,"A3A_NGPP","draw","specialColouring", "islandID"] call Col_fnc_nestLoc_set;};
            case "islandID": {[localNamespace,"A3A_NGPP","draw","specialColouring", "islandIDDeadEnd"] call Col_fnc_nestLoc_set;};
            default {[localNamespace,"A3A_NGPP","draw","specialColouring", "none"] call Col_fnc_nestLoc_set;};
        };
        private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
        if (count _navGridHM <= A3A_NGSA_autoMarkerRefreshNodeMax) then {
            [true] call A3A_fnc_NGSA_action_refresh;
        } else {

        };
        [
            "Street Artist Help",
            "<t size='1' align='left'>Colour Mode Changed to <t color='#f0d498'>'"+([localNamespace,"A3A_NGPP","draw","specialColouring", "none"] call Col_fnc_nestLoc_get)+"'</t><br/>"+
            "Remember to refresh To apply colour changes! (<t color='#f0d498'>'ctrl'+'R'</t>)<br/>"+
            "<br/>"+
            "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Colour Divisions</t><br/>"+   // The titles use a special space for the underlining to work.
            "<t color='#f0d498'>'none'</t>-Road by type, Nodes by connections.<br/>"+
            "<t color='#f0d498'>'islandID'</t>-Road &amp; Nodes by islandID.<br/>"+
            "<t color='#f0d498'>'islandIDDeadEnd'</t>-islandID with red dead ends.<br/>"+
            "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>General</t><br/>"+
            "<t color='#f0d498'>'F'</t>-Cycle tool<br/>"+
            "<t color='#f0d498'>'ctrl'+'S'</t>-Export changes<br/>"+
            "<t color='#f0d498'>'ctrl'+'D'</t>-Cycle Island Colour Division.<br/>"+
            "<t color='#f0d498'>'ctrl'+'R'</t>-Refresh Markers<br/>"+
            "</t>",
            true
        ] call A3A_fnc_customHint;
    };
    default {
        _actionExecuted = false;
    }
};

_actionExecuted;
