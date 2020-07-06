check_stuck([]) :- false.
check_stuck([obstacle(X,Y)|ObsList]) :- (default::obstacle(X-1,Y) & check_path(X,Y,X-1,Y,X,Y)) | (default::obstacle(X-1,Y-1) & check_path(X,Y,X-1,Y-1,X,Y)) | (default::obstacle(X-1,Y+1) & check_path(X,Y,X-1,Y+1,X,Y)) | (default::obstacle(X,Y-1) & check_path(X,Y,X,Y-1,X,Y)) | (default::obstacle(X,Y+1) & check_path(X,Y,X,Y+1,X,Y)) | (default::obstacle(X+1,Y) & check_path(X,Y,X+1,Y,X,Y)) | (default::obstacle(X+1,Y-1) & check_path(X,Y,X+1,Y-1,X,Y)) | (default::obstacle(X+1,Y+1) & check_path(X,Y,X+1,Y+1,X,Y)).

check_path(XOld,YOld,XFirst,YFirst,XFirst,YFirst) :- true.
check_path(XOld,YOld,X,Y,XFirst,YFirst) :- (default::obstacle(X-1,Y) & X-1 \== XOld & Y \== YOld & check_path(X,Y,X-1,Y,XFirst,YFirst)) | (default::obstacle(X-1,Y-1) & X-1 \== XOld & Y-1 \== YOld & check_path(X,Y,X-1,Y-1,XFirst,YFirst)) | (default::obstacle(X-1,Y+1)  & X-1 \== XOld & Y+1 \== YOld & check_path(X,Y,X-1,Y+1,XFirst,YFirst)) | (default::obstacle(X,Y-1) & X \== XOld & Y-1 \== YOld & check_path(X,Y,X,Y-1,XFirst,YFirst)) | (default::obstacle(X,Y+1) & X \== XOld & Y+1 \== YOld & check_path(X,Y,X,Y+1,XFirst,YFirst)) | (default::obstacle(X+1,Y) & X+1 \== XOld & Y \== YOld & check_path(X,Y,X+1,Y,XFirst,YFirst)) | (default::obstacle(X+1,Y-1) & X+1 \== XOld & Y-1 \== YOld & check_path(X,Y,X+1,Y-1,XFirst,YFirst)) | (default::obstacle(X+1,Y+1) & X+1 \== XOld & Y+1 \== YOld & check_path(X,Y,X+1,Y+1,XFirst,YFirst)).

// test plan, should be removed later on
@testplan[atomic]
+default::step(X)
	: X \== 0 & X mod 25 = 0
<-
	!get_dispensers(DList);
	!get_clusters(GList);
	!get_map_size(Size);
	.print(DList);
	.print(GList);
	.print(Size);
//	getMyPos(MyX,MyY);
//	.print("My position ",MyX,", ",MyY);
	.

@perceivedispenser[atomic]
+default::thing(X, Y, dispenser, Type)
	: true
<-
	getMyPos(MyX,MyY);
//	.print("Perceived dispenser of type ",Type," at X ",X," at Y ",Y);
	!map::get_dispensers(Dispensers);
	!map::update_dispenser_in_map(Type, MyX, MyY, X, Y, Dispensers);
	.

+!map::update_dispenser_in_map(Type, MyX, MyY, X, Y, Dispensers) : .member(dispenser(Type, MyX+X, MyY+Y), Dispensers) <- true.
+!map::update_dispenser_in_map(Type, MyX, MyY, X, Y, Dispensers) 
	: map::myMap(Leader) & default::step(S)
<-
	.concat(dispenser,Type,MyX+X,MyY+Y,UniqueString);
	+action::reasoning_about_belief(UniqueString);
	.print("Sending to ",Leader, " to add a dispenser at X ",MyX+X," Y ",MyY+Y," at step ",S);
	.send(Leader, achieve, map::add_map(Type, MyX, MyY, X, Y, UniqueString));
	.

@perceivetaskboard[atomic]
+default::thing(X, Y, taskboard, _)
	: true
<-
	getMyPos(MyX,MyY);
	.print("Perceived taskboard at X ", X, " at Y ", Y);
	!map::get_taskboards(Taskboards);
	!map::update_taskboard_in_map(MyX, MyY, X, Y, Taskboards);
	.
	
+!map::update_taskboard_in_map(MyX, MyY, X, Y, Taskboards) : .member(taskboard(MyX+X, MyY+Y), Taskboards) <- true.
+!map::update_taskboard_in_map(MyX, MyY, X, Y, Taskboards) 
	: map::myMap(Leader) & default::step(S)
<-
	.concat(taskboard,MyX+X,MyY+Y,UniqueString);
	+action::reasoning_about_belief(UniqueString);
	.print("Sending to ",Leader, " to add a taskboard at X ",MyX+X," Y ",MyY+Y," at step ",S);
	.send(Leader, achieve, map::add_map(taskboard, MyX, MyY, X, Y, UniqueString));
	.

@perceivegoal[atomic]
+default::goal(X,Y)
	: not map::evaluating_vertexes & not common::clearing_things
<-
	getMyPos(MyX,MyY);
	!map::get_clusters(Clusters);
	!map::update_goal_in_map(MyX, MyY, X, Y, Clusters);
	.

