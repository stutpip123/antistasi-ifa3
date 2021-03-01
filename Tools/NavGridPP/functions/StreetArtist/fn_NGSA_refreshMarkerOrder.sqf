/*
Maintainer: Caleb Serafin
    Deletes and recreates hover markers to make sure that they are on top.

Scope: Any, Global Effect
Environment: Unscheduled
Public: No
Dependencies:

Example:
    call A3A_fnc_NGSA_refreshMarkerOrder;
*/

deleteMarker A3A_NGSA_modeConnect_selMarkerName;
createMarkerLocal [A3A_NGSA_modeConnect_selMarkerName,A3A_NGSA_modeConnect_selMarkerPos];

deleteMarker A3A_NGSA_hoverLineName;
createMarkerLocal [A3A_NGSA_hoverLineName,A3A_NGSA_hoverLineStartPos];
if (A3A_NGSA_hoverLineEnabled) then {
    A3A_NGSA_hoverLineName setMarkerAlphaLocal 1;
    [A3A_NGSA_hoverLineName,true,A3A_NGSA_hoverLineStartPos,A3A_NGSA_hoverLineEndPos,A3A_NGSA_hoverLineColour,A3A_NGSA_lineBaseSize,A3A_NGSA_hoverLineBrush] call A3A_fnc_NG_draw_line;
} else {
    A3A_NGSA_hoverLineName setMarkerAlpha 0;// Broadcasts
};

deleteMarker A3A_NGSA_hoverMarkerCurrentName;
createMarkerLocal [A3A_NGSA_hoverMarkerCurrentName,A3A_NGSA_hoverMarkerCurrentPos];
