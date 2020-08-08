+!try_cartographer(Ag2,Ag2X,Ag2Y)
	: (not cartographerY(_,_) | not cartographerX(_,_))  & .my_name(Ag1) & not cartographerY(Ag2,_) & not cartographerY(_,Ag2) & not cartographerY(Ag1,_) & not cartographerY(_,Ag1) & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2)
<-
	if (Pos < PosOther) {
		addCartographer(Ag1,Ag2,Flag);
		if (Flag == 1) {
			!calculate_distance(Ag2X,Ag2Y,Distance,Ag1MoveTo,Ag2MoveTo);
			+cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y);
			.broadcast(tell, carto::cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y));
		}
		elif (Flag == 2) {
			!calculate_distance(Ag2X,Ag2Y,Distance,Ag1MoveTo,Ag2MoveTo);
			+cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y);
			.broadcast(tell, carto::cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y));
		}
		.send(Ag2, tell, carto::registration_concluded);
	}
	else {
		.wait(carto::registration_concluded[source(Ag2)]);
		-carto::registration_concluded[source(Ag2)];
	}
	.
+!try_cartographer(Ag2,Ag2X,Ag2Y).

+!calculate_distance(Ag2X,Ag2Y,Distance,Ag1MoveTo,Ag2MoveTo)
<-
	Distance = math.abs(Ag2X) + math.abs(Ag2Y);
	if (Ag2X > 1) {
		Ag1MoveTo = e;
		Ag2MoveTo = w; 
	}
	elif (Ag2X < -1) {
		Ag1MoveTo = w;
		Ag2MoveTo = e; 
	}
	elif (Ag2Y > 1) {
		Ag1MoveTo = s;
		Ag2MoveTo = n; 
	}
	elif (Ag2Y < -1) {
		Ag1MoveTo = n;
		Ag2MoveTo = s; 
	}
	.
	
+!calculate_distance_solo(X,Y,Distance,NewMoveTo)
<-
	Distance = math.abs(X) + math.abs(Y);
	if (X > 1) {
		NewMoveTo = e;
	}
	elif (X < -1) {
		NewMoveTo = w;
	}
	elif (Y > 1) {
		NewMoveTo = s;
	}
	elif (Y < -1) {
		NewMoveTo = n;
	}
	.

@cartoY[atomic]
+cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Me == Ag1 | Me == Ag2
<-
	!common::change_role(cartographer);
	if (Distance <= 3) {
		if (Me == Ag1) {
			+agent_to_identify(Ag2);
			!!cartography(Ag2,y,Ag2Y);
		} else {
			+agent_to_identify(Ag1);
			!!cartography(Ag1,y,-Ag2Y);
		}
	} else {
		if (Me == Ag1) {
			+agent_to_identify(Ag2);
			!!move_closer(Ag2,Ag1MoveTo,y);
		} else {
			+agent_to_identify(Ag1);
			!!move_closer(Ag1,Ag2MoveTo,y);
		}
	}
	.	
	
@cartoX[atomic]
+cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Me == Ag1 | Me == Ag2
<-
	!common::change_role(cartographer);
	if (Distance <= 3) {
		if (Me == Ag1) {
			+agent_to_identify(Ag2);
			!!cartography(Ag2,x,Ag2X);
		} else {
			+agent_to_identify(Ag1);
			!!cartography(Ag1,x,-Ag2X);
		}
	} else {
		if (Me == Ag1) {
			+agent_to_identify(Ag2);
			!!move_closer(Ag2,Ag1MoveTo,x);
		} else {
			+agent_to_identify(Ag1);
			!!move_closer(Ag1,Ag2MoveTo,x);
		}
	}
	.

+!move_closer(Ag,MoveTo,Axis)
	: exploration::check_obstacle_clear(MoveTo)
<-
	!try_to_clear(MoveTo);
	.abolish(carto::new_distance(_,_));
	!move_closer(Ag,MoveTo,Axis);
	.

+!move_closer(Ag,MoveTo,Axis)
	: .my_name(Me)
