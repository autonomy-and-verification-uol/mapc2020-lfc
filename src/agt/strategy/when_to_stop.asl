//+!stop::choose_the_biggest_cluster([], cluster(_, [])).
//+!stop::choose_the_biggest_cluster([cluster(Id1, GoalList1)|Clusters], Cluster) :
//	true
//<-
//	!stop::choose_the_biggest_cluster(Clusters, cluster(Id2, GoalList2));
//	.length(GoalList1, Size1);
//	.length(GoalList2, Size2);
//	if(Size1 >= Size2){
//		Cluster = cluster(Id1, GoalList1);
//	} else{
//		Cluster = cluster(Id2, GoalList2);
//	}
//	.

+!get_clusters(Goals)
<-
	for ( .member(goal(GX,GY), Goals) ) {
		for ( .member(goal(GX2,GY2), Goals) ) {
			if (GX \== GX2 & GY \== GY2) {
				!check_existing_clusters(goal(GX,GY));
				?stop::flag(Flag);
				-flag(_);
				if ( not Flag ) {
					// Distance = math.abs((GX + GY) - (GX2 + GY2));
					if (bully::real_distance(GX, GY, GX2, GY2, Distance) & Distance <= 4) {
						!check_existing_clusters2(goal(GX2,GY2));
						?stop::aux(Cluster);
						-aux(_);
						if (.empty(Cluster)) {
							+cluster([goal(GX,GY),goal(GX2,GY2)]);
						}
						else {
							-cluster(Cluster);
							+cluster([goal(GX,GY)|Cluster]);
						}
					}
				}
			}
		}
	} 
	.
	
+!check_existing_clusters(goal(GX,GY))
<-
	+flag(false);
	for ( stop::cluster(Cluster) ) {
		if ( stop::flag(false) & .member(goal(GX,GY), Cluster) ) {
			-flag(false);
			+flag(true);
		}
	}
	.
	
+!check_existing_clusters2(goal(GX2,GY2))
<-
	+aux([]);
	for ( stop::cluster(Cluster) ) {
		if ( stop::aux(L) & .empty(L) & .member(goal(GX2,GY2), Cluster) ) {
			-aux([]);
			+aux(Cluster);
		} elif ( .nth(0, Cluster, goal(FX,FY)) & math.abs((GX2 + GY2) - (FX + FY)) <= 4 ) {
			-aux([]);
			+aux(Cluster);
		}
	}
	.

+!closest_goal(GoalX, GoalY, MyX, MyY, ResAux, [], GX, GY) <- GoalX = GX; GoalY = GY.
+!closest_goal(GoalX, GoalY, MyX, MyY, ResAux, [goal(GX,GY)|Goals], GX1, GY1) : Res = math.abs(MyX - GX) + math.abs(MyY - GY) &  Res < ResAux <- !closest_goal(GoalX, GoalY, MyX, MyY, Res, Goals, GX, GY).
+!closest_goal(GoalX, GoalY, MyX, MyY, ResAux, [goal(GX,GY)|Goals], GX1, GY1)  <- !closest_goal(GoalX, GoalY, MyX, MyY, ResAux, Goals, GX1, GY1).

+!closest_taskboard(TaskbX, TaskbY, MyX, MyY, ResAux, [], TBX, TBY) <- TaskbX = TBX; TaskbY = TBY.
+!closest_taskboard(TaskbX, TaskbY, MyX, MyY, ResAux, [taskboard(TBX,TBY)|Taskboards], TBX1, TBY1) : Res = math.abs(MyX - TBX) + math.abs(MyY - TBY) &  Res < ResAux <- !closest_taskboard(TaskbX, TaskbY, MyX, MyY, Res, Taskboards, TBX, TBY).
+!closest_taskboard(TaskbX, TaskbY, MyX, MyY, ResAux, [taskboard(TBX,TBY)|Taskboards], TBX1, TBY1)  <- !closest_taskboard(TaskbX, TaskbY, MyX, MyY, ResAux, Taskboards, TBX1, TBY1).

