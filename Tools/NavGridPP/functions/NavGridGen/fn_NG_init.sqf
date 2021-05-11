/*
Maintainer: Caleb Serafin
    Initialises const values.

Scope: Any, Local Effect
Environment: Unscheduled
Public: No

Example:
    class NG_init { preInit = 1; };
*/





// Common for transforming 3DPos to 2D.
A3A_NG_const_pos2DSelect = [0,2];

// Common for empty check
A3A_NG_const_emptyArray = [];

// Common Enum of road types, Case sensitive
A3A_NG_const_roadTypeEnum = ["TRACK","ROAD","MAIN ROAD"];

// For use with nearRoads or NearestTerrainObjects, the inaccuracy is caused by str and parseNumber.
A3A_NG_const_positionInaccuracy = 0.075;

// All pallets should have at least 2 accents
//                    Black      Dark Grey    Light Grey     White
private _greys = ["ColorBlack","Color6_FD_F","ColorGrey","ColorWhite"];
private _greyOnly = ["Color6_FD_F","ColorGrey"];
//                 Dark Red      Grey Red       Red      Pink
private _reds = ["ColorEAST","Color1_FD_F","ColorRed","ColorPink"];  // ColorEAST == colorOPFOR
//                      Brown       Orange     Light Orange
private _oranges = ["ColorBrown","ColorOrange","Color3_FD_F"];
//                    Dark Yellow     Yellow
private _yellows = ["ColorUNKNOWN","ColorYellow"];
//                    Khaki       Light Khaki
private _khakis = ["ColorKhaki","Color2_FD_F"];
//                  Dark Green     Green
private _greens = ["ColorGUER","ColorGreen"];  // ColorGUER == colorIndependent
//                  Dark Blue      Blue     Light Blue
private _blues = ["ColorWEST","ColorBlue","Color4_FD_F"];  // ColorWEST == colorBLUFOR
//                     Purple   Light Purple
private _purples = ["ColorCIV","Color5_FD_F"];  // ColorCIV == colorCivilian

A3A_NGSA_const_allMarkerColours = [];
private _allPallets = [_greyOnly,_oranges,_yellows,_khakis,_greens,_blues,_purples];
// Mixes so that it cycles through pallets before accents
for "_i" from 0 to 3 do {    // longest accent
    for "_j" from 0 to count _allPallets -1 do {
        private _currentPallet = _allPallets#_j;
        if (count _currentPallet > _i) then {
            A3A_NGSA_const_allMarkerColours pushBack (_currentPallet#_i);
        };
    };
};

A3A_NGSA_const_allMarkerColoursCount = count A3A_NGSA_const_allMarkerColours;
A3A_NGSA_const_markerColourAccent1 = _reds#2;
A3A_NGSA_const_markerColourAccent2 = _reds#1;
