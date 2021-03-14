last_direction(n).

clearable_block(X, Y, 1) :-
//	.print("clearable_block_aux(", X, ", ", Y, ", ", 1, ")") &
	math.abs(X) + math.abs(Y) <= 4 &
	default::team(MyTeam) &
	.findall(thing(X1,Y1), (neighbour(X, Y, X1, Y1) & default::thing(X1, Y1, entity, EnemyTeam) & not (MyTeam = EnemyTeam)), EnemiesAroundBlock) &
	not(.empty(EnemiesAroundBlock)) &
	.findall(thing(X1,Y1), (neighbour(X, Y, X1, Y1) & default::thing(X1, Y1, entity, Team)), []). // no friend agents around the block
clearable_block(X, Y, MinimumNumberOfBlocks) :-
	MinimumNumberOfBlocks > 1 &
//	.print("clearable_block_aux(", X, ", ", Y, ", ", MinimumNumberOfBlocks, ")") &
	neighbour(X, Y, X1, Y1) &
//	.print("check if there is a block in position (", X1, ", ", Y1, ")") &
	default::thing(X1, Y1, block, _) &
//	.print("a block is actually there") &
	clearable_block(X1, Y1, MinimumNumberOfBlocks-1).

neighbour(X, Y, X-1, Y).
neighbour(X, Y, X+1, Y).
neighbour(X, Y, X, Y-1).
neighbour(X, Y, X, Y+1).

real_distance(X, Y, X1, Y1, Distance) :-
	map::size(x, SizeX) &
	DistanceXa = math.abs(X1-X) &
	((X1 > X & DistanceXb = (X - X1 + SizeX)) | 
	 (X1 < X & DistanceXb = (X1 - X + SizeX)) |
	 (X1 == X & DistanceXb = 0)
	) &
	((DistanceXa > DistanceXb & DistanceX = DistanceXb) |
	 (DistanceXa < DistanceXb & DistanceX = DistanceXa) |
	 (DistanceXa == DistanceXb & DistanceX = DistanceXa)
	) &
	map::size(y, SizeY) &
	DistanceYa = math.abs(Y1-Y) &
	((Y1 > Y & DistanceYb = (Y - GY + SizeY)) | 
	 (Y1 < Y & DistanceYb = (GY - Y + SizeY)) |
	 (Y1 == Y & DistanceYb = 0)
	) &
	((DistanceYa > DistanceYb & DistanceY = DistanceYb) |
	 (DistanceYa < DistanceYb & DistanceY = DistanceYa) |
	 (DistanceYa == DistanceYb & DistanceY = DistanceYa)
	) &
	Distance = DistanceX + DistanceY.
	
min_cluster_x(Cluster, MinX) :-
	.length(Cluster, N) & N > 0 &
	min_cluster_x(Cluster, 1000000, MinX).
min_cluster_x([], X, X).
min_cluster_x([goal(Gx, Gy)|Cluster], CurrX, MinX) :-
	Gx <= CurrX &
	min_cluster_x(Cluster, Gx, MinX).
min_cluster_x([goal(Gx, Gy)|Cluster], CurrX, MinX) :-
	Gx > CurrX &
	min_cluster_x(Cluster, CurrX, MinX).
min_cluster_y(Cluster, MinY) :-
	.length(Cluster, N) & N > 0 &
	min_cluster_y(Cluster, 1000000, MinY).
min_cluster_y([], Y, Y).
min_cluster_y([goal(Gx, Gy)|Cluster], CurrY, MinY) :-
	Gy <= CurrY &
	min_cluster_y(Cluster, Gy, MinY).
min_cluster_y([goal(Gx, Gy)|Cluster], CurrY, MinY) :-
	Gy > CurrY &
	min_cluster_y(Cluster, CurrY, MinY).
max_cluster_x(Cluster, MaxX) :-
	.length(Cluster, N) & N > 0 &
	max_cluster_x(Cluster, -1000000, MaxX).
