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
    [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_hover_modeConnect;
*/
params ["_worldPos"];

A3A_NGSA_modeConnect_lineName setMarkerAlpha 0;// Broadcasts
if (A3A_NGSA_depressedKeysHM get "shift") then {
    A3A_NGSA_brushSelectionRadius = (A3A_NGSA_brushSelectionRadius*2) min 1000;    // Is reset every cycle, so it won't keep growing.
};

A3A_NGSA_UI_marker0_name setMarkerShapeLocal "ELLIPSE";
A3A_NGSA_UI_marker0_name setMarkerSizeLocal [A3A_NGSA_brushSelectionRadius, A3A_NGSA_brushSelectionRadius];

A3A_NGSA_UI_marker1_name setMarkerShapeLocal "ELLIPSE";
A3A_NGSA_UI_marker1_name setMarkerSizeLocal [A3A_NGSA_brushSelectionRadius, A3A_NGSA_brushSelectionRadius];
A3A_NGSA_UI_marker1_name setMarkerBrushLocal "Border";
switch (true) do {
    case (A3A_NGSA_depressedKeysHM get "alt"): {
        A3A_NGSA_UI_marker0_name setMarkerBrushLocal "FDiagonal";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorRed";
        A3A_NGSA_UI_marker1_name setMarkerColorLocal "ColorRed";

        if (A3A_NGSA_depressedKeysHM get "LeftMouseButton") then {
            [_worldPos,A3A_NGSA_depressedKeysHM get "shift", A3A_NGSA_depressedKeysHM get "ctrl", true] call A3A_fnc_NGSA_click_modeBrush;
        };
    };
    default {
        private _roadColour = ["ColorOrange","ColorYellow","ColorGreen"] # A3A_NGSA_modeConnect_roadTypeEnum;
        A3A_NGSA_UI_marker0_name setMarkerBrushLocal "Cross";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal _roadColour;
        A3A_NGSA_UI_marker1_name setMarkerColorLocal _roadColour;

        if (A3A_NGSA_depressedKeysHM get "LeftMouseButton") then {
            [_worldPos,A3A_NGSA_depressedKeysHM get "shift", A3A_NGSA_depressedKeysHM get "ctrl", false] call A3A_fnc_NGSA_click_modeBrush;
        };
    };
};
A3A_NGSA_UI_marker0_name setMarkerPos _worldPos; // Broadcasts here
A3A_NGSA_UI_marker1_name setMarkerPos _worldPos; // Broadcasts here
