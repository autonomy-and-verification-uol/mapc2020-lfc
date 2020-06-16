+!try_cartographer(Ag2)
	: (not carto::cartographerY(_,_) | not carto::cartographerX(_,_))  & .my_name(Ag1) & not cartographerY(Ag2,_) & not cartographerY(_,Ag2) & not cartographerY(Ag1,_) & not cartographerY(_,Ag1) & .all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2) & Pos < PosOther
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