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
    A3A_NGSA_fullSelectionRadius = A3A_NGSA_fullSelectionRadius*2;    // Is reset every cycle, so it won't keep growing.
};

A3A_NGSA_UI_marker0_name setMarkerShapeLocal "ELLIPSE";
A3A_NGSA_UI_marker0_name setMarkerSizeLocal [A3A_NGSA_fullSelectionRadius, A3A_NGSA_fullSelectionRadius];
A3A_NGSA_UI_marker0_name setMarkerBrushLocal "Cross";
switch (true) do {
    case (A3A_NGSA_depressedKeysHM get "alt"): {
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorRed";

    };
    default {
        A3A_NGSA_UI_marker0_name setMarkerColorLocal (["ColorOrange","ColorYellow","ColorGreen"] select A3A_NGSA_modeConnect_roadTypeEnum);

    };
};