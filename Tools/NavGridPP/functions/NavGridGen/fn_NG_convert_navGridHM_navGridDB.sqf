/*
Maintainer: Caleb Serafin
    Converts navGridHM (Format used in navGridPP & StreetArtist) to navGridDB (format saved for A3-Antistasi).
    navGridHM connections are positions.
    navGridDB connections are array indices.
    Conversion is transparent (reversible).

Arguments:
    <navGridHM>

Return Value:
    <navGrdDB>

Scope: Any, Global Arguments
Environment: Scheduled
Public: Yes

Example:
    private _navGridDB = [navGridDB] call A3A_fnc_NG_convert_navIslands_navGridDB;
*/
params [
    "_navGridHM"
];

private _navGridDB = [];
private _posIndexHM = createHashMapFromArray (keys _navGridHM apply { [_x,_navGridDB pushBack (_navGridHM get _x)] });

{
    {
        _x set [0,_posIndexHM get (_x#0)]
    } forEach _x#3;  // _connections
} forEach _navGridDB;

_navGridDB;
