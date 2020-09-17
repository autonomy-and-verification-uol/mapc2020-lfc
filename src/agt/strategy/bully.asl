last_direction(n).

bully::clearable_block(X, Y, 1) :-
	.print("clearable_block_aux(", X, ", ", Y, ", ", 1, ")") &
	default::team(MyTeam) &
	(default::thing(X-1, Y, entity, EnemyTeam) |
	default::thing(X+1, Y, entity, EnemyTeam) |
	default::thing(X, Y-1, entity, EnemyTeam) |
	default::thing(X, Y+1, entity, EnemyTeam)).// &
	//not (MyTeam = EnemyTeam).
bully::clearable_block(X, Y, MinimumNumberOfBlocks) :-
	MinimumNumberOfBlocks > 1 &
	.print("clearable_block_aux(", X, ", ", Y, ", ", MinimumNumberOfBlocks, ")") &
	bully::neighbour(X, Y, X1, Y1) &
	.print("check if there is a block in position (", X1, ", ", Y1, ")") &
	default::thing(X1, Y1, block, _) &
	.print("a block is actually there") &
	bully::clearable_block(X1, Y1, MinimumNumberOfBlocks-1).

bully::neighbour(X, Y, X-1, Y).
bully::neighbour(X, Y, X+1, Y).
bully::neighbour(X, Y, X, Y-1).
bully::neighbour(X, Y, X, Y+1).

+!bully::messing_around :
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
			//DistanceX + DistanceY > 10 &
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
		!bully::messing_around;
	} else {
		!bully::messing_around(GoalsToMessWith);
	}
	.

+!bully::messing_around([]) :
	true
<-
	!bully::messing_around;
	.
+!bully::messing_around([goal(_, GX, GY)|GoalsToMessWith]) :
	true
<-
	.print("Moving to position: ", GX, ", ", GY);
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
	for(default::thing(X, Y, block, _) & 
		bully::clearable_block(X, Y, 1)
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
	!bully::messing_around(GoalsToMessWith);
	.