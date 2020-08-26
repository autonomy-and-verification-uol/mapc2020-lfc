evaluate_task([], AgList, CommitListTemp, CommitList) :- CommitList = CommitListTemp.
evaluate_task([req(X,Y,Type)|ReqList], AgList, CommitListTemp, CommitList) :- .member(agent(Ag, Type), AgList) & .delete(agent(Ag, Type), AgList, NewAgList) & evaluate_task(ReqList, NewAgList, [agent(Ag,Type,X,Y)|CommitListTemp], CommitList).
evaluate_task([req(X,Y,Type)|ReqList], AgList, CommitListTemp, CommitList) :- not .member(agent(Ag, Type), AgList) & CommitList = [].

sort_committed([], CommitListTemp, CommitListSort) :- CommitListSort = CommitListTemp.
sort_committed([agent(Ag,Type,X,Y)|CommitList], CommitListTemp, CommitListSort) :- X >= 0 & Y >= 0 & sort_committed(CommitList, [agent(X+Y,Ag,Type,X,Y)|CommitListTemp], CommitListSort).
sort_committed([agent(Ag,Type,X,Y)|CommitList], CommitListTemp, CommitListSort) :- X < 0 & Y >= 0 & sort_committed(CommitList, [agent(-X+Y,Ag,Type,X,Y)|CommitListTemp], CommitListSort).
sort_committed([agent(Ag,Type,X,Y)|CommitList], CommitListTemp, CommitListSort) :- X >= 0 & Y < 0 & sort_committed(CommitList, [agent(X-Y,Ag,Type,X,Y)|CommitListTemp], CommitListSort).
sort_committed([agent(Ag,Type,X,Y)|CommitList], CommitListTemp, CommitListSort) :- X < 0 & Y < 0 & sort_committed(CommitList, [agent(-X-Y,Ag,Type,X,Y)|CommitListTemp], CommitListSort).

check_pos(X,Y,NewX,NewY) :- not (default::thing(X, Y-1, Thing, _) & (Thing == entity | Thing == block)) & NewX = X & NewY = Y-1.
check_pos(X,Y,NewX,NewY) :- not (default::thing(X-1, Y, Thing, _) & (Thing == entity | Thing == block)) & NewX = X-1 & NewY = Y.
check_pos(X,Y,NewX,NewY) :- not (default::thing(X, Y+1, Thing, _) & (Thing == entity | Thing == block)) & NewX = X & NewY = Y+1.
check_pos(X,Y,NewX,NewY) :- not (default::thing(X+1, Y, Thing, _) & (Thing == entity | Thing == block)) & NewX = X+1 & NewY = Y.

where_is_my_block(X,Y,DetachPos) :- default::thing(0,1,block,_) & retrieve::block (0,1) & X = 0 & Y = 1 & DetachPos = s.
where_is_my_block(X,Y,DetachPos) :- default::thing(0,-1,block,_) & retrieve::block (0,-1) & X = 0 & Y = -1 & DetachPos = n.
where_is_my_block(X,Y,DetachPos) :- default::thing(1,0,block,_) & retrieve::block (1,0) & X = 1 & Y = 0 & DetachPos = e.
where_is_my_block(X,Y,DetachPos) :- default::thing(-1,0,block,_) & retrieve::block (-1,0) & X = -1 & Y = 0 & DetachPos = w.

get_direction(0,-1,Dir) :- Dir = n.
get_direction(0,1,Dir) :- Dir = s.
get_direction(1,0,Dir) :- Dir = e.
get_direction(-1,0,Dir) :- Dir = w.

get_block_connect(TargetX, TargetY, X, Y) :- retrieve::block(TargetX-1,TargetY) & X = TargetX-1 & Y = TargetY.
get_block_connect(TargetX, TargetY, X, Y) :- retrieve::block(TargetX+1,TargetY) & X = TargetX+1 & Y = TargetY.
get_block_connect(TargetX, TargetY, X, Y) :- retrieve::block(TargetX,TargetY-1) & X = TargetX & Y = TargetY-1.
get_block_connect(TargetX, TargetY, X, Y) :- retrieve::block(TargetX,TargetY+1) & X = TargetX & Y = TargetY+1.

