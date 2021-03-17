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
    "<t size='1' align='left'><t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Key Binds</t><br/>"+
    "<t color='#f0d498'>'H'</t>-View help.<br/>"+
    "<t color='#f0d498'>'C'</t>-Cycle connection type.<br/>"+
    "<t color='#f0d498'>'F'</t>-Cycle tool<br/>"+
    "<t color='#f0d498'>'ctrl'+'S'</t>-Export changes<br/>"+
    "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Connection Tool</t><br/>"+
    "<t color='#f0d498'>'click'</t>-Select &amp; connect roads<br/>"+
    "<t color='#f0d498'>'shift'</t>-Create new node<br/>"+
    "<t color='#f0d498'>'alt'</t>-Delete node<br/>"+
    "<t size='1.2' color='#f0d498' font='RobotoCondensed' align='center' underline='1'>Brush Tool</t><br/>"+
    "<t color='#f0d498'>'click'</t>-Set connection type<br/>"+
    "<t color='#f0d498'>'shift'</t>-Double brush size<br/>"+
    "<t color='#f0d498'>'alt'</t>-Delete all nodes<br/>"+
    "</t>",
    true
];
_hintData call A3A_fnc_customHint;
_hintData remoteExec ["A3A_fnc_customHint",-clientOwner];

systemChat str parseText (_hintData#1); // To remove XML formatting
(str parseText (_hintData#1)) remoteExec ["systemChat",-clientOwner];
