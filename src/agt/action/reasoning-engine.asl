+!commit_action(Action)
	: .current_intention(intention(IntentionId,_)) & not ::access_token(IntentionId,_) & ::current_token(Token)
<-
//	.print("It's my first access ",IntentionId,", receiving a token ",Token," ",Action," ",IntentionId);
	+::access_token(IntentionId,Token);
	!commit_action(Action);
	.
+!commit_action(Action)
	: .current_intention(intention(IntentionId,_)) & ::access_token(IntentionId,IntentionToken) & ::current_token(Token) & IntentionToken < Token
<-
	
//	.print("My access was revogated ",IntentionId,", my ",IntentionToken," current ",Token,", shutting down!");
	-::access_token(IntentionId,_);
	.drop_intention;
	.
+!commit_action(Action)
	: default::actionID(Id) & action::action_sent(Id) & default::step(Step)
<-
//	.print("I've already sent an action at step ",Step,", I cannot send a new one ", Action);
	.wait({+default::actionID(_)}); 
	!commit_action(Action);
	.
+!commit_action(Action)
	: default::actionID(Id) & not action::action(Id,_) & .current_intention(intention(IntentionId,_)) & ::access_token(IntentionId,Token)
<-
	.current_intention(intention(IntentionId2,_));
//	if(IntentionId \== IntentionId2){
//		.print("WTF2");
//		.drop_intention;
//	}
	.abolish(action::action(_,_)); // removes all the possible last actions
	+action::action(Id,Action);
//	.print("Doing action ",Action, " for ",IntentionId," at step ",Id," . Waiting for step ",Id+1);
	
	!!wait_request_for_help(Id);
//	if (.substring("move",Action)) {
//		+move_sent;
//	}
	chosenAction(Id);
	.wait({+default::actionID(_)});
	!default::identification;
	.wait(not action::reasoning_about_belief(_)); 
	
	-::access_token(IntentionId,Token);
	-::action(Id,Action);
	-::action_sent(Id);
	-::committedToAction(Id);
	
	?default::lastActionResult(Result);
//	.print("Last action result ",IntentionId," was: ",Result);
	
	?default::lastAction(LastAction);
//	?default::lastActionParams(LastActionParams);
	if (default::play(Me,explorer,Group) & exploration::count(ExpCount)) {
		-exploration::count(ExpCount);
		+exploration::count(ExpCount+1);
	}

	if ( Result == unknown_action){
		.print("My action ",LastAction," was unknown to the server. This should never happen!");
	}	
	if (Result == failed_random & LastAction \== skip & LastAction \== clear){
//		.print("My action failed due to random failure, sending it again.");
		!commit_action(Action); // repeat the previous action
	}
//	elif (Result == success & LastAction == accept) {
//		+task::accepted(LastActionParams);
//	}
	elif (Result == failed_status) {
//		.print("Agent is disabled.");
		if (retrieve::block(X,Y) & default::thing(X,Y,block,_) ) {
			if (.my_name(Me) & default::play(Me,origin,Group)) {
//				.print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ AHAHAHA");
//				+task::danger;
			}
			else {
				-retrieve::block(X,Y);
			}
		}
		!commit_action(Action); 
	}
	elif (Result == failed_status & LastAction == clear & default::energy(Energy) & Energy >= 30) {
//		.print("Agent is disabled.");
		if (retrieve::block(X,Y) & default::thing(X,Y,block,_) ) {
			if (.my_name(Me) & default::play(Me,origin,Group)) {
//				+task::danger;
			}
			else {
				-retrieve::block(X,Y);
			}
		}
		!commit_action(Action); 
	}else{
//		if (default::lastAction(move)) {
//			-move_sent;
//		}
		if (Result \== success){
//			.print("Failing action ",Action," because ",Result);
			.fail(action(Action),result(Result));
//			if (Action \== recharge & Action \== continue & not .substring("assist_assemble",Action) & Result == failed){
//				.print("Failed to execute action ",Action," with actionId ",Id,". Executing it again.");
//				!commit_action(Action);
//			} else{
//				.print("Failing action ",Action," because ",Result);
//				.fail(action(Action),result(Result));
//			}
		}
	}
	.