//+default::task(Id, Deadline, Reward, ReqList)
//	: not task::accepted(Id) & not .desire(action::accept(_))
//<- .print("@@@@@@@@@@@ Task ",Id," Deadline ",Deadline," Reward ", Reward).

@task[atomic]
+default::task(Id, Deadline, Reward, ReqList)
	: task::origin & task::deliverer_in_position[source(_)] & not task::committed(Id2,_) & .my_name(Me) & ((default::energy(Energy) & Energy < 30) | not default::obstacle(_,_))// & .length(ReqList) <= 6
<-
	.print("@@@@@@@@@@@@@@@@@@ ", Id, "  ",Deadline);
	getAvailableAgent(AgList);
	?evaluate_task(ReqList, AgList, [], CommitList);
	.print("New task required length ",.length(ReqList));
	.print("Committed length ",.length(CommitList));
	if (.length(ReqList) == .length(CommitList)) {
		?sort_committed(CommitList,[],NewCommitList);
		.sort(NewCommitList,CommitListSort);
		+committed(Id,CommitListSort);
		.print("New commit list sorted ",CommitListSort);
		.length(CommitListSort,AgentsRequired);
		+ready_submit(AgentsRequired);
		+batch(0);
		.print("Task ",Id," with deadline ",Deadline," , reward ",Reward," and requirements ",ReqList," is eligible to be performed");
		.print("Agents committed: ",CommitList);
		.print("Agent list used: ",AgList);
		getMyPos(MyX, MyY);
		!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
		?default::play(Ag,deliverer,Group);
		-task::deliverer_in_position[source(_)];
		.send(Ag, achieve, task::accept_and_deliver(Id,UpdatedX,UpdatedY-1));
		!!perform_task_origin;
	}
	.
	
+!accept_and_deliver(Task,X,Y)
	: default::play(Ag,origin,Group)
<-
	!action::forget_old_action(default,always_skip);
	!action::accept(Task);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	NewTargetX = X - UpdatedX;
	NewTargetY = Y - UpdatedY;
	!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	.
	
@updatecommitlist[atomic]
+!update_commitlist(CommitListSort)
	: committed(Id,CommitListSortOld)
<-
	-committed(Id,CommitListSortOld);
	+committed(Id,CommitListSort);
	.print("New commit list ",CommitListSort);
	.

@update_beliefs_submit[atomic]
+!update_beliefs_submit(Flag)
<-
	-ready_submit(0);
	-batch(_);
	if (default::lastAction(submit) & not default::lastActionResult(success)) {
		.print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ TASK FAILED")
		Flag = -1;
	}
	else {
		Flag = 1;
	}
	.abolish(retrieve::block(_,_));
	.
	
+!deliver(Task)[source(Origin)]
	: true
<-
	!action::forget_old_action(default,always_skip);
	!try_to_move_deliverer;
	!action::attach(s);
	!action::submit(Task);
	.send(Origin, achieve, task::task_completed(Task));
	.print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Submitted task ",Task);
	!!default::always_skip;
	.
	
+!try_to_move_deliverer
<-
	!action::move(s);
	if (not default::lastActionResult(success)) {
		!action::move(s);
	}
	.
	
+!task_completed(Task)
	: committed(Task,CommitListSort)
<-
	.print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  Submitted task ",Task);
	-committed(Task,CommitListSort);
	.

+!perform_task_origin_next
	: committed(Id,CommitListSort) & ready_submit(0) & task::deliverer_in_position[source(_)]
<-
	-task::deliverer_in_position[source(_)];
	!action::detach(s);
	!try_to_move;
	?default::play(Ag,deliverer,Group);
	.send(Ag, achieve, task::deliver(Id));
