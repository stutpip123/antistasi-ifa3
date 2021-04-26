/*
Author: Wurzel0701
    The action of selling the inventory of the box in the shop

Arguments:
    <OBJECT> The box which inventory will be sold

Return Value:
    <NIL>

Scope: Local
Environment: Scheduled
Public: No
Dependencies:
    <NIL>

Example:
    [_mybox] call A3A_fnc_sellBoxContent;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

params ["_box"];

if(!local player) exitWith {};

if (player != player getVariable["owner", player]) exitWith
{
    ["Selling", "You cannot sell something while you are controlling AI"] call A3A_fnc_customHint;
};

if(!(isNull (objectParent player))) exitWith
{
    ["Selling", "You cannot sell something from inside a vehicle"] call A3A_fnc_customHint;
};

ServerInfo_1("%1 is about to sell the box to the vendor", player);

waitUntil {!(_box getVariable ["CurrentlySelling", false])};
_box setVariable ["CurrentlySelling", true, true];

private _fnc_sortIntoHashmap =
{
    params["_hashMap", "_item", "_list"];
    if(_item in _hashMap) then
    {
        _hashMap set [_item, (_hashMap get _item) + 1];
    }
    else
    {
        _hashMap set [_item, 1];
        _list pushBack _item;
    };
};

//Sort all content
private _allContent = [];
//Gets all items from the box and adds them
_allContent append (itemCargo _box);
//Gets all empty backpacks from the box and adds them
_allContent append ((backpackCargo _box) apply {[_x] call A3A_fnc_basicBackpack;});
//Gets all vest and backpacks with stuff inside them and adds them
{
    private _object = _x select 1;
    _allContent append (magazineCargo _object);
    _allContent append (itemCargo _object);
    _allContent append ((weaponsItemsCargo _object) select {count _x != 0});
} forEach (everyContainer _box);

{
    _allContent append (_x select {count _x != 0});
} forEach (weaponsItemsCargo _box);

_allContent append (magazineCargo _box);

if(count _allContent > 0) then
{
    private _hashMap = createHashMap;
    private _allUniqueTypes = [];
    {
        if(_x isEqualType []) then
        {
            [_hashMap, (_x select 0), _allUniqueTypes] call _fnc_sortIntoHashmap;
        }
        else
        {
            [_hashMap, _x, _allUniqueTypes] call _fnc_sortIntoHashmap;
        };
    } forEach _allContent;
    clearItemCargoGlobal _box;
    clearMagazineCargoGlobal _box;
    clearWeaponCargoGlobal _box;
    clearBackpackCargoGlobal _box;
    ["Selling", "The vendor is checking your offer!"] call A3A_fnc_customHint;

    //sleep 5;
    ServerInfo_2("%1 sends request to sell %2 items", player, count _allContent);
    [_hashMap, _allUniqueTypes, _box, player] remoteExec ["A3A_fnc_calculateSellPrice", 2];
}
else
{
    ["Selling", "There is nothing in the box which can be sold!"] call A3A_fnc_customHint;
    ServerInfo_1("%1 requested selling without anything in the box", player);
};

_box setVariable ["CurrentlySelling", false, true];