@stop1[atomic]
+stop
	: .my_name(Me) & default::play(Me,explorer,Group) & not stop::first_to_stop(_) // first to stop
//	& .all_names(AllAgents) & .nth(Pos,AllAgents,Me) & map::myMap(Leader) //& not action::move_sent
<-
//	getGoalClustersWithScouts(Leader, Clusters);
	//!stop::choose_the_biggest_cluster(Clusters, cluster(ClusterId, GoalList));
	//.length(GoalList, N);
	//if(N > 5){
//	if(.member(cluster(_, GoalList), Clusters) & .member(Side, [n,e,w,s]) &
//		.member(origin(Side,Scouts,Retrievers, MaxPosS, MaxPosW, MaxPosE, GoalX, GoalY), GoalList)// & not .member(origin(boh, _, _), GoalList)
//	){
		firstToStop(Me,Flag);
		if (Flag) {
			+stop::first_to_stop(Me);
			//.print("Removing explorer");
			//-exploration::explorer;
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			//.member(origin(_, GoalX, GoalY), GoalList);
//			setTargetGoal(Pos, Me, GoalX, GoalY, Side);
//			initRetrieverAvailablePos(Leader);
			!map::get_goals(Goals);
			!map::get_taskboards(Taskboards);
//			getMyPos(MyX,MyY);
//			!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
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
			?bottom(BottomGoalList);
			-bottom(BottomGoalList);
			
			for ( .member(goal(GX,GY), BottomGoalList) ) {
				!closest_taskboard(TaskbX, TaskbY, GX, GY, 99999, Taskboards, 0, 0);
//				.print("@@@@@@@@@@@@@@ Closest taskboard  X ",TaskbX," Y ",TaskbY);
				+target(GX,GY,TaskbX,TaskbY);
			}
			for ( stop::target(GX,GY,TaskbX,TaskbY) ) {
				LowestD = math.abs(GX - TaskbX) + math.abs(GY - TaskbY);
				if (not stop::lowest_distance(_,_,_,_,_)) {
					+lowest_distance(LowestD,GX,GY,TaskbX,TaskbY);						
				} else {
					?lowest_distance(Lowest,LGX,LGY,LTaskbX,LTaskbY);
					if (Lowest < LowestD) {
						-lowest_distance(Lowest,LGX,LGY,LTaskbX,LTaskbY);
						+lowest_distance(LowestD,GX,GY,TaskbX,TaskbY);
					}
				}
			}
			.abolish(stop::target(_,_,_,_));
			?lowest_distance(_,GX,GY,TaskbX,TaskbY);
			-lowest_distance(_,GX,GY,TaskbX,TaskbY);
			.print("@@@@@@@@@@@@@@ Target Taskboard  X ",TaskbX," Y ",TaskbY);
			.print("@@@@@@@@@@@@@@ Target Goal  X ",GX," Y ",GY);
//			!get_clusters(Goals, [], Clusters);
//			!closest_goal(GoalX, GoalY, TaskbX, TaskbY, 99999, Goals, 0, 0);
//			.print("@@@@@@@@@@@@@@ Closest goal to the taskboard X ",GoalX," Y ",GoalY);
//			!map::printall;
			setTargets(Me, TaskbX, TaskbY, GX, GY);
			.broadcast(tell, stop::first_to_stop(Me));
			!action::forget_old_action;
			!!stop::become_origin(GX, GY);
		}
		else{
			-stop::stop;
		}
//	}
//	else {
//		-stop;
//	}
	.
	
@stop2[atomic]
+stop
	: not stop::really_stop & .my_name(Me) & default::play(Me,explorer,Group) & stop::first_to_stop(Ag) & identification::identified(IdList) & .member(Ag, IdList) //& not action::move_sent // someone else stopped already and my map is his map
<-
//	.print("ADD really stop belief");
	+stop::really_stop;
	joinRetrievers(Flag);
	if (Flag == "deliverer") {
//		.print("Removing explorer");
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_deliverer;
	}
	elif (Flag == "retriever") {
//		.print("Removing explorer");
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_retriever;
	}
	elif (Flag == "bully") {
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_bully;
	}
	else {
//		.print("Removing explorer");
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_useless;
	}