max_cluster_x([], X, X).
max_cluster_x([goal(Gx, Gy)|Cluster], CurrX, MaxX) :-
	Gx >= CurrX &
	max_cluster_x(Cluster, Gx, MaxX).
max_cluster_x([goal(Gx, Gy)|Cluster], CurrX, MaxX) :-
	Gx < CurrX &
	max_cluster_x(Cluster, CurrX, MaxX).
max_cluster_y(Cluster, MaxY) :-
	.length(Cluster, N) & N > 0 &
	max_cluster_y(Cluster, -1000000, MaxY).
max_cluster_y([], Y, Y).
max_cluster_y([goal(Gx, Gy)|Cluster], CurrY, MaxY) :-
	Gy >= CurrY &
	max_cluster_y(Cluster, Gy, MaxY).
max_cluster_y([goal(Gx, Gy)|Cluster], CurrY, MaxY) :-
	Gy < CurrY &
	max_cluster_y(Cluster, CurrY, MaxY).
cluster_center(Cluster, X, Y, Radius) :- 
	min_cluster_x(Cluster, MinX) & 
	min_cluster_y(Cluster, MinY) &
	max_cluster_x(Cluster, MaxX) &
	max_cluster_y(Cluster, MaxY) & 
	X = math.floor(((MaxX - MinX) / 2) + MinX) & 
	Y = math.floor(((MaxY - MinY) / 2) + MinY) & 
	Radius = math.floor(((MaxX - MinX) + (MaxY - MinY)) / 4) + 1.
patrolling_positions(cluster(X, Y, Radius), Positions) :-
	map::size(x, SizeX) &
	map::size(y, SizeY) &
	.findall(pos(X1, Y1),(
		.range(Ix, -Radius, Radius) &
		.range(Iy, -Radius, 0) &
		X1 = X + Ix &
		Y1 = Y + Iy &
		((X1 < 0 & X2 = SizeX - X1) | (X1 >= 0 & X2 = X1)) &
		((Y1 < 0 & Y2 = SizeY - Y1) | (Y1 >= 0 & Y2 = Y1)) &
		bully::real_distance(X, Y, X2, Y2, Distance) &
		Distance = Radius
	), Positions1a) &
	.findall(pos(X1, Y1),(
		.range(Ix, -Radius, Radius) &
		.range(Iy, 0, Radius) &
		X1 = X - Ix &
		Y1 = Y + Iy &
		((X1 < 0 & X2 = SizeX - X1) | (X1 >= 0 & X2 = X1)) &
		((Y1 < 0 & Y2 = SizeY - Y1) | (Y1 >= 0 & Y2 = Y1)) &
		bully::real_distance(X, Y, X2, Y2, Distance) &
		Distance = Radius
	), Positions1b) &
	.concat(Positions1a, Positions1b, Positions).
patrolling_positions(cluster(X, Y, Radius), Positions) :-
	.findall(pos(X1, Y1),(
		.range(Ix, -Radius, Radius) &
		.range(Iy, -Radius, 0) &
		X1 = X + Ix &
		Y1 = Y + Iy &
		Distance = (math.abs(X1 - X) + math.abs(Y1 - Y)) &
		Distance = Radius
	), Positions1a) &
	.findall(pos(X1, Y1),(
		.range(Ix, -Radius, Radius) &
		.range(Iy, 0, Radius) &
		X1 = X - Ix &
		Y1 = Y + Iy &
		Distance = (math.abs(X1 - X) + math.abs(Y1 - Y)) &
		Distance = Radius
	), Positions1b) &
	.concat(Positions1a, Positions1b, Positions).

patience(20).

@new_team[atomic]
+!bully::new_team : default::play(Me, bully, Group) <- !!reconsider_clusters.

+!bully::messing_around(GX, GY):
	bully::patrolling_positions(cluster(GX, GY, 3), Positions)
<-
//	.print("Start messing around");
	!update_patience(10000000);
	-positions(_);
	+positions(Positions);
	-beginning;
	+beginning;
	-stop_being_a_bully;
	!bully::messing_around(Positions);
	.
+!bully::messing_around(GX, GY).	


