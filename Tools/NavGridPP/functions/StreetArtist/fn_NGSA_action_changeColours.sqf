/*
Maintainer: Caleb Serafin
    Cycles the marker colour mode and updates the map legend.

Return Value:
    <ANY> undefined.

Scope: Client, Local Arguments, Local Effect
Environment: Any
Public: No

Dependencies:
    <SCALAR> A3A_NGSA_autoMarkerRefreshNodeMax

Example:
    call A3A_fnc_NGSA_action_changeColours;
*/

private _colourModes = ["none","islandID","islandIDDeadEnd"];
private _newColourMode = [localNamespace,"A3A_NGPP","draw","specialColouring", "none"] call Col_fnc_nestLoc_get;
_newColourMode = _colourModes #(((_colourModes find _newColourMode) + 1) mod 3);
[localNamespace,"A3A_NGPP","draw","specialColouring", _newColourMode] call Col_fnc_nestLoc_set;

private _navGridHM = [localNamespace,"A3A_NGPP","navGridHM",0] call Col_fnc_nestLoc_get;
if (count _navGridHM <= A3A_NGSA_autoMarkerRefreshNodeMax) then {
    [true] call A3A_fnc_NGSA_action_refresh;
} else {

};

private _legends = [
    // none
    "<t color='#f0d498' align='center' underline='1'>Connection Types</t><br/>"+   // The titles use a special space for the underlining to work.
    "<t color='#f57a21'>Orange</t>-Track, dirt/narrow/bumpy<br/>"+
    "<t color='#cfc01c'>Yellow</t>-Road, asphalt/cement/smooth/<br/>"+
    "<t color='#26c91e'>Green</t>-Main Road, smooth/wide/large turns<br/>"+
    "<t color='#f0d498' align='center' underline='1'>Node Connections</t><br/>"+   // The titles use a special space for the underlining to work.
    "Black:0  Red:1  Orange:2<br/>"+
    "Yellow:3  Green:4  Blue:5+",
    // islandID
    "Islands are separated by "+ str A3A_NGSA_const_allMarkerColoursCount +" colours."+
    ,
    // islandIDDeadEnd
    "Islands are separated by "+ str A3A_NGSA_const_allMarkerColoursCount +" colours.<br/>"+
    +"<br/>"+
    "Nodes with one or zero connections are <t color='#c71716'>Red</t>.",
];
[
    "Marker Legend",
    "<t size='1' align='left'>"+
    (_legends#(_colourModes find _newColourMode))+
    "</t>",
    true,
    450
] call A3A_fnc_customHint;
[
    "Colour Mode Changed to <t color='#f0d498'>"+([localNamespace,"A3A_NGPP","draw","specialColouring", "none"] call Col_fnc_nestLoc_get)+"'</t>",
    "<t size='1' align='left'>"+
    "Remember to refresh To apply colour changes! (<t color='#f0d498'>'ctrl'+'R'</t>)"+
    "</t>",
    true,
    200
] call A3A_fnc_customHint;