//	!!retrieve::retrieve_block;
	.
	
+stop : true <- -stop::stop.

+!stop::become_bully :
	true
<-
	!common::change_role(bully);
	!bully::messing_around;
	.


+!stop::become_retriever :
	true
<-
	!common::change_role(retriever);
	!retrieve::retrieve_block;
	.
	
+!stop::become_useless :
	true
<-
	!common::change_role(useless);
	if (default::goal(GX,GY) | default::thing(0, 0, dispenser, Type) | default::thing(1, 0, dispenser, Type) | default::thing(-1, 0, dispenser, Type) | default::thing(0, 1, dispenser, Type) | default::thing(0, -1, dispenser, Type)) {
		getMyPos(MyX, MyY);
		!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
		getUselessAvailablePos(UpdatedX, UpdatedY, TargetXGlobal, TargetYGlobal);
		DistanceX = TargetXGlobal - UpdatedX;
		DistanceY = TargetYGlobal - UpdatedY;
		!map::normalise_distance(x, DistanceX,NormalisedDistanceX);
		!map::normalise_distance(y, DistanceY,NormalisedDistanceY);
		!map::best_route(DistanceX,NormalisedDistanceX,NewTargetX);
		!map::best_route(DistanceY,NormalisedDistanceY,NewTargetY);
		!!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	}
	else {
		!!default::always_skip;
	}
	.
	
+!stop::become_deliverer :
	true
<-
	!common::change_role(deliverer);
	getTargetTaskboard(TaskbX,TaskbY);
