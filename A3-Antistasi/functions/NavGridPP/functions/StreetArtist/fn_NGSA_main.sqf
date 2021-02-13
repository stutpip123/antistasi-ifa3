/*
Maintainer: Caleb Serafin
    Starts the StreetArtist Editor.

Return Value:
    <ANY> Undefined

Scope: Clients, Global Arguments, Local Effect
Environment: Scheduled
Public: Yes

Example:
    ["something", player, 2.718281828, 4, nil, ["Tom","Dick","Harry"], ["UID123Money",0], "hint ""Hello World!"""] call A3A_fnc_standardizedHeader; // false
*/

call A3A_fnc_NG_import;

private _navIslands = [localNamespace,"A3A_NGPP","navIslands",[]] call Col_fnc_nestLoc_get;
private _navGrid = [_navIslands] call A3A_fnc_NG_convert_navIslands_navGrid;
[localNamespace,"A3A_NGPP","NavGrid",_navGrid] call Col_fnc_nestLoc_set;

[_navGrid] call A3A_fnc_NGSA_navRegions_generate;
call A3A_fnc_NGSA_EH_add;

[4,false,false,0.8,0] spawn A3A_fnc_NG_main_draw;
