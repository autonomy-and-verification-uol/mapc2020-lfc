last_direction(n).

+!arsehole::messing_around :
	true
<-
	.print("Start messing around");
	!map::get_goals(Goals);
	.print("Goals: ", Goals);
	getTargetGoal(_, GoalX, GoalY);
	.print("Target goal: ", GoalX, ", ", GoalY);
	.findall(goal(Distance, GX,GY), 
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
			DistanceX + DistanceY > 10 &
			Distance = DistanceX + DistanceY
		), 
	GoalsToMessWithAux);
	.sort(GoalsToMessWithAux, GoalsToMessWith);
	.print("GoalsToMessWith: ", GoalsToMessWith);
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
		!arsehole::messing_around;
	} else {
		!arsehole::messing_around(GoalsToMessWith);
	}
	.

+!arsehole::messing_around([]) :
	true
<-
	!arsehole::messing_around;
	.
+!arsehole::messing_around([goal(_, GX, GY)|GoalsToMessWith]) :
	true
<-
	.print("Moving to position: ", GX, ", ", GY);
	// !common::move_to_pos(GX, GY);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	DistanceX = GX - UpdatedX;
	DistanceY = GY - UpdatedY;
	!map::normalise_distance(x, DistanceX,NormalisedDistanceX);
	!map::normalise_distance(y, DistanceY,NormalisedDistanceY);
	!map::best_route(DistanceX,NormalisedDistanceX,NewTargetX);
	!map::best_route(DistanceY,NormalisedDistanceY,NewTargetY);
	!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	.print("In place..");
	if(default::thing(X, Y, block, _) & 
		(math.abs(X)+math.abs(Y)>1) & 
		(math.abs(X)+math.abs(Y)<5) & 
		default::team(Team) & not (default::thing(X1, Y1, entity, Team) & (X1 \== 0 | Y1 \== 0))
	) {
		.print("There is a block here, clear it!");
		!action::clear(X, Y);
		if(default::thing(X, Y, block, _)){
			!action::clear(X, Y);
			if(default::thing(X, Y, block, _)){
				!action::clear(X, Y);
			}
		}
	}
	.print("Nothing else to do here, move to next goal");
	!arsehole::messing_around(GoalsToMessWith);
	.


/*
+!arsehole::messing_around :
	stop::first_to_stop(Ag) & identification::identified(Ags) & .member(Ag, Ags)
<-
	.print("@@@@@@@@@@@@ Messing-around, inside the stop group");
	// !common::update_role_to(arsehole);
	!map::get_clusters(Clusters);
	.print("Clusters: ", Clusters);
	getTargetGoal(_, GoalX, GoalY);
	.print("Target goal: ", GoalX, ", ", GoalY);
	.findall(cluster(Name, GoalList),
		(
			.member(cluster(Name, GoalList), Clusters) & 
			not .member(origin(_, GoalX, GoalY), GoalList) &
			not (.member(goal(X, Y), GoalList) & math.abs(X-GoalX)+math.abs(Y-GoalY) <= 10)
		), ClustersToMessWith
	);
	if(ClustersToMessWith == []){
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_useless;
	} else{
		.shuffle(ClustersToMessWith, ClustersToMessWithShuffled);
		.nth(0, ClustersToMessWithShuffled, ClusterToMessWith);
		!!arsehole::mess_with_cluster(ClusterToMessWith, 1);
	}
	.

+!arsehole::messing_around :
	true
<-
	.print("@@@@@@@@@@@@ Messing-around, outside the stop group: ", Ag, ", ", Ags);
	//!common::update_role_to(arsehole);
	!map::get_clusters(Clusters);
	.findall(cluster(Name, GoalList),.member(cluster(Name, GoalList), Clusters), ClustersToMessWith);
	if(ClustersToMessWith == []){
		!!stop::explore_as_explorer;
	} else{
		.shuffle(ClustersToMessWith, ClustersToMessWithShuffled);
		.nth(0, ClustersToMessWithShuffled, ClusterToMessWith);
		!!arsehole::mess_with_cluster(ClusterToMessWith, 0);
	}
	.

+!arsehole::mess_with_cluster(cluster(Name, GoalList), Safe) :
	.member(origin(_, X, Y), GoalList) | .member(goal(X, Y), GoalList)
<-
	.print("Messing with cluster: ", cluster(Name, GoalList));
	!common::move_to_pos(X, Y);
	!arsehole::inspect_cluster(5, Safe);
	!!arsehole::messing_around;
	.
-!arsehole::mess_with_cluster(_, _) : true <- .print("@@@@@@@@@@@@@@@@@@@@@@@@@@@' mess_with_cluster failed'"); !!arsehole::messing_around.

+!arsehole::inspect_cluster(0, _).

+!arsehole::inspect_cluster(TimeWindow, Safe) :
	default::thing(X, Y, block, _) & 
	(math.abs(X)+math.abs(Y)>1) & (math.abs(X)+math.abs(Y)<5) & 
	default::team(Team) & not (default::thing(X1, Y1, entity, Team) & (X1 \== 0 | Y1 \== 0))
<-
	if(Safe == 0){
		.print("@@@@@@@@@@@@@@@@@@@@ inspect cluster 0");
		if(not (stop::first_to_stop(Ag) & idenfication::identified(Ags) & .member(Ag, Ags))){
			!action::clear(X, Y);
			if(default::thing(X, Y, block, _)){
				!action::clear(X, Y);
				if(default::thing(X, Y, block, _)){
					!action::clear(X, Y);
				}
			}
			!arsehole::inspect_cluster(TimeWindow+5);
		}
	} else{
		.print("@@@@@@@@@@@@@@@@@@@@ inspect cluster 1");
		getTargetGoal(_, GoalX, GoalY);
		getMyPos(MyX, MyY);
		RelativeGoalX = GoalX - MyX;
		RelativeGoalY = GoalY - MyY;
		if(math.abs(RelativeGoalX-X)+math.abs(RelativeGoalY-Y) >= 5){
			!action::clear(X, Y);
			if(default::thing(X, Y, block, _)){
				!action::clear(X, Y);
				if(default::thing(X, Y, block, _)){
					!action::clear(X, Y);
				}
			}
			!arsehole::inspect_cluster(TimeWindow+5);
		}
	}
	
	.
+!arsehole::inspect_cluster(TimeWindow, Safe) :
	.findall(goal(X, Y), default::goal(X, Y), Goals) & Goals \== [] & .shuffle(Goals, GoalsShuffled) & .nth(0, GoalsShuffled, goal(GX, GY)) &
	stock::pich_direction(0, 0, GX, GY, Dir)
<-
	!retrieve::smart_move(Dir);
	!arsehole::inspect_cluster(TimeWindow-1, Safe);
	.
+!arsehole::inspect_cluster(TimeWindow, Safe) :
	 .random(R) & .nth(math.floor(R*3.99), [n,s,w,e], Dir)
<-
	!retrieve::smart_move(Dir);
	!arsehole::inspect_cluster(TimeWindow-1, Safe);
	.
*/