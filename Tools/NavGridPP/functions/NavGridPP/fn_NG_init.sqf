
// Common for transforming 3DPos to 2D.
A3A_NG_const_pos2DSelect = [0,2];

// Common for empty check
A3A_NG_const_emptyArray = [];

// Used in convert_road_pos.
A3A_NG_const_posOffsetMatrix = [];
for "_axis_x" from -3 to 3 step 1 do {
    for "_axis_y" from -3 to 3 step 1 do {
        A3A_NG_const_posOffsetMatrix pushBack [_axis_x,_axis_y];
    };
};

// Common Enum of road types, Case sensitive
A3A_NG_const_roadTypeEnum = ["TRACK","ROAD","MAIN ROAD"];

