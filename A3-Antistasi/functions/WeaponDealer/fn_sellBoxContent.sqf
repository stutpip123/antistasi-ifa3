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

params ["_box"];

waitUntil {!(_box getVariable ["CurrentlySelling", false])};
_box setVariable ["CurrentlySelling", true, true];

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
};

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
    diag_log format ["Container is %1", _x];
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
    ServerInfoArray("Content of the box:", _allContent);
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
    ["Selling", "The vender is checking your offer!"] call A3A_fnc_customHint;
}
else
{
    ["Selling", "There is nothing in the box which can be sold!"] call A3A_fnc_customHint;
};

_box setVariable ["CurrentlySelling", false, true];

/*
{
    private _itemIndex = missionNamespace getVariable (format ["%1_data", _x]);

    private _price = round (10 * ([_itemIndex # 1] call _priceModifier) * (_itemIndex # 0)) * 5;
    if(_)
} forEach (itemCargo _box);
*/
