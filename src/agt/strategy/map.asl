check_stuck([]) :- false.
check_stuck([obstacle(X,Y)|ObsList]) :- (default::obstacle(X-1,Y) & check_path(X,Y,X-1,Y,X,Y)) | (default::obstacle(X-1,Y-1) & check_path(X,Y,X-1,Y-1,X,Y)) | (default::obstacle(X-1,Y+1) & check_path(X,Y,X-1,Y+1,X,Y)) | (default::obstacle(X,Y-1) & check_path(X,Y,X,Y-1,X,Y)) | (default::obstacle(X,Y+1) & check_path(X,Y,X,Y+1,X,Y)) | (default::obstacle(X+1,Y) & check_path(X,Y,X+1,Y,X,Y)) | (default::obstacle(X+1,Y-1) & check_path(X,Y,X+1,Y-1,X,Y)) | (default::obstacle(X+1,Y+1) & check_path(X,Y,X+1,Y+1,X,Y)).

check_path(XOld,YOld,XFirst,YFirst,XFirst,YFirst) :- true.
check_path(XOld,YOld,X,Y,XFirst,YFirst) :- (default::obstacle(X-1,Y) & X-1 \== XOld & Y \== YOld & check_path(X,Y,X-1,Y,XFirst,YFirst)) | (default::obstacle(X-1,Y-1) & X-1 \== XOld & Y-1 \== YOld & check_path(X,Y,X-1,Y-1,XFirst,YFirst)) | (default::obstacle(X-1,Y+1)  & X-1 \== XOld & Y+1 \== YOld & check_path(X,Y,X-1,Y+1,XFirst,YFirst)) | (default::obstacle(X,Y-1) & X \== XOld & Y-1 \== YOld & check_path(X,Y,X,Y-1,XFirst,YFirst)) | (default::obstacle(X,Y+1) & X \== XOld & Y+1 \== YOld & check_path(X,Y,X,Y+1,XFirst,YFirst)) | (default::obstacle(X+1,Y) & X+1 \== XOld & Y \== YOld & check_path(X,Y,X+1,Y,XFirst,YFirst)) | (default::obstacle(X+1,Y-1) & X+1 \== XOld & Y-1 \== YOld & check_path(X,Y,X+1,Y-1,XFirst,YFirst)) | (default::obstacle(X+1,Y+1) & X+1 \== XOld & Y+1 \== YOld & check_path(X,Y,X+1,Y+1,XFirst,YFirst)).

// test plan, should be removed later on
//@testplan[atomic]
//+default::step(X)
//	: X \== 0 & X mod 25 = 0
//<-
//	!printall;
//	.
//	
//+!printall
//<-
//	!get_dispensers(DList);
////	!get_clusters(GList);
//	!get_goals(GList);
//	!get_taskboards(TList);
//	!get_all_size(Size);
//	.print("!!!!!!!!!!!!!!!!!!!!!!");
//	.print("Dispensers: ",DList);
//	.print("Goals: ",GList);
//	.print("Taskboards: ",TList);
//	.print("Number of elements in my map: ",Size);
//	.print("!!!!!!!!!!!!!!!!!!!!!!");
////	getMyPos(MyX,MyY);
////	.print("My position ",MyX,", ",MyY);
//	.

@perceivedispenser[atomic]
+default::thing(X, Y, dispenser, Type)
	: true
<-
	getMyPos(MyX,MyY);
//	.print("Perceived dispenser of type ",Type," at X ",X," at Y ",Y);
	!map::get_dispensers(Dispensers);
	!calculate_updated_pos(MyX,MyY,X,Y,UpdatedX,UpdatedY);
	!map::update_dispenser_in_map(Type, MyX, MyY, X, Y, UpdatedX, UpdatedY, Dispensers);
	.

+!map::update_dispenser_in_map(Type, MyX, MyY, X, Y, UpdatedX, UpdatedY, Dispensers) : .member(dispenser(Type, UpdatedX, UpdatedY), Dispensers) <- true.
+!map::update_dispenser_in_map(Type, MyX, MyY, X, Y, UpdatedX, UpdatedY, Dispensers) 
	: map::myMap(Leader) & default::step(S)
<-
	.concat(dispenser,Type,MyX+X,MyY+Y,UniqueString);
	+action::reasoning_about_belief(UniqueString);
//	.print("Sending to ",Leader, " to add a dispenser at X ",MyX+X," Y ",MyY+Y," at step ",S);
	.send(Leader, achieve, map::add_map(Type, MyX, MyY, X, Y, UniqueString));
	.

@perceivetaskboard[atomic]
+default::thing(X, Y, taskboard, _)
	: true
<-
	getMyPos(MyX,MyY);
//	.print("Perceived taskboard at X ", X, " at Y ", Y);
	!map::get_taskboards(Taskboards);
	!calculate_updated_pos(MyX,MyY,X,Y,UpdatedX,UpdatedY);
	!map::update_taskboard_in_map(MyX, MyY, X, Y, UpdatedX, UpdatedY, Taskboards);
	.
	
