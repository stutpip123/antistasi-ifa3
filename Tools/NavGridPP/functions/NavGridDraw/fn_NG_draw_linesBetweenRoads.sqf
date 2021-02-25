/*
Maintainer: Caleb Serafin
    Draws lines between nodes.
    Previous markers make by this function are deleted.
    Colour depends on road type:
        MAIN ROAD  -> Green
        ROAD  -> Yellow
        TRACK  -> Orange

Arguments:
    <navGridHM>
    <SCALAR> Thickness of line, 1-high density, 4-normal, 8-Stratis world view, 16-Seattle world view. (Set to 0 to disable) (Default = 4)
    <BOOLEAN> False if line partially transparent, true if solid and opaque. (Default = false)
    <BOOLEAN> True to draw distance between road segments. (Only draws if above 5m) (Default = false)

Return Value:
    <ANY> undefined.

Scope: Any, Global Arguments, Global Effect
Environment: Scheduled
Public: Yes

Example:
    [_navGridHM,4,true,false] spawn A3A_fnc_NG_draw_linesBetweenRoads;
*/
params [
    "_navGridHM",
    ["_line_size",4,[ 0 ]],
    ["_line_opaque",false,[ false ]],
    ["_drawDistance",false,[ false ]]
];



private _fnc_diag_report = {
    params ["_diag_step_main"];

    private _hintData = [
        "Nav Grid++",
        "<t align='left'>" +
        "Drawing Lines" +
        _diag_step_main+"<br/>"+
        "</t>",
        true
    ];
    _hintData call A3A_fnc_customHint;
    _hintData remoteExec ["A3A_fnc_customHint",-clientOwner];
};

/*
_diag_step_main = "Deleting Old Markers";
call _fnc_diag_render;
private _markers = [localNamespace,"NavGridPP","draw","LinesBetweenRoads",[]] call Col_fnc_nestLoc_get;
{
    deleteMarker _x;
} forEach _markers;
_markers resize 0;  // Preserves reference
*/
private _const_roadColourClassification = ["ColorOrange","ColorYellow","ColorGreen"]; // ["TRACK", "ROAD", "MAIN ROAD"]
private _diag_totalSegments = count _navGridHM;

private _markers_old_line = [localNamespace,"NavGridPP","draw","linesBetweenRoads_markers_line", createHashMap] call Col_fnc_nestLoc_get;
private _markers_new_line = createHashMap;
[localNamespace,"NavGridPP","draw","linesBetweenRoads_markers_line", _markers_new_line] call Col_fnc_nestLoc_set;

private _markers_old_distance = [localNamespace,"NavGridPP","draw","linesBetweenRoads_markers_distance", createHashMap] call Col_fnc_nestLoc_get;
private _markers_new_distance = createHashMap;
[localNamespace,"NavGridPP","draw","linesBetweenRoads_markers_distance", _markers_new_distance] call Col_fnc_nestLoc_set;

if (_line_size > 0 || _drawDistance) then {
    private _processedMidPoints = createHashMap;

    private _line_brush = ["Solid","SolidFull"] select _line_opaque;
    {
        if (_forEachIndex mod 100 == 0) then {
            ("Completion &lt;" + ((100*_forEachIndex /_diag_totalSegments) toFixed 1) + "% &gt; Processing segment &lt;" + (str _forEachIndex) + " / " + (str _diag_totalSegments) + "&gt;") call _fnc_diag_report;
        };

        private _myPos = _x;
        {
            private _otherPos = _x#0;
            private _midPoint = _myPos vectorAdd _otherPos vectorMultiply 0.5 select A3A_NG_const_pos2DSelect;

            if !(_midPoint in _processedMidPoints) then {
                _processedMidPoints set [_midPoint,true];

                private _colour = _const_roadColourClassification #(_x#1);
                if (_line_size > 0) then {
                    private _name = "A3A_NG_Line_"+str _midPoint;
                    private _exists = _name in _markers_old_line;
                    _markers_old_line deleteAt _name;
                    _markers_new_line set [_name,true];

                    [_name,_exists,_myPos,_otherPos,_colour,_line_size,_line_brush] call A3A_fnc_NG_draw_line;
                };

                private _realDistance = _x#2;
                if (_drawDistance && (_realDistance > 5)) then {
                    private _name = "A3A_NG_Dist_"+str _midPoint;
                    private _exists = _name in _markers_old_distance;
                    _markers_old_distance deleteAt _name;
                    _markers_new_distance set [_name,true];

                    [_name,_exists,_midPoint,_colour,(_realDistance toFixed 0) + "m"] call A3A_fnc_NG_draw_text;
                };
            };

        } forEach ( (_navGridHM get _x) #3);
    } forEach keys _navGridHM;
};
{
    deleteMarker _x;
} forEach _markers_old_line;
{
    deleteMarker _x;
} forEach _markers_old_distance;

"Done drawing lines." call _fnc_diag_report;
