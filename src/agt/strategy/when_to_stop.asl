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

+!closest_goal(GoalX, GoalY, MyX, MyY, ResAux, [], GX, GY) <- GoalX = GX; GoalY = GY.
+!closest_goal(GoalX, GoalY, MyX, MyY, ResAux, [goal(GX,GY)|Goals], GX1, GY1) : Res = math.abs(MyX - GX) + math.abs(MyY - GY) &  Res < ResAux <- !closest_goal(GoalX, GoalY, MyX, MyY, Res, Goals, GX, GY).
+!closest_goal(GoalX, GoalY, MyX, MyY, ResAux, [goal(GX,GY)|Goals], GX1, GY1)  <- !closest_goal(GoalX, GoalY, MyX, MyY, ResAux, Goals, GX1, GY1).

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
			getMyPos(MyX,MyY);
			!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
			!closest_goal(GoalX, GoalY, UpdatedX, UpdatedY, 99999, Goals, 0, 0);
			.print("@@@@@@@@@@@@@@ Closest goal X ",GoalX," Y ",GoalY);
			.broadcast(tell, stop::first_to_stop(Me));
			!action::forget_old_action;
			!!stop::become_origin(GoalX, GoalY);
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
	.print("ADD really stop belief");
	+stop::really_stop;
	joinRetrievers(Flag);
	if (Flag == "deliverer") {
		.print("Removing explorer");
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_deliverer;
	}
	else {
		.print("Removing explorer");
		-exploration::special(_);
		-common::avoid(_);
		-common::escape;
		!action::forget_old_action;
		!!stop::become_retriever;
	}
//	!!retrieve::retrieve_block;
	.
	
+stop : true <- -stop::stop.

+!stop::become_retriever :
	true
<-
	!common::change_role(retriever);
	!default::always_skip;
//	!retrieve::retrieve_block;
	.
	
+!stop::become_deliverer :
	true
<-
	!common::change_role(deliverer);
	!default::always_skip;
//	getTargetGoal(_, GoalX, GoalY, _);
//	getMyPos(MyX, MyY);
//	TargetX = GoalX+1 - MyX;
//	TargetY = GoalY - MyY;
//	!!planner::generate_goal(TargetX, TargetY, notblock);
	.
	
+!stop::become_origin(GoalX, GoalY) :
	true
<-
	!common::change_role(origin);
	+retrieve::moving_to_origin;
	!default::always_skip;
//	getMyPos(MyX, MyY);
//	TargetX = GoalX - MyX;
//	TargetY = GoalY - MyY;
//	!!planner::generate_goal(TargetX, TargetY, notblock);
	.

+!stop::explore_as_explorer :
	true
<-
	!common::update_role_to(explorer);
	!!exploration::explore([n,s,e,w]);
	.

//@first_to_stop1[atomic]
//+stop::first_to_stop(Ag)[source(_)] :
//	common::my_role(retriever) & .my_name(Me) & stop::first_to_stop(Me) &
//	.all_names(AllAgents) & .nth(Pos,AllAgents,Me) & .nth(PosOther,AllAgents,Ag) & PosOther < Pos
//<-
//	.print("Removing retriever");
////	removeRetriever;
//	//-retrieve::retriever;
//	-stop::stop;
//	-stop::first_to_stop(Me);
//	!action::forget_old_action;
//	.print("Adding explorer");
//	//+exploration::explorer;
//	!!stop::explore_as_explorer;
//	.
//@first_to_stop2[atomic]
//+stop::first_to_stop(Ag1)[source(_)] :
//	stop::first_to_stop(Ag2)[source(_)] & Ag1 \== Ag2 &
//	.all_names(AllAgents) & .nth(Pos,AllAgents,Ag1) & .nth(PosOther,AllAgents,Ag2)
//<-
//	if(Pos < PosOther){
//		-stop::first_to_stop(Ag2)[source(_)];
//		-stop::first_to_stop(Ag1)[source(_)];
//		+stop::first_to_stop(Ag1)[source(_)];
//	} else{
//		-stop::first_to_stop(Ag1)[source(_)];
//		-stop::first_to_stop(Ag2)[source(_)];
//		+stop::first_to_stop(Ag2)[source(_)];
//	}
//	.
	
//@check_join_group[atomic]
+!stop::check_join_group
	: .my_name(Me) & default::play(Me,explorer,Group) &
	stop::first_to_stop(Ag) & // send a message to the one that stopped asking who the leader is, and you check if you have the same
	map::myMap(Leader) & not stop::really_stop
<-
	.send(Ag, askOne, map::myMap(Leader1), map::myMap(Leader1));
	.print("Leader: ", Leader, " Leader1: ", Leader1);
	if(Leader == Leader1){
		joinRetrievers(Flag);
//		-exploration::explorer;
//		-exploration::special(_);
//		-common::avoid(_);
//		-common::escape;
//		+retrieve::retriever;
//		!action::forget_old_action;
		if (Flag == "stocker") {
			//.print("Removing explorer");
			//-exploration::explorer;
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			!action::forget_old_action;
			!!stop::retrieve_block_as_stocker;
			//!common::update_role_to(stocker);
			//!retrieve::retrieve_block;
		}
		elif (Flag == "helper") {
			//.print("Removing explorer");
			//-exploration::explorer;
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			!action::forget_old_action;
//			.wait(not action::move_sent);
			!!stop::retrieve_block_as_helper;
			/*getMyPos(MyX, MyY);
			!common::update_role_to(helper);
			//+retrieve::retriever;
			//+task::helper;
			+retrieve::moving_to_origin;
			getTargetGoal(_, GoalX, GoalY, _);
			TargetX = GoalX+1 - MyX;
			TargetY = GoalY - MyY;
			!!planner::generate_goal(TargetX, TargetY);*/
//			!!retrieve::move_to_goal;
		}
		else {
			.print("Removing explorer");
			-exploration::special(_);
			-common::avoid(_);
			-common::escape;
			!action::forget_old_action;
			!!stop::retrieve_block_as_retriever;
			//!common::update_role_to(retriever);
			//!retrieve::retrieve_block;
		}
	//		!!retrieve::retrieve_block;
	}
	.
+!stop::check_join_group : true <- .print("I cannot join the stop group yet").

//+!try_call_stop(true).
//+!try_call_stop(false)
//<-
//	!action::skip;
//	callStop(Flag);
//	!try_call_stop(Flag);
//	.

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
	.length(Goals, NGoals) & NGoals >= 1 &
//	.length(Blocks, NBlocks) & 
	.length(Taskboards, NTaskboards) & NTaskboards >= 1 &
	identification::identified(KnownAgs) & .length(KnownAgs, NKnownAgs) & (NKnownAgs + 1) >= 3 &//NBlocks & // enough agents to build the structure
	.findall(Type, (.member(req(_, _, Type), Blocks) & not(.member(dispenser(Type, _, _), Dispensers))), []) // all the necessary types are known
<- 
	.print("I can stop exploring now.");
	.
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

