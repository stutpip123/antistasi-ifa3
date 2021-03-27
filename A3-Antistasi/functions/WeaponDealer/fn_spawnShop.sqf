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
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS, RIFLES, EXPLOSIVES, VESTS, BACKPACKS, NVG, GRENADES, HELMET]];
        };
        case ("Land_CampingTable_F"):
        {
            private _tableForward = vectorDir _asset;
            private _tableSide = _tableForward vectorCrossProduct [0, 0, 1];
            private _pos = (getPosWorld _asset) vectorAdd (_tableSide vectorMultiply -0.5) vectorAdd [0, 0, 0.45];
            private _rot = [150 + (getDir _asset), 0, 0];
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS, EXPLOSIVES, PISTOLS, ITEM, GRENADES]];
            _pos = (getPosWorld _asset) vectorAdd (_tableSide vectorMultiply 0.5) vectorAdd [0, 0, 0.45];
            _result pushBack [_asset, _pos, _rot, []];
        };
        case ("Land_MapBoard_01_Wall_F"):
        {
            private _pos = (getPosWorld _asset) vectorAdd ((vectorDir _asset) vectorMultiply 0.05);
            private _rot = [getDir _asset + 180, 270, 0];
            _result pushBack [_asset, _pos, _rot, [LAUNCHERS, AMMUNITION, ATTACHMENT, VESTS, BACKPACKS, NVG, GRENADES, HELMET, ITEM]];
        };
    };
    _result;
};

private _fnc_chooseSpawnItem =
{
    params ["_chooseArray", "_blockArray", "_supportPoint"];
    private _arrayCopy = +_chooseArray;

    {
        _arrayCopy set [_x, 0];
    } forEach _blockArray;

    private _selection = shopArrayComplete selectRandomWeighted _arrayCopy;
    private _spawnItem = "";
    if(_selection#2) then
    {
        _spawnItem = selectRandom (_selection#0);
    }
    else
    {
        private _itemCount = (count (_selection#0)) - 1;
        private _spawnItemIndex = random [0, round (_supportPoint * _itemCount), _itemCount];
        _spawnItem = (_selection#0)#_spawnItemIndex;
    };

    _chooseArray set [_selection#1, (_chooseArray#(_selection#1)) - 1];
    [_selection#1, _spawnItem, _chooseArray];
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

private _chooseArray = [4, 6, 2, 2, 4, 4, 1, 1, 1, 1, 2, 1];
{
    private _itemData = [_chooseArray, _x#3, _citySupportRatio] call _fnc_chooseSpawnItem;
    private _itemType = _itemData#0;
    private _item = _itemData#1;
    _chooseArray = _itemData#2;
    diag_log format ["Selected %1 of type %2", _item, _itemType];
    /*
    private _arrow = (format ["Weapon_%1", (selectRandom lootWeapon)]) createVehicle _garagePos;
    _arrow setPosWorld (_x#1);
    [_arrow, _x#2] call BIS_fnc_setObjectRotation;
    _arrow setDamage 1;
    _arrow addAction ["Buy weapon for 250", {hint "Weapon bought!";}];
    _arrow addAction ["Buy weapon supply for 15000", {hint "Weapon bought!";}];
    _arrow addAction ["Steal weapon", {hint "Weapon bought!";}];
    */
} forEach _slots;
