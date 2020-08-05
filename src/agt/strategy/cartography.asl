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

@cartoY[atomic]
+cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Me == Ag1 | Me == Ag2
<-
	!common::change_role(cartographer);
	if (Distance <= 3) {
		if (Me == Ag1) {
			!!cartography(Ag2,y,Ag2Y);
		} else {
			!!cartography(Ag1,y,-Ag2Y);
		}
	} else {
		!!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,y);
	}
	.	
	
@cartoX[atomic]
+cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo,Ag2X,Ag2Y)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Me == Ag1 | Me == Ag2
<-
	!common::change_role(cartographer);
	if (Distance <= 3) {
		if (Me == Ag1) {
			!!cartography(Ag2,x,Ag2X);
		} else {
			!!cartography(Ag1,x,-Ag2X);
		}
	} else {
		!!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,x);
	}
	.

+!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,Axis)
	: .my_name(Ag1)
<-
	!action::move(Ag1MoveTo);
//	!cartography(Ag2,Axis);
	.
	
+!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,Axis)
	: .my_name(Ag2)
<-
	!action::move(Ag2MoveTo);
//	!cartography(Ag1,Axis);
	.
	
+!cartography(Ag,y,AgY)
	: .my_name(Me) & .all_names(AllAgents) & .nth(Pos,AllAgents,Me) & .nth(PosOther,AllAgents,Ag)
<-
	+cells(0);
	+agent_to_identify(Ag);
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
	+cells(0);
	+agent_to_identify(Ag);
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
	: not cycle_complete & my_direction(Dir) & exploration::check_obstacle_clear(Dir)
<-
	!try_to_clear(Dir);
	!carto;
	.
	
+!carto
	: not cycle_complete & my_direction(Dir) & cells(C)
<-
	!action::move(Dir);
	?default::lastActionResult(Result);
	if (Result == success) {
		-cells(C);
		+cells(C+1);
	}
	!carto;
	.
	
+!try_to_clear(Dir)
<-
	?exploration::get_clear_direction(Dir,X,Y);
	for(.range(I, 1, 3)){
		if ((not default::lastAction(clear) | default::lastAction(clear)) & (default::lastActionResult(success) | default::lastActionResult(failed_random)) & not cycle_complete) {
			!action::clear(X,Y);
		}
	}
	.

@cycle[atomic]
+cycle_complete
	: agent_to_identify(Ag)
<-
	-agent_to_identify(Ag);
	.print("@@@@@@@@@@@@@@ CYCLE OK");
	.
	
	