+!reconsider_clusters :
	true
<-
	-there_is_a_new_team;
	+there_is_a_new_team;
	.

+!messing_around :
	patience(Patience) & .my_name(Me) & default::play(Me, bully, Group)
<-
//	.print("Start messing around");
	getMyPos(MyX, MyY);
	!map::get_goals(Goals);
	!stop::get_clusters(Goals);
//	.print("Goals: ", Goals);
	?team::teamLeader(TeamLeader);
//	getTargetGoal(TeamLeader, GoalX, GoalY);
	getTargetGoals(TargetGoals);
//	.print("Target goal: ", GoalX, ", ", GoalY);
	.findall(cluster(X, Y, Radius, Positions), (
		stop::cluster(Cluster) & .length(Cluster, N) & N > 0 &
		.findall(goal(GAuxX, GAuxY), (.member(goal(GAuxX, GAuxY), TargetGoals) & .member(goal(GAuxX, GAuxY), Cluster)), []) &
//		not(.member(goal(GoalX, GoalY), Cluster)) &
		bully::cluster_center(Cluster, X, Y, Radius) &
		bully::patrolling_positions(cluster(X, Y, Radius), Positions)
	), ClustersToMessWith);
//	.print("Clusters to mess with: ", ClustersToMessWith);
	.length(ClustersToMessWith, N);
	if(N = 0) {
//		.print("skip");
		!action::skip; 
		!bully::messing_around
	} else{
		.shuffle(ClustersToMessWith, Clusters1);
		.nth(0, Clusters1, cluster(_, _, _, Positions));
		!update_patience(Patience);
		-positions(_);
		+positions(Positions);
		-stop_being_a_bully;
		!bully::messing_around(Positions);
	}
	.
+!messing_around.

+!messing_around_old :
	.my_name(Me) & default::play(Me, bully, Group)
<-
//	.print("Start messing around");
	getMyPos(MyX, MyY);
	!map::get_goals(Goals);
	!stop::get_clusters(Goals);
//	.print("Goals: ", Goals);
	?team::teamLeader(TeamLeader);
	getTargetGoal(TeamLeader, GoalX, GoalY);
//	.print("Target goal: ", GoalX, ", ", GoalY);
	.findall(goal(Distance, GX,GY),
		(
			stop::cluster(Cluster) & .length(Cluster, N) & N > 0 &
			not(.member(goal(GoalX, GoalY), Cluster)) &
			.member(goal(GX, GY), Cluster) &
			real_distance(MyX, MyY, GX, GY, Distance)
		), 
		GoalsToMessWithAux
	);
	/*.findall(goal(Distance, GX,GY), 
		(
			.member(goal(GX,GY), Goals) & 
			map::size(x, SizeX) &
			DistanceXa = math.abs(GX-GoalX) &
			((GX > GoalX & DistanceXb = (GoalX - GX + SizeX)) | 
			 (GX < GoalX & DistanceXb = (GX - GoalX + SizeX)) |
			 (GX == GoalX & DistanceXb = 0)
			) &
			((DistanceXa > DistanceXb & DistanceX = DistanceXb) |
			 (DistanceXa < DistanceXb & DistanceX = DistanceXa) |
			 (DistanceXa == DistanceXb & DistanceX = DistanceXa)
			) &
			map::size(y, SizeY) &
			DistanceYa = math.abs(GY-GoalY) &
			((GY > GoalY & DistanceYb = (GoalY - GY + SizeY)) | 
			 (GY < GoalY & DistanceYb = (GY - GoalY + SizeY)) |
			 (GY == GoalY & DistanceYb = 0)
			) &
			((DistanceYa > DistanceYb & DistanceY = DistanceYb) |
			 (DistanceYa < DistanceYb & DistanceY = DistanceYa) |
			 (DistanceYa == DistanceYb & DistanceY = DistanceYa)
			) &
			//DistanceX + DistanceY > 10 &
			Distance = DistanceX + DistanceY
		), 
	GoalsToMessWithAux);*/
	.sort(GoalsToMessWithAux, GoalsToMessWith);
