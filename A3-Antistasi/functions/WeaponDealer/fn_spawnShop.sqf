#define SHOP_SIZE_SMALL     1
#define SHOP_SIZE_MEDIUM    2
#define SHOP_SIZE_LARGE     3

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



params
[
    ["_garage", objNull, [objNull]],
    ["_citySupportRatio", 0, [0]]
];

private _shopSize = SHOP_SIZE_LARGE;//(round (_citySupportRatio * 2)) + 1;
private _assets = [];

switch (_shopSize) do
{
    case (SHOP_SIZE_SMALL):
    {
        _assets =
        [
            ["Land_CampingTable_F", [-2.5, 2.3, 0], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Box_NATO_Equip_F", [-3, -2.2, 0], 90]
        ];
    };
    case (SHOP_SIZE_MEDIUM):
    {
        _assets =
        [
            ["Land_CampingTable_F", [-2.5, 2.3, 0], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_F", [4, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Box_NATO_Equip_F", [-3, -2.2, 0], 90]
        ];
    };
    case (SHOP_SIZE_LARGE):
    {
        _assets =
        [
            ["Land_CampingTable_F", [-2.5, 2.3, 0], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_F", [4, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Land_MapBoard_01_Wall_F", [0, 2.7, 1.25], 180],
            ["Land_MapBoard_01_Wall_F", [1.5, -2.6, 1.25], 0],
            ["Box_NATO_Equip_F", [-3, -2.2, 0], 90]
        ];
    };
};

private _fnc_getSlotPositions =
{
    params ["_asset"];
    private _result = [];
    switch (typeOf _asset) do
    {
        case ("Land_CampingTable_small_F"):
        {
            private _pos = (getPosWorld _asset) vectorAdd [0, 0, 0.45];
            private _rot = [150 + (getDir _asset), 0, 0];
            _result pushBack [_asset, _pos, _rot, [RIFLES, EXPLOSIVES, VESTS, BACKPACKS, NVG, GRENADES, HELMET]];
        };
        case ("Land_CampingTable_F"):
        {
            private _tableForward = vectorDir _asset;
            private _tableSide = _tableForward vectorCrossProduct [0, 0, 1];
            private _pos = (getPosWorld _asset) vectorAdd (_tableSide vectorMultiply -0.5) vectorAdd [0, 0, 0.45];
            private _rot = [150 + (getDir _asset), 0, 0];
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS, EXPLOSIVES, PISTOLS, ITEM, GRENADES]];
            _pos = (getPosWorld _asset) vectorAdd (_tableSide vectorMultiply 0.5) vectorAdd [0, 0, 0.45];
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS]];
        };
        case ("Land_MapBoard_01_Wall_F"):
        {
            private _pos = (getPosWorld _asset) vectorAdd ((vectorDir _asset) vectorMultiply 0.05);
            private _rot = [getDir _asset + 180, 270, 0];
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS, AMMUNITION, ATTACHMENT, VESTS, BACKPACKS, NVG, GRENADES, HELMET, ITEM, EXPLOSIVES]];
        };
    };
    _result;
};

