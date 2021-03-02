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
    <ANY> nil.

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

if (!visibleMap) exitWith {};
private _leftClick = _button isEqualTo 0;   // Will only be left or right
if !(_leftClick) exitWith {};

private _worldPos = findDisplay 12 displayCtrl 51 ctrlMapScreenToWorld [_xPos, _yPos];

 switch (A3A_NGSA_clickModeEnum) do {
    case 0: { };    // Nothing
    case 1: {       // Connections
        [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_click_modeConnect;
    };
    case 2: {       // Node Deletion brush
        // All done in onUIUpdate
    };
    case 3: {       // Toggle Render region

    };
    default {       // Error

    };
};

nil;
