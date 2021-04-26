/*
Author: Wurzel0701
    Checks the given set of items and returns the price and items it does not takes

Arguments:
    <HASHMAP<STRING, INT>> The hashmap of the items to be sold and their amount
    <ARRAY> The list of keys in the hashmap
    <OBJECT> The box in which wrong items will be returned
    <OBJECT> The player which will be rewarded with the money

Return Value:
    <NIL>

Scope: Server
Environment: Any
Public: No
Dependencies:
    <NIL>

Example:
    [_myHash, _myList, _mybox, player] call A3A_fnc_calculateSellPrice;
*/

#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

#define PISTOLS             0
#define RIFLES              1
#define LAUNCHERS           2
#define EXPLOSIVES          3
#define AMMUNITION          4
#define ATTACHMENT          5
#define VESTS               6
#define BACKPACKS           7
#define NVG                 8
#define ITEM                9
#define GRENADES            10
#define HELMET              11

params ["_hashMap", "_list", "_box", "_player"];

private _fnc_getSellFactor =
{
    params ["_type"];
    private _priceModifier =0.5;
    switch (_type) do
    {
        case (PISTOLS):
        {
            _priceModifier = 0.5;
        };
        case (RIFLES):
        {
            _priceModifier = 1.2;
        };
        case (LAUNCHERS):
        {
            _priceModifier = 3;
        };
        case (EXPLOSIVES):
        {
            _priceModifier = 1.2;
        };
        case (AMMUNITION):
        {
            _priceModifier = 0.1;
        };
        case (ATTACHMENT):
        {
            _priceModifier = 1.2;
        };
        case (VESTS):
        {
            _priceModifier = 2;
        };
        case (BACKPACKS):
        {
            _priceModifier = 0.3;
        };
        case (NVG):
        {
            _priceModifier = 2.5;
        };
        case (ITEM):
        {
            _priceModifier = 0.03;
        };
        case (GRENADES):
        {
            _priceModifier = 1.7;
        };
        case (HELMET):
        {
            _priceModifier = 3.2;
        };
    };
    _priceModifier;
};

private _unlocked = (unlockedHeadgear + unlockedVests + unlockedNVGs + unlockedOptics + unlockedItems + unlockedWeapons + unlockedBackpacks + unlockedMagazines);
private _rejected = [];
private _money = 0;
{
    private _item = _x;
    private _itemIndex = missionNamespace getVariable [format ["%1_data", _item], []];
    if(count _itemIndex == 0 || {_itemIndex # 2 > 0 || {_item in _unlocked}}) then
    {
        _rejected pushBack _item;
    }
    else
    {
        private _amount = _hashMap get _item;
        private _factor = [_itemIndex # 1] call _fnc_getSellFactor;
        Info_3("Data:%1    Factor:%2    Value:%3", _itemIndex, _factor, _itemIndex # 0);

        private _price = round (10 * _factor * (_itemIndex # 0)) * 5;
        _money = _money + (_price * _amount);
    };
} forEach (_list);

private _rejectedAmount = 0;
{
    _rejectedAmount = _rejectedAmount + (_hashMap get _x);
    _box addItemCargoGlobal [_x, _hashMap get _x];
} forEach _rejected;

if(_rejectedAmount == 0) then
{
    ["Selling", format ["Sold all items for %1", _money]] remoteExec ["A3A_fnc_customHint", _player];
    [_money] remoteExec ["A3A_fnc_resourcesPlayer", _player];
}
else
{
    ["Selling", format ["Rejected %2 items, sold the rest for %1", _money, _rejectedAmount]] remoteExec ["A3A_fnc_customHint", _player];
    [_money] remoteExec ["A3A_fnc_resourcesPlayer", _player];
};