private _fnc_chooseSpawnItem =
{
    params ["_chooseArray", "_blockArray", "_supportPoint", "_alreadySelected"];
    private _arrayCopy = +_chooseArray;

    {
        _arrayCopy set [_x, 0];
    } forEach _blockArray;

    private _selection = shopArrayComplete selectRandomWeighted _arrayCopy;
    private _spawnItem = "";
    if(_selection#2) then
    {
        while {(_spawnItem == "") || (_spawnItem in _alreadySelected)} do
        {
            _spawnItem = selectRandom (_selection#0);
        };
    }
    else
    {
        while {(_spawnItem == "") || (_spawnItem in _alreadySelected)} do
        {
            private _itemCount = (count (_selection#0)) - 1;
            private _spawnItemIndex = random [0, round (_supportPoint * _itemCount), _itemCount];
            _spawnItem = (_selection#0)#_spawnItemIndex;
        };
    };

    _chooseArray set [_selection#1, (_chooseArray#(_selection#1)) - 1];
    [_selection#1, _spawnItem, _chooseArray];
};

private _fnc_spawnItem =
{
    params ["_type", "_item", "_slotPos", "_orientation"];
    private _object = objNull;
    switch (_type) do
    {
        case (PISTOLS);
        case (RIFLES);
        case (LAUNCHERS):
        {
            _object = (format ["Weapon_%1", _item]) createVehicle _slotPos;
            _object setPosWorld _slotPos;
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            _object setDamage 1;
            [_object, "CfgWeapons", _item] call A3A_fnc_addShopActions;
        };
        case (AMMUNITION):
        {
            _object = "Box_NATO_Ammo_F" createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.35]);
            _object setDir ((_orientation#0) - 60);
            _object setDamage 1;
            _object enableSimulation false;
            [_object, "CfgMagazines", _item] call A3A_fnc_addShopActions;
        };
        case (GRENADES):
        {
            _object = "Box_NATO_Grenades_F" createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.35]);
            _object setDir ((_orientation#0) - 60);
            _object setDamage 1;
            _object enableSimulation false;
            [_object, "CfgMagazines", _item] call A3A_fnc_addShopActions;
        };
        case (EXPLOSIVES):
        {
            //These are bitches, maybe find a better way
            _object = "Box_NATO_AmmoOrd_F" createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.35]);
            _object setDir ((_orientation#0) - 60);
            _object setDamage 1;
            _object enableSimulation false;
            [_object, "CfgMagazines", _item] call A3A_fnc_addShopActions;
        };
        case (ITEM);
        case (NVG);
        case (ATTACHMENT):
        {
            _object = (format ["Item_%1", _item]) createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.7]);
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            _object setDamage 1;
            [_object, "CfgWeapons", _item] call A3A_fnc_addShopActions;
        };
        case (VESTS):
        {
            _object = (format ["Vest_%1", _item]) createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.65]);
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            _object setDamage 1;
            [_object, "CfgWeapons", _item] call A3A_fnc_addShopActions;
        };
        case (BACKPACKS):
        {
            _object = _item createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.65]);
            //[_object, _orientation] call BIS_fnc_setObjectRotation;
            //_object setDamage 1;
            _object enableSimulation false;
            [_object, "CfgVehicles", _item] call A3A_fnc_addShopActions;
        };
        case (HELMET):
        {
            _object = (format ["Headgear_%1", _item]) createVehicle _slotPos;
            _object setPosWorld (_slotPos vectorAdd [0, 0, 0.65]);
            [_object, _orientation] call BIS_fnc_setObjectRotation;
            _object setDamage 1;
            [_object, "CfgWeapons", _item] call A3A_fnc_addShopActions;
        };
    };
};

private _garageRight = vectorDir _garage;
private _garageUp = vectorUp _garage;
private _garageForward = _garageRight vectorCrossProduct _garageUp;
private _garagePos = getPosWorld _garage;
private _garageDir = getDir _garage;
private _slots = [];

{
    private _assetPos = _garagePos vectorAdd (_garageForward vectorMultiply _x#1#0) vectorAdd (_garageRight vectorMultiply _x#1#1) vectorAdd (_garageUp vectorMultiply _x#1#2);
    private _asset = (_x#0) createVehicle _garagePos;
    _asset setDir (_x#2 + _garageDir);
    _asset setPosWorld (_assetPos vectorAdd [0,0,0.3]);
    _asset allowDamage false;
    _asset enableSimulation false;
    _slots append ([_asset] call _fnc_getSlotPositions);
} forEach _assets;

private _chooseArray = [3, 7, 2, 2, 5, 5, 2, 2, 1, 5, 3, 2];
private _alreadySelected = [];
{
    private _itemData = [_chooseArray, _x#3, _citySupportRatio, _alreadySelected] call _fnc_chooseSpawnItem;
    private _itemType = _itemData#0;
    private _item = _itemData#1;
    _alreadySelected pushBack _item;
    _chooseArray = _itemData#2;
    diag_log format ["Selected %1 of type %2", _item, _itemType];

    [_itemType, _item, _x#1, _x#2] call _fnc_spawnItem;
} forEach _slots;
