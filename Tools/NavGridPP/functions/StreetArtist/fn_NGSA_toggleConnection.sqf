/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from navRegions

Arguments:
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct 1
    <<OBJECT>,<ARRAY<OBJECT>>,<ARRAY<SCALAR>>> Road Struct 2

Return Value:
    <BOOLEAN> true if deleted, false if not found.

Scope: Client, Local Arguments, Local Effect
Environment: Unscheduled
Public: No
Dependencies:
    <LOCATION> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "NavRegions")

Example:
    findDisplay 12 displayAddEventHandler ["MouseButtonDown", {
        if (!XXX_Slayer_MouseDown) then {
            XXX_Slayer_MouseDown = true;
            _this call A3A_fnc_NGSA_onMouseClick;
        };
    }];
*/
params [
    ["_leftStruct",[],[ [] ], [4]],
    ["_rightStruct",[],[ [] ], [4]],
    ["_connectionTypeEnum",0,[ 0 ]]
];

private _leftPos = _leftStruct#0;
private _rightPos = _rightStruct#0;

private _leftConnections = _leftStruct#3;
private _rightConnections = _rightStruct#3;

private _marker_lines = [localNamespace,"A3A_NGPP","draw","linesBetweenRoads_markers_line",[]] call Col_fnc_nestLoc_get;    // Prefixed with NGPP_line_ + (_myName + _otherName) (we will exclude distance)

private _midPoint = _leftPos vectorAdd _rightPos vectorMultiply 0.5 select A3A_NG_const_pos2DSelect;
private _name = "A3A_NG_Line_"+str _midPoint;

if (_rightConnections findIf {(_x#0) isEqualTo _leftPos} != -1) then { // If connected, then disconnect.
    ["Street Artist","Disconnected"] call A3A_fnc_customHint;
    private _rightInLeft = _leftConnections findIf {(_x#0) isEqualTo _rightPos};
    _leftConnections deleteAt _rightInLeft;

    private _leftInRight = _rightConnections findIf {(_x#0) isEqualTo _leftPos};
    _rightConnections deleteAt _leftInRight;

    deleteMarker _name;
    _marker_lines deleteAt _name;
} else {    // If not connected, then connect.
    ["Street Artist","Connected"] call A3A_fnc_customHint;
    private _distance = _leftPos distance2D _rightPos;
    _leftConnections pushBack [_rightPos,_connectionTypeEnum,_distance];
    _rightConnections pushBack [_leftPos,_connectionTypeEnum,_distance];

    private _const_roadColourClassification = ["ColorOrange","ColorYellow","ColorGreen"]; // ["TRACK", "ROAD", "MAIN ROAD"]
    private _colour = _const_roadColourClassification #_connectionTypeEnum;

    [_name,false,_leftPos,_rightPos,_colour,4,"Solid"] call A3A_fnc_NG_draw_line;
};
