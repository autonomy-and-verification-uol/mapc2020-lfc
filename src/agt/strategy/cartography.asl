+!try_cartographer(Ag2)
	: (not cartographerY(_,_) | not cartographerX(_,_))  & .my_name(Ag1) & not cartographerY(Ag2,_) & not cartographerY(_,Ag2) & not cartographerY(Ag1,_) & not cartographerY(_,Ag1) & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2) & Pos < PosOther
<-
	addCartographer(Ag1,Ag2,Flag);
	if (Flag == 1) {
		+cartographerY(Ag1,Ag2);
		.broadcast(tell, carto::cartographerY(Ag1,Ag2));
	}
	elif (Flag == 2) {
		+cartographerX(Ag1,Ag2);
		.broadcast(tell, carto::cartographerX(Ag1,Ag2));
	}
	.
+!try_cartographer(Ag2).


@cartoY1[atomic]
+cartographerY(Ag1,Ag2)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Ag1 == Me & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2)
<-
	!common::change_role(cartographer);
	if (Pos < PosOther) {
		!!default::always_move_north;
	}
	else {
		!!default::always_move_south;
	}
	.
@cartoY2[atomic]
+cartographerY(Ag1,Ag2)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Ag2 == Me & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag2) & .nth(PosOther,AllAgents,Ag1)
<-
	!common::change_role(cartographer);
	if (Pos < PosOther) {
		!!default::always_move_north;
	}
	else {
		!!default::always_move_south;
	}
	.

@cartoX1[atomic]	
+cartographerX(Ag1,Ag2)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Ag1 == Me & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2)
<-
	!common::change_role(cartographer);
	if (Pos < PosOther) {
		!!default::always_move_west;
	}
	else {
		!!default::always_move_east;
	}
	.
	
@cartoX2[atomic]	
+cartographerX(Ag1,Ag2)
	: .my_name(Me) & not default::play(Me,cartographer,Group) & Ag2 == Me & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag2) & .nth(PosOther,AllAgents,Ag1)
<-
	!common::change_role(cartographer);
	if (Pos < PosOther) {
		!!default::always_move_west;
	}
	else {
		!!default::always_move_east;
	}
	.
	