+!map::update_taskboard_in_map(MyX, MyY, X, Y, UpdatedX, UpdatedY, Taskboards) : .member(taskboard(UpdatedX, UpdatedY), Taskboards) <- true.
+!map::update_taskboard_in_map(MyX, MyY, X, Y, UpdatedX, UpdatedY, Taskboards) 
	: map::myMap(Leader) & default::step(S)
<-
	.concat(taskboard,MyX+X,MyY+Y,UniqueString);
	+action::reasoning_about_belief(UniqueString);
//	.print("Sending to ",Leader, " to add a taskboard at X ",MyX+X," Y ",MyY+Y," at step ",S);
	.send(Leader, achieve, map::add_map(taskboard, MyX, MyY, X, Y, UniqueString));
	.

@perceivegoal[atomic]
+default::goal(X,Y)
	: true
<-
	getMyPos(MyX,MyY);
//	.print("Perceived goal position at X ", X, " at Y ", Y);
	!map::get_goals(Goals);
	!calculate_updated_pos(MyX,MyY,X,Y,UpdatedX,UpdatedY);
	!map::update_goal_in_map(MyX, MyY, X, Y, UpdatedX, UpdatedY, Goals);
	.
	
+!map::update_goal_in_map(MyX, MyY, X, Y, UpdatedX, UpdatedY, Goals) : .member(goal(UpdatedX, UpdatedY), Goals) <- true.
+!map::update_goal_in_map(MyX, MyY, X, Y, UpdatedX, UpdatedY, Goals) 
	: map::myMap(Leader) & default::step(S)
<-
	.concat(goal,MyX+X,MyY+Y,UniqueString);
	+action::reasoning_about_belief(UniqueString);
//	.print("Sending to ",Leader, " to add a goal at X ",MyX+X," Y ",MyY+Y," at step ",S);
	.send(Leader, achieve, map::add_map(goal, MyX, MyY, X, Y, UniqueString));
	.

//@perceivegoal[atomic]
//+default::goal(X,Y)
//	: not map::evaluating_vertexes & not common::clearing_things
//<-
//	getMyPos(MyX,MyY);
//	!map::get_clusters(Clusters);
//	!map::update_goal_in_map(MyX, MyY, X, Y, Clusters);
//	.

//+!map::update_goal_in_map(MyX, MyY, X, Y, Clusters) : .member(cluster(_, GoalList), Clusters) & (.member(goal(MyX+X, MyY+Y), GoalList) | .member(origin(_, MyX+X, MyY+Y), GoalList)) <- true.
//+!map::update_goal_in_map(MyX, MyY, X, Y, Clusters) 
//	: map::myMap(Leader)
//<-
//	.concat(goal,MyX+X,MyY+Y,UniqueString);
//	+action::reasoning_about_belief(UniqueString);
//	.send(Leader, achieve, map::add_map(goal, MyX, MyY, X, Y, UniqueString));
//	.

	
//+!map::conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)] :
//	map::myMap(Leader) & common::my_role(goal_evaluator) &
//	map::evaluating_positions(Pos) & .my_name(Me) & .all_names(AllAgents) & .nth(Nth,AllAgents,Me) & .nth(Nth1,AllAgents,Ag)
//<-
////	.wait(not action::move_sent);
//	getMyPos(MyX, MyY);
//	.print(conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)], ", Pos: ", Pos, " Goal: ", GoalX, " ", GoalY);
//	if((.member(origin(_, MyX+GoalX, MyY+GoalY), Pos) | .member(start(MyX+GoalX, MyY+GoalY), Pos)) & 
//		Nth1 < Nth
//	) {
//		!common::go_back_to_previous_role;
//		if(common::my_role(retriever)){
//			!!retrieve::move_to_goal;
//		} elif(default::play(Me,explorer,Group)){
//			!!exploration::explore([n,s,w,e]);
//		}
//	}
//	.
//+!map::conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)] : true <- .print(conditional_stop_evaluating(Leader, GoalX, GoalY)[source(Ag)]).
	
//+!map::move_random(Steps) :
//	not default::lastActionResult(success)
//<-
//	for(.range(_, 1, Steps) & .random(R) & .nth(math.floor(R*3.99), [n,s,w,e], Dir)){
//		!retrieve::smart_move(Dir);
//	}
//	.
//+!map::move_random(_).

//	if(Type == goal) {
//		updateGoalMap(Me, MyX+X, MyY+Y, InsertedInCluster, IsANewCluster);
//		if(IsANewCluster){
//			if(S \== "self"){
//				.send(Ag, askOne, map::available_to_evaluate(Res, X, Y), map::available_to_evaluate(Res, _, _));
//				.print("@@@@@@@@@@@@@@@@@@@ RES: ", Res);
//				if(Res == 1){
//					.send(Ag, achieve, map::evaluate(X, Y));
//				}
//			} elif(not common::my_role(goal_evaluator)){
//				.send(Ag, achieve, map::evaluate(X, Y));
//				//!map::evaluate(X, Y);
//			}	
//		}
//		//!retrieve::update_target;

@addmap1[atomic]
+!add_map(Type, MyX, MyY, X, Y, UniqueString)[source(Ag)]
	: .my_name(Me) & map::myMap(Me)
