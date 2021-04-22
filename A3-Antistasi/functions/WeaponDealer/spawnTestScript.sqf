private _garage = garage;

private _shopSize = 3;//(round (_citySupportRatio * 2)) + 1;
private _assets = [];

switch (_shopSize) do
{
    case (1):
    {
        _assets =
        [
            ["Land_CampingTable_small_F", [-3, 2.3, 0], 180],
            ["C_Soldier_VR_F", [-2, 2, -0.4], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Box_NATO_Equip_F", [-3, -2.2, 0], 90]
        ];
    };
    case (2):
    {
        _assets =
        [
            ["Land_CampingTable_small_F", [-3, 2.3, 0], 180],
            ["C_Soldier_VR_F", [-2, 2, -0.4], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [4.5, -2.2, 0], 0],
            ["C_Soldier_VR_F", [3.5, -1.9, -0.4], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Box_NATO_Equip_F", [-3, -2.2, 0], 90]
        ];
    };
    case (3):
    {
        _assets =
        [
            ["Land_CampingTable_small_F", [-3, 2.3, 0], 180],
            ["C_Soldier_VR_F", [-2, 2, -0.4], 180],
            ["Land_CampingTable_F", [-1, -2.2, 0], 0],
            ["Land_CampingTable_small_F", [4.5, -2.2, 0], 0],
            ["C_Soldier_VR_F", [3.5, -1.9, -0.4], 0],
            ["Land_CampingTable_small_F", [2, 2.3, 0], 180],
            ["Land_MapBoard_01_Wall_F", [0, 2.7, 1.25], 180],
            ["Land_MapBoard_01_Wall_F", [1.5, -2.6, 1.25], 0],
            ["Box_NATO_Equip_F", [-3, -2.2, 0], 90]
        ];
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
    //_slots append ([_asset] call _fnc_getSlotPositions);
} forEach _assets;
