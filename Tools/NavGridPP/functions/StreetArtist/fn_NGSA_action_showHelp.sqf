/*
Maintainer: Caleb Serafin
    Shows help.

Return Value:
    <ANY> undefined.

Scope: Any, Global Effect
Environment: Any
Public: No

Example:
    call A3A_fnc_NGSA_action_showHelp;
*/

private _hintData = [
    "Street Artist Help",
    "<t size='0.7' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Key Binds</t>"+
    "<t align='left'>" +
    "'H'-View help."+
    "'C'-Cycle connection type<br/>"+
    "'F'-Cycle tool<br/>"+
    "'ctrl'+'s'-Export changes<br/>"+
    "</t><t size='0.7' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Connection Tool</t>"+
    "'click'-Select & connect roads<br/>"+
    "'shift'-Create new node<br/>"+
    "'alt'-Delete node<br/>"+
    "</t><t size='0.7' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Brush Tool</t>"+
    "'click'-Set connection type<br/>"+
    "'shift'-Double brush size<br/>"+
    "'alt'-Delete all nodes<br/>"+
    "</t>",
    true
];
_hintData call A3A_fnc_customHint;
_hintData remoteExec ["A3A_fnc_customHint",-clientOwner];

systemChat str parseText (_hintData#1); // To remove XML formatting
(str parseText (_hintData#1)) remoteExec ["systemChat",-clientOwner];