//	!action::submit(Id);
//	!update_beliefs_submit(Flag);
//	if (Flag == -1) {
//		.broadcast(achieve, task::task_failed);
//		!clear_all;
//	}
	
//	-committed(Id,CommitListSort);
	!default::always_skip;
	.
	
+!perform_task_origin_next
	: committed(Id,CommitListSort) & ready_submit(0) & not task::deliverer_in_position[source(_)]
<-
	!action::skip;
	!perform_task_origin_next;
	.
	
+!try_to_move
	: not exploration::check_obstacle_special(e)
<-
	!action::move(e);
	.
+!try_to_move
	: not exploration::check_obstacle_special(w)
<-
	!action::move(w);
	.
+!try_to_move
	: true
<-
	!action::skip;
	!try_to_move;
	.
	
+!clear_all
	: default::energy(Energy) & Energy >= 30 & default::thing(X,Y,block,_) & Y > 0
<-
	if (X == 0 & Y == 1) {
		FinalX = X;
		FinalY = Y+1;
	}
	elif (X == 0 & Y == -1) {
		FinalX = X;
		FinalY = Y-1;
	}
	elif (X == 1 & Y == 0) {
		FinalX = X+1;
		FinalY = Y;
	}
	elif (X == -1 & Y == 0) {
		FinalX = X-1;
		FinalY = Y;
	}
	else {
		FinalX = X;
		FinalY = Y;
	}
	for(.range(I, 1, 3)){
		!action::clear(FinalX,FinalY);
	}
	!clear_all
	.
+!clear_all.

+!task_failed
	: doing_task & retrieve::block(X,Y) & direction_block(Dir,X,Y)
<-
//	+danger2;
	!action::detach(Dir); // easy fix for the second attached block (I do not know)
	// we do not care if this has failed or not, the origin should clear the block
	-retrieve::block(X,Y);
	.
+!task_failed
	: doing_task
<-
	-doing_task;
	-planner::back_to_origin;
	!!retrieve::retrieve_block;
	.
+!task_failed
	: .my_name(Me) & default::play(Me,origin,Group) & committed(Id,CommitListSort)
<-
	.print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ ===============");
	+no_skip;
	!clear_all;
	-ready_submit(_);
	-batch(_);
	.abolish(retrieve::block(_,_));
	-committed(Id,CommitListSort);
	-helping_connect;
	-no_skip;
	.
+!task_failed.

