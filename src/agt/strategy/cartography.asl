+!try_cartographer(Ag2,Ag2X,Ag2Y)
	: (not cartographerY(_,_) | not cartographerX(_,_))  & .my_name(Ag1) & not cartographerY(Ag2,_) & not cartographerY(_,Ag2) & not cartographerY(Ag1,_) & not cartographerY(_,Ag1) & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2) & Pos < PosOther
<-
	addCartographer(Ag1,Ag2,Flag);
	if (Flag == 1) {
		!calculate_distance(Ag2X,Ag2Y,Distance,Ag1MoveTo,Ag2MoveTo);
		+cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo);
		.broadcast(tell, carto::cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo));
	}
	elif (Flag == 2) {
		!calculate_distance(Ag2X,Ag2Y,Distance,Ag1MoveTo,Ag2MoveTo);
		+cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo);
		.broadcast(tell, carto::cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo));
	}
	.
+!try_cartographer(Ag2,Ag2X,Ag2Y).

+!calculate_distance(Ag2X,Ag2Y,Distance,Ag1MoveTo,Ag2MoveTo)
<-
	Distance = math.abs(Ag2X) + math.abs(Ag2Y);
	if (math.abs(Ag2X) + math.abs(Ag2Y) > 3) {
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
	}
	else {
		Distance = -1;
	}
	.

@cartoY[atomic]
+cartographerY(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo)
	: .my_name(Me) & not default::play(Me,cartographer,Group)
<-
	!common::change_role(cartographer);
	if (Distance == -1) {
		if (Me == Ag1) {
			!!cartography(Ag2,y);
		} else {
			!!cartography(Ag1,y);
		}
	} else {
		!!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,y);
	}
	.
	
@cartoX[atomic]
+cartographerX(Ag1,Ag2,Distance,Ag1MoveTo,Ag2MoveTo)
	: .my_name(Me) & not default::play(Me,cartographer,Group)
<-
	!common::change_role(cartographer);
	if (Distance == -1) {
		if (Me == Ag1) {
			!!cartography(Ag2,x);
		} else {
			!!cartography(Ag1,x);
		}
	} else {
		!!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,x);
	}
	.

+!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,Axis)
	: .my_name(Ag1)
<-
	!action::move(Ag1MoveTo);
	!cartography(Ag2,Axis);
	.
	
+!move_closer(Ag1,Ag2,Ag1MoveTo,Ag2MoveTo,Axis)
	: .my_name(Ag2)
<-
	!action::move(Ag2MoveTo);
	!cartography(Ag1,Axis);
	.
	
+!cartography(Ag,Y)
 : .my_name(Me) & .all_names(AllAgents) & .nth(Pos,AllAgents,Me) & .nth(PosOther,AllAgents,Ag) //& Me < Ag
//<-
//	getMyPos(MyX,MyY);
//	.print(MyX);
//	.print(MyY);
.

+!cartography(Ag)
//<-
//	getMyPos(MyX,MyY);
//	.print(MyX);
//	.print(MyY);
.