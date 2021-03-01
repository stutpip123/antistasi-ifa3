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
    [_worldPos ,_shift, _ctrl, _alt] call A3A_fnc_NGSA_onModeConnect;
*/
params ["_worldPos", "_shift", "_ctrl", "_alt"];

private _navGridPosRegionHM = [localNamespace,"A3A_NGPP","navGridPosRegionHM",0] call Col_fnc_nestLoc_get;
private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;

private _targetPos = [];
private _closestDistance = A3A_NGSA_maxSelectionRadius;
{
    private _distance = _x distance2D _worldPos;
    if (_distance < _closestDistance) then {
        _closestDistance = _distance;
        _targetPos = _x;
    };
} forEach ([_navGridPosRegionHM,_worldPos] call A3A_fnc_NGSA_posRegionHM_allAdjacent);

private _targetStruct = [];
if (count _targetPos != 0) then {
    _targetStruct = _navGridHM get _targetPos;
};

private _marker_dots = [localNamespace,"A3A_NGPP","draw","markers_road",[]] call Col_fnc_nestLoc_get;             // Prefixed with NGPP_dot_ + _myName

private _deselect = {
    A3A_NGSA_modeConnect_selectedExists = false;
    A3A_NGSA_modeConnect_selectedNode = [];
    A3A_NGSA_modeConnect_selMarkerName setMarkerType "Empty"; // Broadcasts here
};
private _select = {
    params ["_struct"];
    call _deselect;
    A3A_NGSA_modeConnect_selectedNode = _struct;
    A3A_NGSA_modeConnect_selectedExists = true;

    A3A_NGSA_modeConnect_selMarkerPos = _struct#0;
    A3A_NGSA_modeConnect_selMarkerName setMarkerPosLocal A3A_NGSA_modeConnect_selMarkerPos;
    A3A_NGSA_modeConnect_selMarkerName setMarkerType "mil_start_noShadow"; // Broadcasts here
};

if (_targetStruct isEqualTo A3A_NGSA_modeConnect_selectedNode || count _targetStruct == 0) exitWith { call _deselect; };   // Deselect
// Select
if (A3A_NGSA_modeConnect_selectedExists) then {
    [A3A_NGSA_modeConnect_selectedNode,_targetStruct,A3A_NGSA_modeConnect_roadTypeEnum] call A3A_fnc_NGSA_toggleConnection;
};
[_targetStruct] call _select;