+!go_back_to_position
<-
	getMyPos(MyX, MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	getRetrieverAvailablePos(TargetXGlobal, TargetYGlobal);
	TargetX = TargetXGlobal - UpdatedX;
	TargetY = TargetYGlobal - UpdatedY;
	.print("Chosen Global Goal position: ", TargetXGlobal, TargetYGlobal);
	.print("Agent position: ", UpdatedX, UpdatedY);
	.print("Chosen Relative Goal position: ", TargetX, TargetY);
	+getting_to_position;
	!planner::generate_goal(TargetX, TargetY, notblock);
	.

@next_job_task[atomic]
+!perform_task_origin_next
	: committed(Id,CommitListSort) & not .empty(CommitListSort) & batch(0) //& helper(HelperAg)
<-
//	.wait(not action::move_sent);
	getMyPos(MyX,MyY);
	.nth(0,CommitListSort,agent(Sum,_,_,_,_));
	for (.member(agent(Sum,Ag,TypeAg,X,Y),CommitListSort)) {
		!map::calculate_updated_pos(MyX,MyY,0,0,TestX,TestY);
		!map::calculate_updated_pos(MyX,MyY,X,Y,UpdatedX,UpdatedY);
		if (task::no_block) {
			.print("Global position ",TestX,", ",TestY);
			.print("Global position for ",Ag," to go ",UpdatedX,", ",UpdatedY);
			.send(Ag,achieve,task::perform_task(UpdatedX,UpdatedY,noblock));
		}
		else {
			.send(Ag,achieve,task::perform_task(UpdatedX,UpdatedY));
		}
		?batch(Batch);
		-+batch(Batch+1);
		?committed(Id,CommitListSortAux);
		.delete(agent(Sum,Ag,TypeAg,X,Y),CommitListSortAux,CommitListSortNew);
		!update_commitlist(CommitListSortNew);
	}
	!!default::always_skip;
	.
	
+!perform_task_origin_next <- !!default::always_skip.

+!perform_task_origin
	: true
<-
	!action::forget_old_action(default,always_skip);
	+no_block;
	!perform_task_origin_next;
	.
	
@updatetaskbeliefsattach[atomic]
+!update_task_beliefs_attach
	: batch(Batch) & ready_submit(AgentsRequired)
<-
	-+ready_submit(AgentsRequired-1);
	-+batch(Batch-1);
	-no_block;
	.
	
@updatetaskbeliefsconnect[atomic]
+!update_task_beliefs_connect(X,Y)
	: batch(Batch) & ready_submit(AgentsRequired)
<-
	-+ready_submit(AgentsRequired-1);
	-+batch(Batch-1);
	-helping_connect;
	+retrieve::block(X,Y);
	.

+!help_attach(ConX,ConY)[source(Help)]
	: no_block
<-
//	.wait(not action::move_sent);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	!action::forget_old_action(default,always_skip);
	?get_direction(ConX-UpdatedX, ConY-UpdatedY, Dir)
	while (not (default::lastAction(attach) & default::lastActionResult(success))) {
		!action::attach(Dir);
	}
	.send(Help, tell, task::synch_complete);
	!update_task_beliefs_attach;
	!perform_task_origin_next;
	.
	
+!help_connect(ConX,ConY)[source(Help)]
	:  not helping_connect
<-
	+helping_connect;
//	.wait(not action::move_sent);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	.print("My pos X ",UpdatedX," Y ",UpdatedY);
	.print("Help local block X ",ConX-UpdatedX," Y ",ConY-UpdatedY);
	?get_block_connect(ConX-UpdatedX, ConY-UpdatedY, X, Y);
	!action::forget_old_action(default,always_skip);
	!action::connect(Help,X,Y);
	while (not (default::lastAction(connect) & default::lastActionResult(success))) {
		!action::connect(Help,X,Y);
	}
	.send(Help, tell, task::synch_complete);
	!update_task_beliefs_connect(ConX-UpdatedX,ConY-UpdatedY);
	!perform_task_origin_next;
	.
	
+!help_connect(ConX,ConY)[source(Help)] <- .wait({+default::actionID(_)}); !help_connect(ConX,ConY)[source(Help)].
	
+!perform_task(X,Y,noblock)[source(Origin)]
	: .my_name(Me) & retrieve::block(BBX, BBY) & default::thing(BBX, BBY, block, Type)
<-
	+doing_task;
	!action::forget_old_action(default,always_skip);
	.print("@@@@ Received order for new task, origin does not have a block");
	removeAvailableAgent(Me);
	removeBlock(Me);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	addRetrieverAvailablePos(UpdatedX,UpdatedY);
	.print("MyX ",UpdatedX);
	.print("MyY ",UpdatedY);
	.print("X ",X);
	.print("Y ",Y);
	?map::size(x, SizeX);
	?map::size(y, SizeY);
	Aux1X = X - UpdatedX;
	Aux1Y = Y - UpdatedY;
	if (Aux1X < 0) {
		Aux2X = Aux1X + SizeX;
	}
	elif (Aux1X > 0) {
		Aux2X = Aux1X - SizeX;
	}
	else {
		Aux2X = Aux1X;
	}
	if (Aux1Y < 0) {
		Aux2Y = Aux1Y + SizeY;
	}
	elif (Aux1Y > 0) {
		Aux2Y = Aux1Y - SizeY;
	}
	else {
		Aux2Y = Aux1Y;
	}
	if (math.abs(Aux1X) < math.abs(Aux2X)) {
		NewTargetX = Aux1X;
	}
	else {
		NewTargetX = Aux2X;
	}
	if (math.abs(Aux1Y) < math.abs(Aux2Y)) {
		NewTargetY = Aux1Y;
	}
	else {
		NewTargetY = Aux2Y;
	}
	.print("NewTargetX ",NewTargetX);
	.print("NewTargetY ",NewTargetY);
	!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	getMyPos(MyXNew,MyYNew);
//	if (not danger2) {
		?retrieve::block(BX,BY);
		!map::calculate_updated_pos(MyXNew,MyYNew,BX,BY,UpdatedXNew,UpdatedYNew);
		.send(Origin, achieve, task::help_attach(UpdatedXNew,UpdatedYNew));
//		if (not danger2) {
			?get_direction(BX,BY,DetachPos);
			!action::detach(DetachPos);
			.wait(task::synch_complete[source(Origin)]);
			-task::synch_complete[source(Origin)];
//		}
//		else {
//			-planner::back_to_origin;
//			-danger2;
//		}
//	}
//	else {
//		-planner::back_to_origin;
//		-danger2;
//	}
	-doing_task;
	!!retrieve::retrieve_block;
	.
	
+!perform_task(X,Y)[source(Origin)]
	: .my_name(Me) & retrieve::block(BBX, BBY) & default::thing(BBX, BBY, block, Type)
<-
	+doing_task;
	!action::forget_old_action(default,always_skip);
	.print("@@@@ Received order for new task, origin has a block");
	removeAvailableAgent(Me);
	removeBlock(Me);
	getMyPos(MyX,MyY);
	!map::calculate_updated_pos(MyX,MyY,0,0,UpdatedX,UpdatedY);
	addRetrieverAvailablePos(UpdatedX,UpdatedY);
	.print("MyX ",UpdatedX);
	.print("MyY ",UpdatedY);
	.print("X ",X);
	.print("Y ",Y);
	?map::size(x, SizeX);
	?map::size(y, SizeY);
	Aux1X = X - UpdatedX;
	Aux1Y = Y - UpdatedY;
	if (Aux1X < 0) {
		Aux2X = Aux1X + SizeX;
	}
	elif (Aux1X > 0) {
		Aux2X = Aux1X - SizeX;
	}
	else {
		Aux2X = Aux1X;
	}
	if (Aux1Y < 0) {
		Aux2Y = Aux1Y + SizeY;
	}
	elif (Aux1Y > 0) {
		Aux2Y = Aux1Y - SizeY;
	}
	else {
		Aux2Y = Aux1Y;
	}
	if (math.abs(Aux1X) < math.abs(Aux2X)) {
		NewTargetX = Aux1X;
	}
	else {
		NewTargetX = Aux2X;
	}
	if (math.abs(Aux1Y) < math.abs(Aux2Y)) {
		NewTargetY = Aux1Y;
	}
	else {
		NewTargetY = Aux2Y;
	}
	.print("NewTargetX ",NewTargetX);
	.print("NewTargetY ",NewTargetY);
	!planner::generate_goal(NewTargetX, NewTargetY, notblock);
	getMyPos(MyXNew,MyYNew);
//	if (not danger2) {
		?retrieve::block(BX,BY);
		!map::calculate_updated_pos(MyXNew,MyYNew,BX,BY,UpdatedXNew,UpdatedYNew);
		.send(Origin, achieve, task::help_connect(UpdatedXNew,UpdatedYNew));
		while (not (default::lastAction(connect) & default::lastActionResult(success))) {
			!action::connect(Origin,BX,BY);
		}
		.wait(task::synch_complete[source(Origin)]);
		-task::synch_complete[source(Origin)];
//		if (not danger2) {
			?get_direction(BX,BY,DetachPos);
			!action::detach(DetachPos);
//		}
//		else {
//			-planner::back_to_origin;
//			-danger2;
//		}
//	}
//	else {
//		-planner::back_to_origin;
//		-danger2;
//	}
	-doing_task;
	!!retrieve::retrieve_block;
	.