+!map::update_goal_in_map(MyX, MyY, X, Y, Clusters) : .member(cluster(_, GoalList), Clusters) & (.member(goal(MyX+X, MyY+Y), GoalList) | .member(origin(_, MyX+X, MyY+Y), GoalList)) <- true.
+!map::update_goal_in_map(MyX, MyY, X, Y, Clusters) 
	: map::myMap(Leader)
<-
	.concat(goal,MyX+X,MyY+Y,UniqueString);
	+action::reasoning_about_belief(UniqueString);
	.send(Leader, achieve, map::add_map(goal, MyX, MyY, X, Y, UniqueString));
	.

	
+!map::conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)] :
	map::myMap(Leader) & common::my_role(goal_evaluator) &
	map::evaluating_positions(Pos) & .my_name(Me) & .all_names(AllAgents) & .nth(Nth,AllAgents,Me) & .nth(Nth1,AllAgents,Ag)
<-
//	.wait(not action::move_sent);
	getMyPos(MyX, MyY);
	.print(conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)], ", Pos: ", Pos, " Goal: ", GoalX, " ", GoalY);
	if((.member(origin(_, MyX+GoalX, MyY+GoalY), Pos) | .member(start(MyX+GoalX, MyY+GoalY), Pos)) & 
		Nth1 < Nth
	) {
		!common::go_back_to_previous_role;
		if(common::my_role(retriever)){
			!!retrieve::move_to_goal;
		} elif(default::play(Me,explorer,Group)){
			!!exploration::explore([n,s,w,e]);
		}
	}
	.
+!map::conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)] : true <- .print(conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)]).
	
+!map::move_random(Steps) :
	not default::lastActionResult(success)
<-
	for(.range(_, 1, Steps) & .random(R) & .nth(math.floor(R*3.99), [n,s,w,e], Dir)){
		!retrieve::smart_move(Dir);
	}
	.
+!map::move_random(_).

@addmap1[atomic]
+!add_map(Type, MyX, MyY, X, Y, UniqueString)[source(Ag)]
	: .my_name(Me) & map::myMap(Me)
<-
	.term2string(Ag,S);
	if(Type == goal) {
		updateGoalMap(Me, MyX+X, MyY+Y, InsertedInCluster, IsANewCluster);
		if(IsANewCluster){
			if(S \== "self"){
				.send(Ag, askOne, map::available_to_evaluate(Res, X, Y), map::available_to_evaluate(Res, _, _));
				.print("@@@@@@@@@@@@@@@@@@@ RES: ", Res);
				if(Res == 1){
					.send(Ag, achieve, map::evaluate(X, Y));
				}
			} elif(not common::my_role(goal_evaluator)){
				.send(Ag, achieve, map::evaluate(X, Y));
				//!map::evaluate(X, Y);
			}	
		}
		//!retrieve::update_target;
	} elif(Type == taskboard) {
		!map::get_taskboards(Taskboards);
		if (not .member(taskboard(_,_), Taskboards)) {
			updateMap(Me, Type, MyX+X, MyY+Y);
			?identification::identified(IdList);
			for (.member(Ag,IdList)) {
				.send(Ag, achieve, stop::new_taskboard_or_merge);
			}
			!stop::new_taskboard_or_merge;
		}	
		elif(not .member(taskboard(MyX+X,MyY+Y), Taskboards)){
			updateMap(Me, Type, MyX+X, MyY+Y);
		}
		.print("@@@@@ Adding taskboard  at X ",MyX+X," Y ",MyY+Y," Agent that requested ",Ag);
		.print("@@@@@ Old list of taskboards ", Taskboards);
	} else {
		!map::get_dispensers(Dispensers);
		if (not .member(dispenser(Type,_,_),Dispensers)) {
			updateMap(Me, Type, MyX+X, MyY+Y);
			?identification::identified(IdList);
			for (.member(Ag,IdList)) {
				.send(Ag, achieve, stop::new_dispenser_or_taskboard_or_merge);
			}
			!stop::new_dispenser_or_taskboard_or_merge;
		}	
		elif(not .member(dispenser(Type,MyX+X,MyY+Y), Dispensers)){
			updateMap(Me, Type, MyX+X, MyY+Y);
		}
		.print("@@@@@ Adding dispenser type ",Type," Dispenser X ",MyX+X," Dispenser Y ",MyY+Y," Agent that requested ",Ag);
		.print("@@@@@ Old list of dispensers ",Dispensers);
	}
	if (S == "self") {
		!identification::remove_reasoning(UniqueString);
	}
	else {
		.send(Ag, achieve, identification::remove_reasoning(UniqueString));
	}
	.
@addmap2[atomic]
+!add_map(Type, MyX, MyY, X, Y, UniqueString)[source(Ag)]
<-
	.term2string(Ag,S);
	if (S == "self") {
		!identification::remove_reasoning(UniqueString);
	}
	else {
		.send(Ag, achieve, identification::remove_reasoning(UniqueString));
	}
	.



+!get_dispensers(List)
	: map::myMap(Me)
<-
	getDispensers(Me, List);
	.

+!get_taskboards(List)
	: map::myMap(Me)
<-
	getTaskboards(Me, List);
	.
	
+!get_goals(Cluster, List)
	: map::myMap(Me)
<-
	getGoals(Me, Cluster, List);
	.
	
+!get_clusters(List)
	: map::myMap(Me)
<-
	getGoalClusters(Me, List);
	.
	
+!get_map_size(Size)
	: map::myMap(Me)
<-
	getMapSize(Me, Size);
	.
	