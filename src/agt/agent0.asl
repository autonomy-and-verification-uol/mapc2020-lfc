{ include("common-cartago.asl") }
{ include("common-moise.asl") }
{ include("org-obedient.asl", org) }
{ include("action/actions.asl", action) }
{ include("strategy/new-round.asl", newround) }
{ include("strategy/end-round.asl", endround) }
{ include("strategy/common-plans.asl", common) }


+!register(E)
	: .my_name(Me)
<- 
	!newround::new_round;
    .print("Registering...");
    register(E);
	.

+default::teamSizes(Sizes) 
	: common::all_names_new(AllAgents)
<-
	.print("Team sizes: ", Sizes);
	!default::memorise_sizes(1, Sizes);
	+default::next_number_of_agents(0);
	+default::next_round(1);
	!!default::create_team;
	.
+!default::memorise_sizes(_, []).
+!default::memorise_sizes(Round, [Size|Sizes])
	: true
<-
	+team_size(Round, Size);
	!default::memorise_sizes(Round+1, Sizes);
	.

@create_team[atomic]
+!default::create_team[source(Source)]
	: default::next_number_of_agents(N1) & default::next_round(Round) & default::team_size(Round, N) & common::all_names_new(AllAgents)
<- 
	everyoneReady(false);
	.print("Team size: ", N, ", source agent: ", Source);
//	for(.member(Ag, AllAgents)){
//		.print("Killing agent ", Ag, " and feeling sorry about it, but I really had to kill you..");
//		.send(Ag, achieve, default::unregister);
//		.kill_agent(Ag);
//		.wait(10);
//	}
	//.wait(10000);
	.print("Start creating all the agents..")
	for(.range(I, N1+1, N)){
		.concat("agent", I, Ag);
		//if(I > N1){
		.create_agent(Ag, "./agent.asl");
		.concat("eis_art_agent", I, EISArtifact);	
		.print("Create agent ", Ag, " with artifact ", EISArtifact);
		.send(Ag, achieve, default::focus_artifact(agentart,local,EISArtifact,default));
		.send(Ag, achieve, default::focus_artifact(agentart,local,team_artifact,team));
		.send(Ag, achieve, default::join_org(org,local,lfc,default));
		.send(Ag, achieve, default::focus_artifact(org,local,org,default));
		//}
		.concat("connectionA", I, ConnectionEntity);
		.send(Ag, achieve, default::register(ConnectionEntity));
		.wait(10);
	};
	everyoneReady(true);
	.abolish(default::next_number_of_agents(_));
	.abolish(default::next_round(_));
	+default::next_number_of_agents(N);
	+default::next_round(Round+1);
	.


