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

private _navGridPosRegionHM = [localNamespace,"A3A_NGPP","navGridPosRegionHM",0] call Col_fnc_nestLoc_get;
private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;

private _targetPos = [];
private _closestDistance = A3A_NGSA_maxSelectionRadius; // max selection
{
    private _distance = _x distance2D _worldPos;
    if (_distance < _closestDistance) then {
        _closestDistance = _distance;
        _targetPos = _x;
    };
} forEach ([_navGridPosRegionHM,_worldPos] call A3A_fnc_NGSA_posRegionHM_allAdjacent);

A3A_NGSA_modeConnect_targetExists = count _targetPos != 0;
if (A3A_NGSA_modeConnect_targetExists) then {
    A3A_NGSA_modeConnect_targetNode = _navGridHM get _targetPos;
};

A3A_NGSA_UI_marker0_pos = [_worldPos,_targetPos] select A3A_NGSA_modeConnect_targetExists;

private _lineColour = ["ColorOrange","ColorYellow","ColorGreen"] #A3A_NGSA_modeConnect_roadTypeEnum; // ["TRACK", "ROAD", "MAIN ROAD"]
private _lineStartPos = +A3A_NGSA_UI_marker1_pos;
private _lineEndPos = _targetPos;
private _lineBrush = "SolidFull";

if (A3A_NGSA_toolModeChanged) then {
    A3A_NGSA_UI_marker1_name setMarkerShapeLocal "ICON";
    A3A_NGSA_UI_marker0_name setMarkerShapeLocal "ICON";
};

A3A_NGSA_UI_marker1_name setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
A3A_NGSA_UI_marker1_name setMarkerType (["Empty","mil_start"] select (A3A_NGSA_modeConnect_selectedExists && A3A_NGSA_UI_marker0_pos isNotEqualTo A3A_NGSA_UI_marker1_pos));       // Broadcasts for selected marker.

A3A_NGSA_UI_marker1_name setMarkerColorLocal _lineColour;
A3A_NGSA_UI_marker0_name setMarkerColorLocal _lineColour;
A3A_NGSA_UI_marker0_name setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
A3A_NGSA_UI_marker0_name setMarkerTypeLocal (switch (true) do {       // Broadcast here.
    case ("shift" in A3A_NGSA_depressedKeysHM && [_worldPos] call A3A_fnc_NGSA_isValidRoad): {
        A3A_NGSA_UI_marker0_pos = _worldPos;
        _lineEndPos = _worldPos;
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
        "mil_destroy_noShadow";
    };
    case ("alt" in A3A_NGSA_depressedKeysHM): {
        A3A_NGSA_modeConnect_selectedExists = false;
        A3A_NGSA_modeConnect_selectedNode = [];
        A3A_NGSA_UI_marker1_name setMarkerType "Empty";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
        "KIA";
    };
    case (!A3A_NGSA_modeConnect_targetExists && !A3A_NGSA_modeConnect_selectedExists): {
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
        "selector_selectable"
    };
    case (!A3A_NGSA_modeConnect_targetExists): {
        _lineEndPos = _worldPos;
        A3A_NGSA_UI_marker0_name setMarkerSizeLocal [1,1];
        _lineBrush = "DiagGrid";
        "waypoint";
    };
    case (!A3A_NGSA_modeConnect_selectedExists): {
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorBlack";
        "selector_selectable"
    };
    case (A3A_NGSA_UI_marker0_pos isEqualTo A3A_NGSA_UI_marker1_pos): {
        A3A_NGSA_UI_marker0_name setMarkerSizeLocal [1,1];
        "waypoint"
    };
    case ((A3A_NGSA_modeConnect_targetNode#3) findIf {(_x#0) isEqualTo (A3A_NGSA_modeConnect_selectedNode#0)} != -1): {
        _lineColour = "ColorRed";
        _lineBrush = "DiagGrid";
        A3A_NGSA_UI_marker1_name setMarkerType "mil_objective";
        A3A_NGSA_UI_marker0_name setMarkerColorLocal "ColorRed";
        A3A_NGSA_UI_marker1_name setMarkerColorLocal "ColorRed";
        "mil_objective"
    };
    default {"mil_pickup"};
});
A3A_NGSA_UI_marker0_name setMarkerPos A3A_NGSA_UI_marker0_pos; // Broadcasts here



if (A3A_NGSA_modeConnect_selectedExists) then {
    A3A_NGSA_modeConnect_lineName setMarkerAlphaLocal 1;
    [A3A_NGSA_modeConnect_lineName,true,_lineStartPos,_lineEndPos,_lineColour,A3A_NGSA_lineBaseSize,_lineBrush] call A3A_fnc_NG_draw_line;
};