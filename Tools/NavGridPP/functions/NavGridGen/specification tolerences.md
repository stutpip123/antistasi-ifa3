John Jordan — 21May04 at 21:59
1. Quick way to convert navpoint -> road, if there is a valid road. May need to precalc this if it's sufficiently problematic.
2. Avoid placing two navpoints on the same road according to the mapping from 1. Adjacent roads is probably ok.
3. If there's no road path between two navpoints (following the fancy version of roadsConnectedTo with track/road/mainroad), then one of the navpoints should have no associated road.
Double wide highways might cause problems if they're wrongly cross-connected with roadsConnectedTo [x, true], but there won't be anything you can do about that. Two nav paths is fine and probably preferable.
There are theoretical issues with islands where the nearest road is on a dead island but >300m from a valid navpoint, but I don't think that's your problem. Marker to navpoint mapping needs a better solution in general.
For the field-crossing case, the ideal would be to add a roadless navpoint in the middle of the field.
Similarly for roadless bridges.
That might be a problem because of the lack of Z though.
FrostB IE8 — 21May04 at 22:27
So with no associated road, I assume the search radius will have to be quite tight, as sometimes the two roads will be almost butting each other.
I will need to double check that raw getPos _road is exact enough when using nearTerrainObjects, but I think it might be fine. I'll get back to you on single point tolerences.
John Jordan — 21May04 at 22:29
Yeah, ideally it's a <1m search. Need to check if that's workable.
FrostB IE8 — 21May04 at 22:31
However, if you go with the prepossessed route, there will be no tolerances and everything will be exact
Since then it is a one way process as roads will be identifed by getPos output

And on all of them it is precise. So nearestTerrainObjects [_pos, ["TRACK","ROAD","MAIN ROAD"], 0, false, true] will always work.
However, all nav grids generated so far have X & Y shifting to try help roadAt. This puts the radius at <4.25m (sqrt (2* 3^2)). So before code that uses nearestTerrainObjects with 0 radius is used, nav grids need to be regenerated.