//	.print("Closest taskboard X = ",TaskbX," Y = ",TaskbY);
	getMyPos(MyX, MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	DistanceX = TaskbX - UpdatedX;
	DistanceY = TaskbY - UpdatedY;
	!map::normalise_distance(x, DistanceX,NormalisedDistanceX);
	!map::normalise_distance(y, DistanceY,NormalisedDistanceY);
	!map::best_route(DistanceX,NormalisedDistanceX,NewTargetX);
	!map::best_route(DistanceY,NormalisedDistanceY,NewTargetY);
	if(NewTargetX < 0){
//		.print("Relative target: ", NewTargetX + 1, " ", NewTargetY);
		!!planner::generate_goal(NewTargetX + 1, NewTargetY, notblock);
	} else {
//		.print("Relative target: ", NewTargetX - 1, " ", NewTargetY);
		!!planner::generate_goal(NewTargetX - 1, NewTargetY, notblock);
	}
	.
	
+!stop::become_origin(GoalX, GoalY) :
	true
<-
	!common::change_role(origin);
	getMyPos(MyX, MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	DistanceX = GoalX - UpdatedX;
	DistanceY = GoalY - UpdatedY;
	!map::normalise_distance(x, DistanceX,NormalisedDistanceX);
	!map::normalise_distance(y, DistanceY,NormalisedDistanceY);
	!map::best_route(DistanceX,NormalisedDistanceX,NewTargetX);
	!map::best_route(DistanceY,NormalisedDistanceY,NewTargetY);
//	.print("@@@@ My target is X = ",NewTargetX," Y = ",NewTargetY);
	!!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	.

//@check_join_group[atomic]
+!stop::check_join_group
	: .my_name(Me) & default::play(Me,explorer,Group) &
	stop::first_to_stop(Ag) & // send a message to the one that stopped asking who the leader is, and you check if you have the same
	map::myMap(Leader) & not stop::really_stop
<-
	.send(Ag, askOne, map::myMap(Leader1), map::myMap(Leader1));
//	.print("Leader: ", Leader, " Leader1: ", Leader1);
	if(Leader == Leader1){
		joinRetrievers(Flag);
			if (Flag == "deliverer") {
//				.print("Removing explorer");
				-exploration::special(_);
				-common::avoid(_);
				-common::escape;
				!action::forget_old_action;
				!!stop::become_deliverer;
			}
		elif (Flag == "retriever") {
//			.print("Removing explorer");
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			!action::forget_old_action;
			!!stop::become_retriever;
		}
		else {
//			.print("Removing explorer");
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			!action::forget_old_action;
			!!stop::become_useless;
		}
	}
	.
+!stop::check_join_group : true. // <- .print("I cannot join the stop group yet").

// trigger for new task addition 
@trigger1[atomic]
+default::task(ID, Deadline, Reward, Blocks) 
	: not(stop::stop)
 <- 
 	!map::get_dispensers(Dispensers);
 	!map::get_taskboards(Taskboards);
 	!map::get_goals(Goals);
	!stop::update_blocks_count(Blocks);
	!stop::conditional_stop(Blocks, Dispensers, Taskboards, Goals, Stop);
	!stop::update_stop(Stop);
	.
	
+!stop::update_stop(true) : true <- +stop::stop.
+!stop::update_stop(false).

+!stop::update_blocks_count([]) : true <- true.
+!stop::update_blocks_count([req(_, _, Type)|Blocks]) : 
	retrieve::block_count(Type, Count) 
<-
	-retrieve::block_count(Type, _);
	Count1 = Count + 1;
	+retrieve::block_count(Type, Count1);
	!stop::update_blocks_count(Blocks).
+!stop::update_blocks_count([req(_, _, Type)|Blocks]) : true <-
	+retrieve::block_count(Type, 1);
	!stop::update_blocks_count(Blocks).
	
+!stop::conditional_stop(Blocks, Dispensers, Taskboards, Goals, true) : 
	map::size(x, _) & map::size(y, _) &
	.length(Goals, NGoals) & NGoals >= 1 &
//	.length(Blocks, NBlocks) & 
	.length(Taskboards, NTaskboards) & NTaskboards >= 1 &
	identification::identified(KnownAgs) & .length(KnownAgs, NKnownAgs) & (NKnownAgs + 1) >= 3 &//NBlocks & // enough agents to build the structure
	.findall(Type, (.member(req(_, _, Type), Blocks) & not(.member(dispenser(Type, _, _), Dispensers))), []) // all the necessary types are known
.
//<- 
//	.print("I can stop exploring now.");
//	.
+!stop::conditional_stop(Blocks, Dispensers, Taskboards, Goals, false). // : true <-  .print("I cannot stop exploring yet.").

@trigger2[atomic]
+!stop::new_dispenser_or_taskboard_or_merge[source(_)] 
	: not(stop::stop) & .findall(task(ID, Deadline, Reward, Blocks), default::task(ID, Deadline, Reward, Blocks), PreShuffleTasks) & not .empty(PreShuffleTasks)
<-
//	callStop(Flag);
// 	!try_call_stop(Flag);
	.shuffle(PreShuffleTasks,Tasks);
	!map::get_dispensers(Dispensers);
	!map::get_taskboards(Taskboards);
	!map::get_goals(Goals);
	!stop::check_active_tasks(Tasks, Dispensers, Taskboards, Goals, 5);
//	stopDone;
	.
+!stop::new_dispenser_or_taskboard_or_merge[source(_)].



+!stop::check_active_tasks([], Dispensers, Taskboards, Goals, Counter) : not(stop::stop).
+!stop::check_active_tasks([], Dispensers, Taskboards, Goals, Counter) : stop::stop.
+!stop::check_active_tasks(Tasks, Dispensers, Taskboards, Goals, 0) : not(stop::stop).
+!stop::check_active_tasks(Tasks, Dispensers, Taskboards, Goals, 0) : stop::stop.
+!stop::check_active_tasks([task(ID, Deadline, Reward, Blocks)|Tasks], Dispensers, Taskboards, Goals, Counter) 
	: not(stop::stop) 
<-
	!stop::conditional_stop(Blocks, Dispensers, Taskboards, Goals, Stop);
	!stop::update_stop(Stop);
	if (not Stop) {
		!stop::check_active_tasks(Tasks, Dispensers, Taskboards, Goals, Counter-1);
	}
	.
+!stop::check_active_tasks([task(ID, Deadline, Reward, Blocks)|Tasks], Dispensers, Taskboards, Goals, Counter) : stop::stop.

