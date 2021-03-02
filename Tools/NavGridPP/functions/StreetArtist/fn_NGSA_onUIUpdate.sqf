/*
Maintainer: Caleb Serafin
    Called by event handler
    Calls specific modes.

Return Value:
    <ANY> nil.

Scope: Client, Local Arguments, Global Effect
Environment: Unscheduled
Public: No

Dependencies:
    <SCALAR> A3A_NGSA_clickModeEnum Currently select click mode

Example:
    private _missionEH_eachFrame_ID = addMissionEventHandler ["EachFrame", {
        call A3A_fnc_NGSA_onUIUpdate;
    }];
*/
private _mousePos = getMousePosition;
private _mapTexture = findDisplay 12 displayCtrl 51;
private _worldPos = _mapTexture ctrlMapScreenToWorld _mousePos;
private _mapScale = ctrlMapScale _mapTexture;
A3A_NGSA_maxSelectionRadius = worldSize / 16 * _mapScale;     // Note, due to map regions, the max distance will be between 100m and 282.8m.

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

A3A_NGSA_hoverTargetExists = count _targetPos != 0;
if (A3A_NGSA_hoverTargetExists) then {
    A3A_NGSA_hoverTargetStruct = _navGridHM get _targetPos;
};


if !(A3A_NGSA_onUIUpdate_refresh || _targetPos isNotEqualTo A3A_NGSA_hoverMarkerCurrentPos) exitWith {};
A3A_NGSA_onUIUpdate_refresh = false;

A3A_NGSA_hoverMarkerCurrentPos = [_worldPos,_targetPos] select A3A_NGSA_hoverTargetExists;

switch (A3A_NGSA_clickModeEnum) do {
    case 0: { };    // Nothing
    case 1: {       // Connections
        A3A_NGSA_hoverLineEnabled = A3A_NGSA_modeConnect_selectedExists;
        A3A_NGSA_hoverLineColour = ["ColorOrange","ColorYellow","ColorGreen"] select A3A_NGSA_modeConnect_roadTypeEnum; // ["TRACK", "ROAD", "MAIN ROAD"]
        A3A_NGSA_hoverLineStartPos = +A3A_NGSA_modeConnect_selMarkerPos;
        A3A_NGSA_hoverLineBrush = "SolidFull";
        A3A_NGSA_hoverLineEndPos = _targetPos;

        A3A_NGSA_modeConnect_selMarkerName setMarkerType (["Empty","mil_start_noShadow"] select (A3A_NGSA_modeConnect_selectedExists && A3A_NGSA_hoverMarkerCurrentPos isNotEqualTo A3A_NGSA_modeConnect_selMarkerPos));       // Broadcasts for selected marker.

        A3A_NGSA_hoverMarkerCurrentName setMarkerSizeLocal [A3A_NGSA_dotBaseSize*0.8, A3A_NGSA_dotBaseSize*0.8];
        A3A_NGSA_hoverMarkerCurrentName setMarkerType (switch (true) do {       // Broadcast here.
            case (A3A_NGSA_depressedKeysHM get "shift" && [_worldPos] call A3A_fnc_NGSA_isValidRoad): {
                A3A_NGSA_hoverMarkerCurrentPos = _worldPos;
                A3A_NGSA_hoverLineEndPos = _worldPos;
                "mil_destroy_noShadow";
            };
            case (A3A_NGSA_depressedKeysHM get "alt"): {
                A3A_NGSA_modeConnect_selectedExists = false;    // Will also deselect current marker.
                A3A_NGSA_modeConnect_selectedNode = [];
                A3A_NGSA_modeConnect_selMarkerName setMarkerType "Empty"; // Broadcasts here

                A3A_NGSA_hoverLineEnabled = false;
                "KIA";
            };
            case (!A3A_NGSA_hoverTargetExists && !A3A_NGSA_modeConnect_selectedExists): {"empty"};
            case (!A3A_NGSA_hoverTargetExists): {
                A3A_NGSA_hoverLineEndPos = _worldPos;
                A3A_NGSA_hoverMarkerCurrentName setMarkerSizeLocal [1,1];
                A3A_NGSA_hoverLineBrush = "DiagGrid";
                "waypoint";
            };
            case (!A3A_NGSA_modeConnect_selectedExists): {"selector_selectable"};
            case (A3A_NGSA_hoverMarkerCurrentPos isEqualTo A3A_NGSA_modeConnect_selMarkerPos): {
                A3A_NGSA_hoverMarkerCurrentName setMarkerSizeLocal [1,1];
                "waypoint"
            };
            case ((A3A_NGSA_hoverTargetStruct#3) findIf {(_x#0) isEqualTo (A3A_NGSA_modeConnect_selectedNode#0)} != -1): {
                A3A_NGSA_hoverLineColour = "ColorRed";
                A3A_NGSA_hoverLineBrush = "DiagGrid";
                A3A_NGSA_modeConnect_selMarkerName setMarkerType "mil_objective_noShadow";
                "mil_objective_noShadow"
            };
            default {"mil_pickup_noShadow"};
        });
        A3A_NGSA_hoverMarkerCurrentName setMarkerPos A3A_NGSA_hoverMarkerCurrentPos;
    };
    case 2: {       // Brush Node Deletion/Connection Types

    };
    case 3: {       // Toggle Render region

    };
    default {       // Error

    };
};

if (A3A_NGSA_hoverLineEnabled) then {
    A3A_NGSA_hoverLineName setMarkerAlphaLocal 1;
    [A3A_NGSA_hoverLineName,true,A3A_NGSA_hoverLineStartPos,A3A_NGSA_hoverLineEndPos,A3A_NGSA_hoverLineColour,A3A_NGSA_lineBaseSize,A3A_NGSA_hoverLineBrush] call A3A_fnc_NG_draw_line;
} else {
    A3A_NGSA_hoverLineName setMarkerAlpha 0;// Broadcasts
};

nil;
