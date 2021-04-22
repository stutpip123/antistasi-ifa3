params ["_object", "_configClass", "_item", "_class"];

private _displayName = getText (configFile >> _configClass >> _item >> "displayName");

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

private _priceModifier = 1;
switch (_class) do
{
    case (PISTOLS):
    {
        _priceModifier = 0.8;
    };
    case (RIFLES):
    {
        _priceModifier = 3;
    };
    case (LAUNCHERS):
    {
        _priceModifier = 7;
    };
    case (EXPLOSIVES):
    {
        _priceModifier = 3;
    };
    case (AMMUNITION):
    {
        _priceModifier = 0.3;
    };
    case (ATTACHMENT):
    {
        _priceModifier = 2.8;
    };
    case (VESTS):
    {
        _priceModifier = 4.5;
    };
    case (BACKPACKS):
    {
        _priceModifier = 0.8;
    };
    case (NVG):
    {
        _priceModifier = 9;
    };
    case (ITEM):
    {
        _priceModifier = 0.1;
    };
    case (GRENADES):
    {
        _priceModifier = 3.5;
    };
    case (HELMET):
    {
        _priceModifier = 7;
    };
};
//Maybe get the score of the item in too
private _basePrice = round (10 * _priceModifier) * 5;
private _supplyPrice = round (_basePrice * exp (7/20)) * 10; //Replace 7 by the amount of already done purchases

_object addAction [format ["Buy %1 for %2", _displayName, _basePrice], {([_this select 0] + (_this select 3)) call A3A_fnc_singleBuyAction;}, [_item, _class, _displayName, _basePrice]];
//_object addAction [format ["Buy %1 supply for %2", _displayName, _supplyPrice], {hint "Weapon bought!";}];
//_object addAction [format ["Steal %1", _displayName], {hint "Weapon bought!";}];