//+!commit_action(Action)
//	: default::actionID(Id) & action::action(Id,ChosenAction) & .current_intention(intention(IntentionId,_))
//<-
//	.print("I've already picked an action ",ChosenAction," for ",Id," trying ",Action," next. I am ",IntentionId);
//	.drop_all_intentions;
//	.print("WE HAVE A BUG");
//	.drop_intention;
//	.
+!commit_action(Action)
	: default::actionID(Id) & action::action(Id,ChosenAction) 
<-
//	.print("I've already picked an action ",ChosenAction," for ",Id," trying ",Action," next");
	.wait({+default::actionID(_)}); 
	!commit_action(Action);
	.

+!update_percepts
	: ::action_sent(Id)
<-
//	.print("An action has been sent to the Server, I have to wait for the perceptions to be updated");
	.wait({-::action_sent(_)});
	. 
+!update_percepts.
@forgetParticularGoal[atomic]
+!forget_old_action(Module,Goal) 
	: not ::action_sent(_) & default::actionID(ActionId)
<- 
//	.print("I Have a desire ",Module,"::",Goal,", forgetting it");
	
	.drop_desire(Module::Goal); // we don't want to follow these plans anymore
	.drop_intention(Module::Goal);
	
	if(::action(ActionId,Action)){
		.drop_desire(::wait_request_for_help(ActionId));
		-::action(ActionId,Action);
	}
	
	+::committedToAction(ActionId);
	.	
+!forget_old_action(Module,Goal) 
<-	
	!update_percepts;
	!forget_old_action(Module,Goal) ;
	.
	
+!forget_old_action // if an intention has sent an action to the server, we have to let it drops itself. This intention may have to update some team information
	: ::action_sent(_)
<-
	!revogate_tokens;
	!!update_percepts;
	.
@forgetCommitAction[atomic]
+!forget_old_action
	: default::actionID(ActionId)
<-
	!revogate_tokens;
//	.print("Dropping all intentions that aim to send an action to the Server");
	.drop_desire(::commit_action(_));
	.drop_future_intention(::commit_action(_)); // we don't want to follow these plans anymore
	if(::action(ActionId,Action)){
		.drop_desire(::wait_request_for_help(ActionId));
		-::action(ActionId,Action);
	}
	+::committedToAction(ActionId);
//	.print("Finished dropping all intentions");
	.
+!forget_old_action
<-	
	!update_percepts;
	!forget_old_action;
	.
@revogate[atomic]
+!revogate_tokens
	: ::current_token(Token) & .current_intention(intention(ContextId,_)) 
<-
	.current_intention(intention(BodyId,_));
//	.print("Revogating older tokens...I'm context ",ContextId," body ",BodyId);
	-+::current_token(Token+1);
	-::access_token(BodyId,_);
	+::access_token(BodyId,Token+1);
	.

@helprequest[atomic]
+team::chosenActions(ActionId, Agents) // all the agents have chosen their actions
	: .all_names(AllAgents) & .length(Agents) == .length(AllAgents) & not ::committedToAction(ActionId) & not ::action_sent(ActionId)
<-
//	.print("All agents have chosen their action on ",ActionId,", dropping wait_request_for_help");
	.drop_desire(::wait_request_for_help(ActionId));
	.drop_intention(::wait_request_for_help(ActionId));
	!send_action_to_server(ActionId);
	.
+!wait_request_for_help(ActionId)
	: ::committedToAction(ActionId)
<-
//	.print("I'm strong commited to help someone else on ",ActionId);
	!send_action_to_server(ActionId);
	.abolish(::committedToAction(_));
	.	
+!wait_request_for_help(ActionId)
<-
//	.print("Waiting for help request on ",ActionId);
	.wait(1000);
	.wait(not action::reasoning_about_belief(_)); 
//	.print("Time has gone on ",ActionId);
	!send_action_to_server(ActionId);
	.	
	
@sendAction[atomic]
+!send_action_to_server(ActionId)
	: not action::action_sent(ActionId) & action::action(ActionId,Action) & default::step(Step)
<-
//	.print("Sending ",Step," ",Action);
	action(Action);
	+action::action_sent(ActionId);
	.
+!send_action_to_server(ActionId)
<-
	.print("SHOULDN'T PASS HERE ON ",ActionId);
	. // action already sent to the server, our team is slowly
