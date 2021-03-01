/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from posRegions

Arguments:
    <DISPLAY> _display
    <SCALAR> _button
    <SCALAR> _xPos
    <SCALAR> _yPos
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
    [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_onModeConnect;
*/
params ["_worldPos", "_shift", "_ctrl", "_alt"];

//private _navGridPosRegionHM = [localNamespace,"A3A_NGPP","navGridPosRegionHM",0] call Col_fnc_nestLoc_get;
//private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;

private _deselect = {
    A3A_NGSA_modeConnect_selectedExists = false;
    A3A_NGSA_modeConnect_selectedNode = [];
    A3A_NGSA_modeConnect_selMarkerName setMarkerType "Empty"; // Broadcasts here
};
private _select = {
    params ["_struct"];
    call _deselect;
    A3A_NGSA_modeConnect_selectedNode = _struct;
    A3A_NGSA_modeConnect_selectedExists = true;

    A3A_NGSA_modeConnect_selMarkerPos = _struct#0;
    A3A_NGSA_modeConnect_selMarkerName setMarkerPosLocal A3A_NGSA_modeConnect_selMarkerPos;
    A3A_NGSA_modeConnect_selMarkerName setMarkerType "mil_start_noShadow"; // Broadcasts here
};

switch (true) do {       // Broadcast here.
    case (A3A_NGSA_depressedKeysHM get "shift"): {
        // Add
    };
    case (!A3A_NGSA_hoverTargetExists): _deselect;
    case (A3A_NGSA_depressedKeysHM get "ctrl"): {
        // Remove
    };
    case (!A3A_NGSA_modeConnect_selectedExists): {
        [A3A_NGSA_hoverTargetStruct] call _select;
    };
    case (A3A_NGSA_hoverMarkerCurrentPos isEqualTo A3A_NGSA_modeConnect_selMarkerPos): _deselect;
    default {
        [A3A_NGSA_modeConnect_selectedNode,A3A_NGSA_hoverTargetStruct,A3A_NGSA_modeConnect_roadTypeEnum] call A3A_fnc_NGSA_toggleConnection;
        [A3A_NGSA_hoverTargetStruct] call _select;
    };
};