<-
	.term2string(Ag,S);
	!calculate_updated_pos(MyX,MyY,X,Y,UpdatedX,UpdatedY);
	if(Type == goal) {
		!map::get_goals(Goals);
		if (not .member(goal(_,_), Goals)) {
			updateMap(Me, Type, UpdatedX, UpdatedY);
			?identification::identified(IdList);
			for (.member(Ag,IdList)) {
				.send(Ag, achieve, stop::new_dispenser_or_taskboard_or_merge);
			}
			!stop::new_dispenser_or_taskboard_or_merge;
		}	
		elif(not .member(goal(UpdatedX,UpdatedY), Goals)){
			updateMap(Me, Type, UpdatedX, UpdatedY);
		}
//		.print("@@@@@ Adding goal  at X ",UpdatedX," Y ",UpdatedY," Agent that requested ",Ag);
//		.print("@@@@@ Old list of goals ", Goals);
	} elif(Type == taskboard) {
		!map::get_taskboards(Taskboards);
		if (not .member(taskboard(_,_), Taskboards)) {
			updateMap(Me, Type, UpdatedX, UpdatedY);
			?identification::identified(IdList);
			for (.member(Ag,IdList)) {
				.send(Ag, achieve, stop::new_dispenser_or_taskboard_or_merge);
			}
			!stop::new_dispenser_or_taskboard_or_merge;
		}	
		elif(not .member(taskboard(UpdatedX,UpdatedY), Taskboards)){
			updateMap(Me, Type, UpdatedX, UpdatedY);
		}
//		.print("@@@@@ Adding taskboard  at X ",UpdatedX," Y ",UpdatedY," Agent that requested ",Ag);
//		.print("@@@@@ Old list of taskboards ", Taskboards);
	} else {
		!map::get_dispensers(Dispensers);
		if (not .member(dispenser(Type,_,_),Dispensers)) {
			updateMap(Me, Type, UpdatedX, UpdatedY);
			?identification::identified(IdList);
			for (.member(Ag,IdList)) {
				.send(Ag, achieve, stop::new_dispenser_or_taskboard_or_merge);
			}
			!stop::new_dispenser_or_taskboard_or_merge;
		}	
		elif(not .member(dispenser(Type,UpdatedX,UpdatedY), Dispensers)){
			updateMap(Me, Type, UpdatedX, UpdatedY);
		}
//		.print("@@@@@ Adding dispenser type ",Type," Dispenser X ",UpdatedX," Dispenser Y ",UpdatedY," Agent that requested ",Ag);
//		.print("@@@@@ Old list of dispensers ",Dispensers);
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
	
+!get_goals(List)
	: map::myMap(Me)
<-
	getGoals(Me, List);
	.
	
+!get_clusters(List)
	: map::myMap(Me)
<-
	getGoalClusters(Me, List);
	.
	
+!get_all_size(Size)
	: map::myMap(Me)
<-
	getAllSize(Me, Size);
	.
	
+!calculate_updated_pos(MyX,MyY,X,Y,UpdatedX,UpdatedY)
<-
	if (map::size(x, SizeX) & map::size(y, SizeY)) {
		if (MyX+X < 0) {
			UpdatedX = ((MyX+X) mod SizeX) + SizeX;
		} else {
			UpdatedX = (MyX+X) mod SizeX;
		}
		if (MyY+Y < 0) {
			UpdatedY = ((MyY+Y) mod SizeY) + SizeY;
		} else {
			UpdatedY = (MyY+Y) mod SizeY;
		}
	}
	elif (map::size(x, Size)) {
		if (MyX+X < 0) {
			UpdatedX = ((MyX+X) mod Size) + Size;
		} else {
			UpdatedX = (MyX+X) mod Size;
		}
		UpdatedY = MyY+Y;
	}
	elif (map::size(y, Size)) {
		UpdatedX = MyX+X;
		if (MyY+Y < 0) {
			UpdatedY = ((MyY+Y) mod Size) + Size;
		} else {
			UpdatedY = (MyY+Y) mod Size;
		}
	}
	else {
		UpdatedX = MyX+X;
		UpdatedY = MyY+Y;
	}
	.
	
+!map::normalise_distance(Axis, Distance, NormalisedDistance)
	: map::size(Axis, Size)
<-
	if (Distance < 0) {
		NormalisedDistance = Distance + Size;
	}
	elif (Distance > 0) {
		NormalisedDistance = Distance - Size;
	}
	else {
		NormalisedDistance = Distance;
	}
	.

+!map::best_route(Distance,NormalisedDistance,NewTarget)
	: true
<-
	if (math.abs(Distance) < math.abs(NormalisedDistance)) {
		NewTarget = Distance;
	}
	else {
		NewTarget = NormalisedDistance;
	}
	.

@map_size[atomic]
+map::size(Axis, Size)
	: .my_name(Me) & map::myMap(Me)
<- 
//	.print("################# Axis ",Axis," is of size ",Size);
	updateLocations(Me, Axis, Size);
//	!printall;
	.
@map_size2[atomic]
+map::size(Axis, Size).
//<- 
//	.print("################# Axis ",Axis," is of size ",Size);
//	.
	