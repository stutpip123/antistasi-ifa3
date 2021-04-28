#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()
//NOTA: TAMBIÉN LO USO PARA FIA
if (!isServer and hasInterface) exitWith{};

private ["_markerX","_groups","_soldiers","_positionX","_num","_dataX","_prestigeOPFOR","_prestigeBLUFOR","_esAAF","_params","_frontierX","_array","_countX","_groupX","_dog","_grp","_sideX"];
_markerX = _this select 0;

_groups = [];
_soldiers = [];

_positionX = getMarkerPos (_markerX);

_num = [_markerX] call A3A_fnc_sizeMarker;
_sideX = sidesX getVariable [_markerX,sideUnknown];
if ({if ((getMarkerPos _x inArea _markerX) and (sidesX getVariable [_x,sideUnknown] != _sideX)) exitWith {1}} count markersX > 0) exitWith {};
_num = round (_num / 100);

Debug_1("Spawning City Patrol in %1", _markerX);

_dataX = server getVariable _markerX;
//_prestigeOPFOR = _dataX select 3;
//_prestigeBLUFOR = _dataX select 4;
_prestigeOPFOR = _dataX select 2;
_prestigeBLUFOR = _dataX select 3;
_esAAF = true;
if (_markerX in destroyedSites) then
	{
	_esAAF = false;
	_params = [_positionX,Invaders,CSATSpecOp];
	}
else
{
    private _storeCooldown = server getVariable [format ["%1_storeCooldown"], -1];
    if(_storeCooldown < time) then
    {
        private _citySupportRatio = 0;
        private _citiesUnderControl = 0;
        {
            if(sidesX getVariable (_x) == teamPlayer && {!(_x in destroyedSites)}) then
            {
                _citiesUnderControl = _citiesUnderControl + 1;
            };
        } forEach citiesX;
        _citySupportRatio = _citiesUnderControl / (count citiesX);
        private _garageIndex = server getVariable [format ["%1_storeIndex", _markerX], -1];
        if(_garageIndex == -1) then
        {
            _garageIndex = round (random 1000);
            server setVariable [format ["%1_storeIndex", _markerX], _garageIndex];
        };
        private _garageTypes = ["Land_i_Garage_V1_F", "Land_i_Garage_V2_F"];
        private _garages = nearestObjects [getMarkerPos _markerX, _garageTypes, 250, true];
        _garages = _garages select {(typeOf _x) in _garageTypes};
        if(count _garages != 0) then
        {
            private _garage = _garages select (_garageIndex % (count _garages));
            [_garage, _citySupportRatio, _markerX] remoteExec ["A3A_fnc_spawnShop", 2];
        };
    };



	if (_sideX == Occupants) then
		{
		_num = round (_num * (_prestigeOPFOR + _prestigeBLUFOR)/100);
		_frontierX = [_markerX] call A3A_fnc_isFrontline;
		if (_frontierX) then
			{
			_num = _num * 2;
			_params = [_positionX, Occupants, groupsNATOSentry];
			}
		else
			{
			_params = [_positionX, Occupants, groupsNATOGen];
			};
		}
	else
		{
		_esAAF = false;
		_num = round (_num * (_prestigeBLUFOR/100));
		_array = [];
		{if (random 20 < skillFIA) then {_array pushBack (_x select 0)} else {_array pushBack (_x select 1)}} forEach groupsSDKSentry;
		_params = [_positionX, teamPlayer, _array];
		};
	};
if (_num < 1) then {_num = 1};

_countX = 0;
while {(spawner getVariable _markerX != 2) and (_countX < _num)} do
	{
	_groupX = _params call A3A_fnc_spawnGroup;
	sleep 1;
	if (_esAAF) then
		{
		if (random 10 < 2.5) then
			{
			_dog = [_groupX, "Fin_random_F",_positionX,[],0,"FORM"] call A3A_fnc_createUnit;
			[_dog] spawn A3A_fnc_guardDog;
			};
		};
	_nul = [leader _groupX, _markerX, "SAFE", "RANDOM", "SPAWNED","NOVEH2", "NOFOLLOW"] execVM "scripts\UPSMON.sqf";//TODO need delete UPSMON link
	_groups pushBack _groupX;
	_countX = _countX + 1;
	};

if ((_esAAF) or (_markerX in destroyedSites)) then
	{
	{_grp = _x;
	// Forced non-spawner for performance and consistency with other garrison patrols
	{[_x,"",false] call A3A_fnc_NATOinit; _soldiers pushBack _x} forEach units _grp;} forEach _groups;
	}
else
	{
	{_grp = _x;
	{[_x] spawn A3A_fnc_FIAinitBases; _soldiers pushBack _x} forEach units _grp;} forEach _groups;
	};

waitUntil {sleep 1;(spawner getVariable _markerX == 2)};

{if (alive _x) then {deleteVehicle _x}} forEach _soldiers;
{deleteGroup _x} forEach _groups;
