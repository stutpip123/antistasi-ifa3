/*
Maintainer: Caleb Serafin
    Removes a _roadStruct reference from navRegions

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
    <LOCATION> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "NavRegions")
    <HASHMAP> nestLoc entry at (localNamespace >> "A3A_NGPP" >> "navGridHM")

Example:
    findDisplay 12 displayAddEventHandler ["MouseButtonDown", {
        if (!XXX_Slayer_MouseDown) then {
            XXX_Slayer_MouseDown = true;
            _this call A3A_fnc_NGSA_onMouseClick;
        };
    }];
*/
params ["_display", "_button", "_xPos", "_yPos", "_shift", "_ctrl", "_alt"];

private _leftClick = _button isEqualTo 0;   // Will only be left or right

private _map = findDisplay 12;
private _worldPos = _map displayCtrl 51 ctrlMapScreenToWorld [_xPos, _yPos];


private _navRegions = [localNamespace,"A3A_NGPP","NavRegions",0] call Col_fnc_nestLoc_get;
private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;

_targetPos = [_navRegions,_worldPos] call A3A_fnc_NGSA_navRegions_getPos;
private _targetStruct = [];
if (count _targetPos != 0 && {_targetPos distance2D _worldPos < 50}) then {
    _targetStruct = _navGridHM get _targetPos;
};

private _marker_dots = [localNamespace,"A3A_NGPP","draw","dotOnRoads_markers",[]] call Col_fnc_nestLoc_get;             // Prefixed with NGPP_dot_ + _myName
private _marker_lines = [localNamespace,"A3A_NGPP","draw","linesBetweenRoads_markers_line",[]] call Col_fnc_nestLoc_get;    // Prefixed with NGPP_line_ _ (_myName + _otherName) (we will exclude distance)
private _marker_distances = [localNamespace,"A3A_NGPP","draw","linesBetweenRoads_markers_distance",[]] call Col_fnc_nestLoc_get;    // Prefixed with NGPP_line_ _ (_myName + _otherName) (we will exclude distance)

private _deselect = {
    A3A_NGSA_selectedStruct = [];
    deleteMarker A3A_NGSA_selectionMarker;
    A3A_NGSA_selectionMarker = "";
};
private _select = {
    params ["_struct"];
    call _deselect;
    A3A_NGSA_selectedStruct = _struct;

    private _name = str (_struct#0);
    A3A_NGSA_selectionMarker = createMarkerLocal [_name,_struct#0];
    _name setMarkerTypeLocal "Select";
    _name setMarkerSizeLocal [1.2, 1.2];
    _name setMarkerColor "colorRed"; // Broadcasts here
};

if (_leftClick) then {
    if (_targetStruct isEqualTo A3A_NGSA_selectedStruct || count _targetStruct == 0) exitWith { call _deselect; };   // Deselect
    // Select
    if !(A3A_NGSA_selectedStruct isEqualTo A3A_NG_const_emptyArray) then {
        [A3A_NGSA_selectedStruct,_targetStruct] call A3A_fnc_NGSA_toggleConnection;
    };
    [_targetStruct] call _select;

} else {
    if (count _targetStruct == 0) exitWith {};
    ["Street Artist","Re-Drawing and exported."] call A3A_fnc_customHint;
    [] spawn A3A_fnc_NGSA_export;
};
