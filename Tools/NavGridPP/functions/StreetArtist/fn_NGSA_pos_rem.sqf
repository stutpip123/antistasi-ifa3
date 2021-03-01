/*
Maintainer: Caleb Serafin
    Removes a road reference from navGridHM and posRegionHM

Arguments:
    <HASHMAP<POS2D,ANY>>    Position as Key.
    <HASHMAP<
        <POS2D>             Region code Key. (Not real pos)
        <ARRAY<POS2D>>      List of actual positions in region
    >
    <POS2D>                 Position to remove

Return Value:
    <BOOLEAN> true if at least one was deleted, false if none were found.

Scope: Any
Environment: Any
Public: No

Example:
    [_navGridHM,_posRegionHM,_pos] call A3A_fnc_NGSA_pos_rem;
*/
params [
    "_navGridHM",
    "_posRegionHM",
    ["_pos",[],[ [] ],[2]]
];

private _bucket = _posRegionHM getOrDefault [[floor (_pos#0 / 100),floor (_pos#1 / 100)],A3A_NG_const_emptyArray];  // the empty array will not be modified or passed.
!isNil{_bucket deleteAt (_bucket find _pos)} || !isNil{_navGridHM deleteAt _pos};   // whether it was found deleted or not.
