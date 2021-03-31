#include "..\..\Includes\common.inc"
FIX_LINE_NUMBERS()

private _arraysToMerge = _this select {count _x != 0};

private _result = [];
private _arrayIndex = -1;
private _weapon = "";
private _score = -1;
private _element = "";
private _data = [];
while {count _arraysToMerge > 0} do
{
    //Check each array for the currently first
    {
        _element = _x#0;
        _data = missionNamespace getVariable [format ["%1_data", _element], [-1, 0, 0]];
        if(_data#0 == -1) then
        {
            Error_1("Weapon %1 has no data defined", _element);
        }
        else
        {
            if(_score == -1 || _score > (_data#0)) then
            {
                _arrayIndex = _forEachIndex;
                _weapon = _element;
                _score = (_data#0);
            };
        };
    } forEach _arraysToMerge;

    //Worst rated weapon selected, deleting it now
    (_arraysToMerge#_arrayIndex) deleteAt 0;
    if(count (_arraysToMerge#_arrayIndex) == 0) then
    {
        _arraysToMerge deleteAt _arrayIndex;
    };

    _result pushBack _weapon;
    _weapon = "";
    _score = -1;
    _arrayIndex = -1;
};

Debug("Weapons sorted result is:");
Debug_1("%1", _result apply {getText (configFile >> "CfgWeapons" >> _x >> "displayName");});
/*
[
"Sting 9 mm","Vermin SMG .45 ACP","Mk20C 5.56 mm (Camo)",
"Mk20C 5.56 mm","CAR-95 5.8 mm (Black)","PDW2000 9 mm",
"Mk20 EGLM 5.56 mm (Camo)","Mk20 EGLM 5.56 mm","TRG-20 5.56 mm",
"Mk20 5.56 mm (Camo)","Mk20 5.56 mm","TRG-21 5.56 mm",
"Mk200 6.5 mm","MXC 6.5 mm (Black)","MXC 6.5 mm",
"Katiba Carbine 6.5 mm","TRG-21 EGLM 5.56 mm",
"CAR-95 GL 5.8 mm (Black)","MX SW 6.5 mm (Black)","MX SW 6.5 mm",
"MX 3GL 6.5 mm (Black)","MX 3GL 6.5 mm","CAR-95-1 5.8mm (Black)",
"MX 6.5 mm (Black)","MX 6.5 mm","Katiba 6.5 mm",
"Katiba GL 6.5 mm","SDAR 5.56 mm","MXM 6.5 mm (Black)",
"MXM 6.5 mm","Zafir 7.62 mm","CMR-76 6.5 mm (Black)",
"Rahim 7.62 mm","Mk18 ABR 7.62 mm","M320 LRR .408 (Camo)",
"M320 LRR .408","GM6 Lynx 12.7 mm (Camo)","GM6 Lynx 12.7 mm"
]
*/
_result;