//	.print("GoalsToMessWith: ", GoalsToMessWith);
	if(GoalsToMessWith == []) {
		for(.range(I, 1, 15) & last_direction(Dir)){
			.random(R);
			if(R <= 0.8){
				!action::move(Dir);
			} else{
				.random(R1);
				.nth(math.floor(R1*3.99), [n,s,w,e], Dir1);
				-+last_direction(Dir1);
				!action::move(Dir1);
			}
		}
		!messing_around;
	} else {
		!messing_around(GoalsToMessWith);
	}
	.

+!messing_around(_) :
	bully::stop_being_a_bully & stop::really_stop
<-
	joinStopGroup(Flag,TeamLeader);
//	.print("stop being a bully and become a ", Flag);
	+team::teamLeader(TeamLeader);
	    if (Flag == "origin") {
	  //		.print("Removing explorer");
	      !action::forget_old_action;
	      -exploration::special(_);
	      -common::avoid(_);
	      -common::escape;
			!map::get_goals(Goals);
			!map::get_taskboards(Taskboards);
			!get_clusters(Goals);
			+bottom([]);
			for ( stop::cluster(Clusters) ) {
				.nth(0, Clusters, goal(FX,FY));
				+maxY(goal(FX,FY));
				for ( .member(goal(GX,GY), Clusters) ) {
					?maxY(goal(MX,MY));
					if (GY > MY) {
						-maxY(goal(MX,MY));
						+maxY(goal(GX,GY));
					}
				}
				?bottom(List);
				-bottom(List);
				?maxY(goal(MX,MY));
				-maxY(goal(MX,MY));
				+bottom([goal(MX,MY)|List]);
			}
			?bottom(BottomGoalListOld);
			-bottom(BottomGoalListOld);
//			.print("Clusters: ",BottomGoalListOld);
			.abolish(stop::cluster(_));
			getTargetGoals(GoalClusters);
//			.print("Minus: ",GoalClusters);
			+bottom(BottomGoalListOld);
			for (.member(GC,GoalClusters)) {
				if (.member(GC,BottomGoalListOld)) {
					?bottom(List);
					-bottom(List);
					.delete(GC,List,NewList);
					+bottom(NewList);
				}
			}
			?bottom(BottomGoalList);
			-bottom(BottomGoalList);
//			.print("Equals: ",BottomGoalList);
			
			for ( .member(goal(GX,GY), BottomGoalList) ) {
				!closest_taskboard(TaskbX, TaskbY, GX, GY, 99999, Taskboards, 0, 0);
//				.print("@@@@@@@@@@@@@@ Closest taskboard  X ",TaskbX," Y ",TaskbY);
				+target(GX,GY,TaskbX,TaskbY);
			}
			for ( stop::target(GX,GY,TaskbX,TaskbY) ) {
				.print("Target GX",GX," GY ",GY," TaskbX ",TaskbX," TaskbY ",TaskbY);
				LowestD = math.abs(GX - TaskbX) + math.abs(GY - TaskbY);
				if (not stop::lowest_distance(_,_,_,_,_)) {
					+lowest_distance(LowestD,GX,GY,TaskbX,TaskbY);						
//				} 
//				elif (not stop::lowest_distance2(_,_,_,_,_)) {
//					+lowest_distance2(LowestD,GX,GY,TaskbX,TaskbY);	
				} else {
					?lowest_distance(Lowest,LGX,LGY,LTaskbX,LTaskbY);
					if (LowestD < Lowest) {
//						-lowest_distance2(_,_,_,_,_);
//						+lowest_distance2(Lowest,LGX,LGY,LTaskbX,LTaskbY);
						-lowest_distance(Lowest,LGX,LGY,LTaskbX,LTaskbY);
						+lowest_distance(LowestD,GX,GY,TaskbX,TaskbY);
					}
				}
			}
			.abolish(stop::target(_,_,_,_));
			?lowest_distance(_,GX,GY,TaskbX,TaskbY);
			-lowest_distance(_,GX,GY,TaskbX,TaskbY);
			.print("@@@@@@@@@@@@@@ Target Taskboard Cluster  X ",TaskbX," Y ",TaskbY);
			.print("@@@@@@@@@@@@@@ Target Goal Cluster X ",GX," Y ",GY);
		  setTargets(Me, TaskbX, TaskbY, GX, GY);
		  .term2string(Me,MeS);
		  .broadcast(tell, team::wait(MeS));
		  .broadcast(achieve, bully::new_team);
	      !!stop::become_origin(GX, GY);
	    }
	    elif (Flag == "deliverer") {
	  //		.print("Removing explorer");
	      -exploration::special(_);
	      -common::avoid(_);
	      -common::escape;
	      !action::forget_old_action;
	      .wait(team::wait(TeamLeader)[source(_)]);
	      getTargetTaskboard(TeamLeader,TaskbX,TaskbY);
	      !!stop::become_deliverer(TaskbX,TaskbY);
	    }
	    elif (Flag == "retriever") {
	  //		.print("Removing explorer");
	      -exploration::special(_);
	      -common::avoid(_);
	      -common::escape;
	      !action::forget_old_action;
	      .wait(team::wait(TeamLeader)[source(_)]);
	      !!stop::become_retriever;
	    }
		elif (Flag == "bully") {
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			!action::forget_old_action;
			.wait(team::wait(TeamLeader)[source(_)]);
			!!stop::become_bully;
		}
	.
