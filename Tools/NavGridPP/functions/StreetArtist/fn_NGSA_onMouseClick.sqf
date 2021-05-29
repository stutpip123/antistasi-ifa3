/*
Maintainer: Caleb Serafin
    Called by event handler
    Calls specific modes.

Arguments:
    <DISPLAY> _display
    <SCALAR> _button
    <SCALAR> _xPos
    <SCALAR> _yPos
    <BOOLEAN> _shift
    <BOOLEAN> _ctrl
    <BOOLEAN> _alt

Return Value:
    <ANY> nil is not action. <BOOLEAN> True if action.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: No

Dependencies:
    <SCALAR> A3A_NGSA_clickModeEnum Currently select click mode

Example:
    findDisplay 12 displayAddEventHandler ["MouseButtonDown", {
        if (!XXX_Slayer_MouseDown) then {
            XXX_Slayer_MouseDown = true;
            _this call A3A_fnc_NGSA_onMouseClick;
        };
    }];
*/
params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

if (!visibleMap) exitWith {nil};
private _leftClick = _button isEqualTo 0;   // Will only be left or right
if !(_leftClick) exitWith {nil};

private _worldPos = ((findDisplay 12 displayCtrl 51 ctrlMapScreenToWorld [_xPos, _yPos]) call A3A_fnc_NGSA_getSurfaceATL) vectorAdd [0,0.08,0];  // The shift allows markers beneath it be be clicked on.

switch (A3A_NGSA_clickModeEnum) do {
    case 0: {       // Connections
        [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_click_modeConnect;
    };
    case 1: {       // Node Deletion brush
        // All done in onUIUpdate
        true;
    };
    case 2: {       // Toggle Render region
        nil;
    };
    default {       // Error
        nil;
    };
};
