/*
Maintainer: Caleb Serafin
    Returns the ASL height of the top surface under the specified point.

Arguments:
    <SCALAR> X Position
    <SCALAR> Y Position
    <SCALAR> Z Position ATL [Default=10000]

Return Value:
    <POSASL> position on surface.

Scope: Any
Environment: Any
Public: Yes
Dependencies:
    <OBJECT> A3A_NGSA_heightTester

Example:
    [123,456] call A3A_fnc_NGSA_getSurfaceATL;
*/
params [
    ["_xHeight",0,[0]],
    ["_yHeight",0,[0]],
    ["_zHeight",1000,[0]]
];

A3A_NGSA_heightTester setPosATL [_xHeight,_yHeight,_zHeight];
[_xHeight,_yHeight,_zHeight - ((getPos A3A_NGSA_heightTester)#2)];