<-
	!action::move(MoveTo);
	.wait(carto::new_distance(X,Y));
	-carto::new_distance(X,Y);
	!calculate_distance_solo(X,Y,Distance,NewMoveTo);
	if (Distance <= 3) {
		+carto::close_gap;
		if (Axis == x) {
			!!cartography(Ag,x,X);
		} else {
			!!cartography(Ag,y,Y);
		}
	} else {
		!!move_closer(Ag,NewMoveTo,Axis);
	}
	.
	
	
+!cartography(Ag,y,AgY)
	: .my_name(Me) & .all_names(AllAgents) & .nth(Pos,AllAgents,Me) & .nth(PosOther,AllAgents,Ag)
<-
	+cells(1);
	+axis(y);
	+distance_cells(math.abs(AgY)-1);
	if (AgY > 0) {
		+my_direction(n);
	}
	elif (AgY < 0) {
		+my_direction(s);
	}
	else {
		if (Pos < PosOther)	{

			+my_direction(n);
		}
		else {
			+my_direction(s);
		}
	}
	!carto;
	.

+!cartography(Ag,x,AgX)
	: .my_name(Me) & .all_names(AllAgents) & .nth(Pos,AllAgents,Me) & .nth(PosOther,AllAgents,Ag)
<-
	+cells(1);
	+agent_to_identify(Ag);
	+axis(x);
	+distance_cells(math.abs(AgX)-1);
	if (AgX > 0) {
		+my_direction(w);
	}
	elif (AgX < 0) {
		+my_direction(e);
	}
	else {
		if (Pos < PosOther)	{
			+my_direction(w);
		}
		else {
			+my_direction(e);
		}
	}
	!carto;
	.
	
+!carto
	: not cycle_complete(_,_) & my_direction(Dir) & exploration::check_obstacle_clear(Dir)
<-
	!try_to_clear(Dir);
	!carto;
	.
	
+!carto
	: not cycle_complete(_,_) & my_direction(Dir) & cells(C)
<-
	!action::move(Dir);
	?default::lastActionResult(Result);
	if (Result == success) {
		-cells(C);
		+cells(C+1);
	}
	!carto;
	.
	
+!carto
	: cycle_complete(VisionCellsX,VisionCellsY) & agent_to_identify(Ag) & cells(C) & my_direction(Dir) & .my_name(Me) & .all_names(AllAgents) & .nth(Pos,AllAgents,Me) & .nth(PosOther,AllAgents,Ag)
<-
	if (Pos < PosOther)	{
		.wait(carto::other_cells(C2)[source(Ag)]);
		?carto::axis(Axis);
		?carto::distance_cells(ExtraCells);
		?map::myMap(Leader);
		if (Axis == x) {
			.send(Leader, achieve, carto::calculate_map_size(Axis,C+C2+ExtraCells+VisionCellsX));
		}
		else {
			.send(Leader, achieve, carto::calculate_map_size(Axis,C+C2+ExtraCells+VisionCellsY));
		}
	}
	else {
		.send(Ag, tell, carto::other_cells(C)[source(Ag)]);
	}
	.print("@@@@@@ Cartography finished.");
	.abolish(carto::_[source(_)]);
	!common::change_role(explorer);
	!!stop::cartographer_conditional_stop;
	!!exploration::explore([n,s,e,w]);
	.
	
+!try_to_clear(Dir)
<-
	?exploration::get_clear_direction(Dir,X,Y);
	for(.range(I, 1, 3)){
		if (I == 1 & not carto::cycle_complete(_,_)) {
			!action::clear(X,Y);
		}
		elif ((not default::lastAction(clear) | default::lastAction(clear)) & (default::lastActionResult(success)) & not carto::cycle_complete(_,_) & not default::lastActionResult(failed_random)) {
			!action::clear(X,Y);
		}
	}
	if (default::lastActionResult(failed_resources)) {
		!action::skip;
	}
	if (default::lastActionResult(failed_random)) {
		!try_to_clear(Dir);
	}
	.

+!calculate_map_size(Axis, Size) <- .print("################# Axis ",Axis," is of size ",Size).
