params ["_object", "_configClass", "_item"];

private _displayName = getText (configFile >> _configClass >> _item >> "displayName");

_object addAction [format ["Buy %1 for 250", _displayName], {hint "Weapon bought!";}];
_object addAction [format ["Buy %1 supply for 15000", _displayName], {hint "Weapon bought!";}];
_object addAction [format ["Steal %1", _displayName], {hint "Weapon bought!";}];
