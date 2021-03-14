dispenser_in_vision :-
	.findall(d(X,Y), (default::thing(X, Y, dispenser, _) &
	(math.abs(X) + math.abs(Y)) <= 3), Dispensers) &
	not (Dispensers = []).

+!generate_goal(0, 0, Aux) 
	: .my_name(Me) & default::play(Me,retriever,Group) & retrieve::collect_block(_,_)
<- 
//	.print("Time to collect a block!");
	!!retrieve::get_block;
	.
	
+!generate_goal(0, 0, Aux) 
	: .my_name(Me) & default::play(Me,useless,Group)
<- 
	!!default::always_skip;
	.
	
+!generate_goal(0, 0, Aux) 
	: .my_name(Me) & default::play(Me,retriever,Group) & back_to_origin & retrieve::block(BlockX,BlockY) & not retrieve::getting_to_position
<- 
	if (default::energy(Energy) & Energy >= 30) {
		Clear = 1;
	}
	else {
		Clear = 0;
	}
	callPlanner(Flag);
	!try_call_planner(Flag);
	getPlanBlockToGoal(Me, 0, 0, BlockX, BlockY, Plan, Clear);
	plannerDone;
//	.print("@@@@@@ Plan get plan block to goal: ",Plan);
	!planner::execute_plan(Plan, 0, 0, 0, 0);
	-back_to_origin;
	.
	
+!generate_goal(0, 0, Aux) 
	: .my_name(Me) & default::play(Me,retriever,Group)
	& dispenser_in_vision