+!messing_around(_) :
	bully::stop_being_a_bully 
<-
//	.print("stop being a bully2");
	-beginning;
	-curr_patience(_);
	-positions(_);
	!action::forget_old_action;
	!common::change_role(explorer);
	!!exploration::explore([n,s,e,w]);
	.
+!messing_around(_) :
	there_is_a_new_team
<-
	-there_is_a_new_team;
	!messing_around;
	.
+!messing_around([]) :
	positions(Positions) & .my_name(Me) & default::play(Me, bully, Group)
<-
	!messing_around(Positions);
	.
+!messing_around([pos(GX, GY)|PositionsToMessWith]) :
	curr_patience(Patience) & Patience <= 0 & .my_name(Me) & default::play(Me, bully, Group)
<-
	!messing_around;
	.
+!messing_around([pos(GX, GY)|PositionsToMessWith]) :
	curr_patience(Patience) & Patience > 0 & patience(InitialPatience) & .my_name(Me) & default::play(Me, bully, Group)
<-
	!update_patience(Patience-1);
//	.print("Moving to position: ", GX, ", ", GY);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	DistanceX = GX - UpdatedX;
	DistanceY = GY - UpdatedY;
	!map::normalise_distance(x, DistanceX,NormalisedDistanceX);
	!map::normalise_distance(y, DistanceY,NormalisedDistanceY);
	!map::best_route(DistanceX,NormalisedDistanceX,NewTargetX);
	!map::best_route(DistanceY,NormalisedDistanceY,NewTargetY);
	!planner::generate_goal(NewTargetX, NewTargetY, notblock);
//	.print("In place..");
	for(default::thing(X, Y, block, _) & 
		clearable_block(X, Y, 1) & patience(Patience)
	) {
//		.print("There is a block here, clear it!");
		!update_patience(InitialPatience);
		!action::clear(X, Y);
		if(default::thing(X, Y, block, _)){
			!action::clear(X, Y);
			if(default::thing(X, Y, block, _) | default::thing(X-1, Y, block, _) | default::thing(X+1, Y, block, _) | default::thing(X, Y-1, block, _) | default::thing(X, Y+1, block, _)){
				!action::clear(X, Y);
			}
		}
	}
//	.print("Nothing else to do here, move to next position");
	!messing_around(PositionsToMessWith);
	.
+!messing_around(_) : true. //<- .print("messing_around ended").	

@updatepatience[atomic]
+!update_patience(NewPatience) :
	true
<-
	-curr_patience(_);
	+curr_patience(NewPatience);
	.