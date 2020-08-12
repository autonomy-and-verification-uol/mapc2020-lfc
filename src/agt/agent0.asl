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

+default::currentTeamSize(N) : default::current_number_of_agents(N) <- true.
+default::currentTeamSize(N)
	: .my_name(agent0) & common::all_names_new(AllAgents)
<- 
	.print("Team size: ", N);
	for(.member(Ag, AllAgents)){
		.kill_agent(Ag);
	}
	for(.range(I, 1, N)){
		.concat("agent", I, Ag);
		.create_agent(Ag, "./agent.asl");
		.concat("eis_art_agent", I, EISArtifact);	
		.print("Create agent ", Ag, " with artifact ", EISArtifact);
		.send(Ag, achieve, default::focus_artifact(agentart,local,EISArtifact,default));
		.send(Ag, achieve, default::focus_artifact(agentart,local,team_artifact,team));
		.send(Ag, achieve, default::join_org(org,local,lfc,default));
		.send(Ag, achieve, default::focus_artifact(org,local,org,default));
		.concat("connectionA", I, ConnectionEntity);
		.send(Ag, achieve, default::register(ConnectionEntity));
		.wait(10);
	};
	+default::current_number_of_agents(N);
	.