<- 
	getMyPos(MyX, MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	?team::teamLeader(TeamLeader);
	getRetrieverAvailablePos(TeamLeader, UpdatedX, UpdatedY, TargetXGlobal, TargetYGlobal);
	DistanceX = TargetXGlobal - UpdatedX;
	DistanceY = TargetYGlobal - UpdatedY;
	!map::normalise_distance(x, DistanceX,NormalisedDistanceX);
	!map::normalise_distance(y, DistanceY,NormalisedDistanceY);
	!map::best_route(DistanceX,NormalisedDistanceX,NewTargetX);
	!map::best_route(DistanceY,NormalisedDistanceY,NewTargetY);
	!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	.
	
+!generate_goal(0, 0, Aux) 
	: .my_name(Me) & default::play(Me,retriever,Group) & retrieve::block(X,Y) & default::thing(X,Y,block,Type)
<- 
	?team::teamLeader(TeamLeader);
	addAvailableAgent(TeamLeader,Me,Type);
	-retrieve::getting_to_position;
	+back_to_origin;
	!!default::always_skip;
	.
	
+!generate_goal(0, 0, Aux) 
	: .my_name(Me) & default::play(Me,origin,Group)
<- 
 	if (default::goal(0,0)) {
		+task::origin;
		!!default::always_skip;
	}
	elif (default::goal(X,Y)) {
		!generate_goal(X, Y, Aux);
	}
	.
+!generate_goal(0, 0, Aux) 
	: not task::deliverer & .my_name(Me) & default::play(Me,deliverer,Group) & team::teamLeader(Ag)
<- 
 	if (default::thing(X, Y, taskboard, _) & X <= 2 & Y <= 2) {
 		.print("@@@@@@@@@@@@@@@@@@@ Deliverer in position");
		+task::deliverer;
		.send(Ag, tell, task::deliverer_in_position_no_task(Me));
		.broadcast(tell, team::deliverer(Leader));
		!!default::always_skip;
	}
	elif (default::thing(X, Y, taskboard, _)) {
		!generate_goal(X, Y, Aux);
	}
	.
+!generate_goal(0, 0, Aux) 
	: task::deliverer & .my_name(Me) & default::play(Me,deliverer,Group) & team::teamLeader(Ag)
<- 
	.send(Ag, tell, task::deliverer_in_position_task(Me));
	!!default::always_skip;
	.
+!generate_goal(0, 0, Aux)  : .my_name(Me) & default::play(Me,retriever,Group).
+!generate_goal(0, 0, Aux)  : .my_name(Me) & default::play(Me,explorer,Group).
+!generate_goal(0, 0, Aux)  : .my_name(Me) & default::play(Me,bully,Group).
//+!generate_goal(0, 0) <- !!default::always_skip.
+!generate_goal(TargetX, TargetY, Aux)
	: .my_name(Me)
<-
//	.print("Start of the planner");
	callPlanner(Flag);
	!try_call_planner(Flag);

	if(TargetX <= -5){
		LocalTargetX = -5;
	} elif(TargetX >= 5){
		LocalTargetX = 5;
	} else {
		LocalTargetX = TargetX;
	}
	if(TargetY <= -5){
		LocalTargetY = -5;
	} elif(TargetY >= 5){
		LocalTargetY = 5;
	} else {
		LocalTargetY = TargetY;
	}
	Sum = math.abs(LocalTargetX) + math.abs(LocalTargetY);
	if(Sum > 5){
		DeltaX = math.floor((Sum - 5) / 2);
		if(((Sum-5) mod 2) == 0) {
			DeltaY = DeltaX;
		} else {
			DeltaY = DeltaX + 1;	
		}
		if(LocalTargetX > 0){
			FinalLocalTargetX = LocalTargetX - DeltaX;
		} else {
			FinalLocalTargetX = LocalTargetX + DeltaX;
		}
		if(LocalTargetY > 0){
			FinalLocalTargetY = LocalTargetY - DeltaY;
		} else {
			FinalLocalTargetY = LocalTargetY + DeltaY;
		}
	} else {
		FinalLocalTargetX = LocalTargetX;
		FinalLocalTargetY = LocalTargetY;
	}
//	.print("Where we'd like to go ", FinalLocalTargetX, ", ", FinalLocalTargetY);
	if (task::doing_task) {
		ActualFinalLocalTargetX = FinalLocalTargetX;
		ActualFinalLocalTargetY = FinalLocalTargetY;
		FinalTargetX = TargetX;
		FinalTargetY = TargetY;
	}
	elif (math.abs(TargetX) + math.abs(TargetY) > 3) {
//		.print("Target is distance 4 or more away.");
		!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY);
		FinalTargetX = TargetX;
		FinalTargetY = TargetY;
	}
	else {
		if (not (default::thing(FinalLocalTargetX, FinalLocalTargetY, Type, _) & (Type == block | Type == entity))) {
			ActualFinalLocalTargetX = FinalLocalTargetX;
			ActualFinalLocalTargetY = FinalLocalTargetY;
			FinalTargetX = TargetX;
			FinalTargetY = TargetY;
		}
		else {
			!action::skip;
			if (not (default::thing(FinalLocalTargetX, FinalLocalTargetY, Type2, _) & (Type2 == block | Type2 == entity))) {
				ActualFinalLocalTargetX = FinalLocalTargetX;
				ActualFinalLocalTargetY = FinalLocalTargetY;
				FinalTargetX = TargetX;
				FinalTargetY = TargetY;
			}
			else {
				if (.my_name(Me) & default::play(Me,retriever,Group) & retrieve::collect_block(AddX,AddY)) {
					-retrieve::collect_block(AddX,AddY);
					if (default::thing(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY,dispenser,_) & not (default::thing(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY,entity,Team))) {
						if (AddX == -1) {
							if (not (default::thing(FinalLocalTargetX-2, FinalLocalTargetY, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(-1,0);
								FinalTargetX = FinalLocalTargetX-2;
								FinalTargetY = FinalLocalTargetY;
								ActualFinalLocalTargetX = FinalLocalTargetX-2;
								ActualFinalLocalTargetY = FinalLocalTargetY;
							}
							elif (not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(0,1);
								FinalTargetX = FinalLocalTargetX-1;
								FinalTargetY = FinalLocalTargetY+1;
								ActualFinalLocalTargetX = FinalLocalTargetX-1;
								ActualFinalLocalTargetY = FinalLocalTargetY+1;
							}
							elif (not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(0,-1);
								FinalTargetX = FinalLocalTargetX-1;
								FinalTargetY = FinalLocalTargetY-1;
								ActualFinalLocalTargetX = FinalLocalTargetX-1;
								ActualFinalLocalTargetY = FinalLocalTargetY-1;
							}
							else {
								.fail(impossible_dispenser(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY));
							}
						}
						elif (AddX == 1) {
							if (not (default::thing(FinalLocalTargetX+2, FinalLocalTargetY, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(1,0);
								FinalTargetX = FinalLocalTargetX+2;
								FinalTargetY = FinalLocalTargetY;
								ActualFinalLocalTargetX = FinalLocalTargetX+2;
								ActualFinalLocalTargetY = FinalLocalTargetY;
							}
							elif (not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(0,1);
								FinalTargetX = FinalLocalTargetX+1;
								FinalTargetY = FinalLocalTargetY+1;
								ActualFinalLocalTargetX = FinalLocalTargetX+1;
								ActualFinalLocalTargetY = FinalLocalTargetY+1;
							}
							elif (not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(0,-1);
								FinalTargetX = FinalLocalTargetX+1;
								FinalTargetY = FinalLocalTargetY-1;
								ActualFinalLocalTargetX = FinalLocalTargetX+1;
								ActualFinalLocalTargetY = FinalLocalTargetY-1;
							}
							else {
								.fail(impossible_dispenser(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY));
							}
						}
						elif (AddY == 1) {
							if (not (default::thing(FinalLocalTargetX, FinalLocalTargetY+2, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(0,1);
								FinalTargetX = FinalLocalTargetX;
								FinalTargetY = FinalLocalTargetY+2;
								ActualFinalLocalTargetX = FinalLocalTargetX;
								ActualFinalLocalTargetY = FinalLocalTargetY+2;
							}
							elif (not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(1,0);
								FinalTargetX = FinalLocalTargetX+1;
								FinalTargetY = FinalLocalTargetY+1;
								ActualFinalLocalTargetX = FinalLocalTargetX+1;
								ActualFinalLocalTargetY = FinalLocalTargetY+1;
							}
							elif (not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(-1,0);
								FinalTargetX = FinalLocalTargetX-1;
								FinalTargetY = FinalLocalTargetY+1;
								ActualFinalLocalTargetX = FinalLocalTargetX-1;
								ActualFinalLocalTargetY = FinalLocalTargetY+1;
							}
							else {
								.fail(impossible_dispenser(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY));
							}
						}
						elif (AddY == -1) {
							if (not (default::thing(FinalLocalTargetX, FinalLocalTargetY-2, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(0,-1);
								FinalTargetX = FinalLocalTargetX;
								FinalTargetY = FinalLocalTargetY-2;
								ActualFinalLocalTargetX = FinalLocalTargetX;
								ActualFinalLocalTargetY = FinalLocalTargetY-2;
							}
							elif (not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(1,0);
								FinalTargetX = FinalLocalTargetX+1;
								FinalTargetY = FinalLocalTargetY-1;
								ActualFinalLocalTargetX = FinalLocalTargetX+1;
								ActualFinalLocalTargetY = FinalLocalTargetY-1;
							}
							elif (not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))) {
								+retrieve::collect_block(-1,0);
								FinalTargetX = FinalLocalTargetX-1;
								FinalTargetY = FinalLocalTargetY-1;
								ActualFinalLocalTargetX = FinalLocalTargetX-1;
								ActualFinalLocalTargetY = FinalLocalTargetY-1;
							}
							else {
								.fail(impossible_dispenser(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY));
							}
						}
					}
					else {
						.fail(impossible_dispenser(FinalLocalTargetX+AddX,FinalLocalTargetY+AddY));
					}
				}
				else {
					!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY);
					FinalTargetX = ActualFinalLocalTargetX;
					FinalTargetY = ActualFinalLocalTargetY;
				}
			}
		}
	}
//	.print("Where we are actually going ", ActualFinalLocalTargetX, ", ", ActualFinalLocalTargetY);
	if (default::energy(Energy) & Energy >= 30) {
		Clear = 1;
	}
	else {
		Clear = 0;
	}
//	if (planner::back_to_origin & retrieve::block(BlockX,BlockY)) {
////		if (math.abs(TargetX) + math.abs(TargetY) <= 5 & ActualFinalLocalTargetX == FinalLocalTargetX & ActualFinalLocalTargetY == FinalLocalTargetY & dumb_bugfix) {
////			getPlanBlockToGoal(Me, ActualFinalLocalTargetX, ActualFinalLocalTargetY, BlockX, BlockY, Plan, Clear);
////		}
////		else {
//		getPlanAgentToGoal(Me, ActualFinalLocalTargetX, ActualFinalLocalTargetY, BlockX, BlockY, Plan, Clear);
////		}
//	}
	if (retrieve::block(BlockX,BlockY)) {
		getPlanAgentToGoal(Me, ActualFinalLocalTargetX, ActualFinalLocalTargetY, BlockX, BlockY, Plan, Clear);
	}
	else {
		getPlanAgentToGoal(Me, ActualFinalLocalTargetX, ActualFinalLocalTargetY, Plan, Clear);
	}
	plannerDone;
//	.print("@@@@@@ Plan: ",Plan);
	!planner::execute_plan(Plan, FinalTargetX, FinalTargetY, ActualFinalLocalTargetX, ActualFinalLocalTargetY);
	.

-!generate_goal(TargetX, TargetY, Aux)[code(.fail(goal_blocked))]
<-
	plannerDone;
	!execute_plan([], TargetX, TargetY, TargetX, TargetY);
	.
-!generate_goal(TargetX, TargetY, Aux)[code(.fail(impossible_dispenser(FinalLocalTargetX,FinalLocalTargetY)))]
	: .my_name(Me)
<-
	plannerDone;
	?team::teamLeader(TeamLeader);
	removeBlock(TeamLeader, Me);
	getMyPos(MyX, MyY);
	DispX = MyX + FinalLocalTargetX;
	DispY = MyY + FinalLocalTargetY;
	+retrieve::minus_one(DispX,DispY);
	!!retrieve::retrieve_block;
	.
	
+!try_call_planner(true).
+!try_call_planner(false)
<-
	!action::skip;
	callPlanner(Flag);
	!try_call_planner(Flag);
	.
	
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: not (default::thing(FinalLocalTargetX, FinalLocalTargetY, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX;
	ActualFinalLocalTargetY = FinalLocalTargetY;
	.
// 5 0 
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == 5 & not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX-1;
	ActualFinalLocalTargetY = FinalLocalTargetY;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == 5 & not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX-1;
	ActualFinalLocalTargetY = FinalLocalTargetY-1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == 5 & not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX-1;
	ActualFinalLocalTargetY = FinalLocalTargetY+1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == 5
<-
	.fail(goal_blocked).
// -5 0 
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == -5 & not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX+1;
	ActualFinalLocalTargetY = FinalLocalTargetY;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == -5 & not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX+1;
	ActualFinalLocalTargetY = FinalLocalTargetY-1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == -5 & not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX+1;
	ActualFinalLocalTargetY = FinalLocalTargetY+1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 0 & FinalLocalTargetX == -5
<-
	.fail(goal_blocked).
// 0 -5
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == -5 & FinalLocalTargetX == 0 & not (default::thing(FinalLocalTargetX, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX;
	ActualFinalLocalTargetY = FinalLocalTargetY+1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == -5 & FinalLocalTargetX == 0 & not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX-1;
	ActualFinalLocalTargetY = FinalLocalTargetY+1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == -5 & FinalLocalTargetX == 0 & not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY+1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX+1;
	ActualFinalLocalTargetY = FinalLocalTargetY+1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == -5 & FinalLocalTargetX == 0
<-
	.fail(goal_blocked).
// 0 5
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 5 & FinalLocalTargetX == 0 & not (default::thing(FinalLocalTargetX, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX;
	ActualFinalLocalTargetY = FinalLocalTargetY-1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 5 & FinalLocalTargetX == 0 & not (default::thing(FinalLocalTargetX-1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX-1;
	ActualFinalLocalTargetY = FinalLocalTargetY-1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 5 & FinalLocalTargetX == 0 & not (default::thing(FinalLocalTargetX+1, FinalLocalTargetY-1, Type, _) & (Type == block | Type == entity))
<-
	ActualFinalLocalTargetX = FinalLocalTargetX+1;
	ActualFinalLocalTargetY = FinalLocalTargetY-1;
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: FinalLocalTargetY == 5 & FinalLocalTargetX == 0
<-
	.fail(goal_blocked).
// All other cases will call the closest of the cases above
// The important assumption here is that the goal is not in vision!
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: math.abs(FinalLocalTargetY) < math.abs(FinalLocalTargetX) & FinalLocalTargetX > 0
<-
	!generate_actual_goal(5,0,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: math.abs(FinalLocalTargetY) < math.abs(FinalLocalTargetX) & FinalLocalTargetX < 0
<-
	!generate_actual_goal(-5,0,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: math.abs(FinalLocalTargetY) > math.abs(FinalLocalTargetX) & FinalLocalTargetY > 0
<-
	!generate_actual_goal(0,5,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	: math.abs(FinalLocalTargetY) > math.abs(FinalLocalTargetX) & FinalLocalTargetY < 0
<-
	!generate_actual_goal(0,-5,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
	.
+!generate_actual_goal(FinalLocalTargetX,FinalLocalTargetY,ActualFinalLocalTargetX,ActualFinalLocalTargetY)
<-
	.fail(goal_blocked).


+!execute_plan(Plan, 0, 0, 0, 0)
	: back_to_origin
<-
	for (.member(Action, Plan)){
		if (.substring("clear",Action)) {
			for(.range(I, 1, 3)){
//				.print("@@@@ Action: ", Action);
				!action::Action;
			}
		}
		else {
//			.print("@@@@ Action: ", Action);
			!action::Action;
			while (not default::lastActionResult(success)) {
				!action::Action;
			}
		}
	}
	.
	
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetX < 0 & not (default::thing(-1, 0, Type, _) & (Type == block | Type == entity)) & not (default::obstacle(-1,0)) 
<-
	!action::move(w);
//	.print("Execute empty plan by moving west");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX + 1, TargetY, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
	
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetX > 0 & not (default::thing(1, 0, Type, _)  & (Type == block | Type == entity)) & not (default::obstacle(1,0))
<-	
	!action::move(e);
//	.print("Execute empty plan by moving east");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX - 1, TargetY, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
	
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetY < 0 & not (default::thing(0, -1, Type, _)  & (Type == block | Type == entity)) & not (default::obstacle(0, -1))
<-	
	!action::move(n);
//	.print("Execute empty plan by moving north");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX, TargetY + 1, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.

+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetY > 0 & not (default::thing(0, 1, Type, _)  & (Type == block | Type == entity)) & not (default::obstacle(0, 1))
<-		
	!action::move(s);
//	.print("Execute empty plan by moving south");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX, TargetY - 1, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
// If all the above failed, then try to move in the opposite direction of the goal
// All the following plans will miserably fail if the only possible direction is the one with the attached block...
// Rafael, you might know how to deal with this.

// I'd like to go east, but I'm giving up and going west
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetX > 0 & (not (default::thing(-1, 0, Type, _)  & (Type == block | Type == entity)) | retrieve::block(-1,0)) & not (default::obstacle(-1, 0))
<-		
	!action::move(w);
//	.print("Try to find a plan after moving west -- away from goal!");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX+1, TargetY, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
// I'd like to go west, but I'm giving up and going east
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetX < 0 & (not (default::thing(1, 0, Type, _)  & (Type == block | Type == entity)) | retrieve::block(1,0)) & not (default::obstacle(1, 0))
<-		
	!action::move(e);
//	.print("Try to find a plan after moving east -- away from goal!");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX-1, TargetY, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
// I'd like to go south, but I'm giving up and going north
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetY > 0 & (not (default::thing(0, -1, Type, _)  & (Type == block | Type == entity)) | retrieve::block(0,-1)) & not (default::obstacle(0, -1))
<-		
	!action::move(n);
//	.print("Try to find a plan after moving north -- away from goal!");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX, TargetY + 1, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
// I'd like to go north, but I'm giving up and going south
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) :
	LocalTargetY < 0 & (not (default::thing(0, 1, Type, _)  & (Type == block | Type == entity)) | retrieve::block(0,1)) & not (default::obstacle(0, 1))
<-		
	!action::move(s);
//	.print("Try to find a plan after moving south -- away from goal!");
	if (default::lastActionResult(success)) {
		!generate_goal(TargetX, TargetY - 1, notblock);
	} else {
		!generate_goal(TargetX, TargetY, notblock);
	}
	.
// We are screwed
+!execute_plan([], TargetX, TargetY, LocalTargetX, LocalTargetY) 
<-
//	.print("No trivial solution to the empty plan, OBSTACLES EVERYWHERE!");
	!action::skip;
	!generate_goal(TargetX, TargetY, notblock);
	.

+!execute_plan(Plan, TargetX, TargetY, LocalTargetX, LocalTargetY) :
	.my_name(Me) & default::play(Me, bully, _) & default::thing(X, Y, block, _) & bully::clearable_block(X, Y, 1)
<-
	.print("There is a block here, clear it!");
	for(default::thing(X1, Y1, block, _) & bully::clearable_block(X1, Y1, 1)){
		!action::clear(X1, Y1);
		if(default::thing(X1, Y1, block, _)){
			!action::clear(X1, Y1);
			if(default::thing(X1, Y1, block, _)){
				!action::clear(X1, Y1);
			}
		}
	}
	!execute_plan(Plan, TargetX, TargetY, LocalTargetX, LocalTargetY);
	.
+!execute_plan(Plan, TargetX, TargetY, LocalTargetX, LocalTargetY)
<-
	+localtargetx(LocalTargetX);
	+localtargety(LocalTargetY);
	for (.member(Action, Plan)){
		if (.substring("clear",Action)) {
			for(.range(I, 1, 3)){
//				.print("@@@@ Action: ", Action);
				!action::Action;
			}
		}
		else {
//			.print("@@@@ Action: ", Action);
			!action::Action;
			if (.my_name(Me) & default::play(Me,retriever,Group) & (retrieve::getting_to_position | task::doing_task) & not retrieve::block(X,Y)) {
				?localtargetx(RemoveLocalTargetX);
				?localtargety(RemoveLocalTargetY);
				-localtargetx(RemoveLocalTargetX);
				-localtargety(RemoveLocalTargetY);
				if (retrieve::getting_to_position) {
					.fail(retriever_getting_position);
				}
//				elif (task::doing_task) {
//					.fail(retriever_doing_task);
//				}
			}
			if (default::lastAction(move) & not (default::lastActionResult(success)) & default::lastActionParams([Direction|List])) {
				if ( Direction == n & planner::localtargety(LocalTargetYAux) ) {
					-+localtargety(LocalTargetYAux + 1);
				}
				elif (Direction == s & planner::localtargety(LocalTargetYAux) ) {
					-+localtargety(LocalTargetYAux - 1);
				}
				elif (Direction == w  & planner::localtargetx(LocalTargetXAux) ) {
					-+localtargetx(LocalTargetXAux + 1);
				}
				elif (Direction == e & planner::localtargetx(LocalTargetXAux) ) {
					-+localtargetx(LocalTargetXAux - 1);
				}
			}
		}
	}
	?localtargetx(FinalLocalTargetX);
	?localtargety(FinalLocalTargetY);
	-localtargetx(FinalLocalTargetX);
	-localtargety(FinalLocalTargetY);
//	.print("Next relative target X ",TargetX - FinalLocalTargetX," Y ",TargetY - FinalLocalTargetY);
	!generate_goal(TargetX - FinalLocalTargetX, TargetY - FinalLocalTargetY, notblock);
	.

-!execute_plan(Plan, TargetX, TargetY, LocalTargetX, LocalTargetY)[code(.fail(retriever_getting_position))]
	: .my_name(Me) & default::play(Me,retriever,Group) & retrieve::getting_to_position & .my_name(Me)
<-
	-retrieve::getting_to_position;
	getMyPos(MyX,MyY);
	?team::teamLeader(TeamLeader);
	addRetrieverAvailablePos(TeamLeader,TargetX+MyX,TargetY+MyY);
	removeBlock(TeamLeader, Me);
	!!retrieve::retrieve_block;
	.
//-!execute_plan(Plan, TargetX, TargetY, LocalTargetX, LocalTargetY)[code(.fail(retriever_doing_task))]
//	: .my_name(Me) & default::play(Me,retriever,Group) & task::doing_task & .my_name(Me)
//<-
//	-task::doing_task;
////	if (not task::danger2) {
////		.broadcast(achieve, task::task_failed);
////	}
////	else {
////		-task::danger2;
////	}
//	-planner::back_to_origin;
//	!!retrieve::retrieve_block;
//	.
	