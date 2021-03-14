package env;

import java.awt.Point;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.List;
import java.util.ArrayList;
import java.util.logging.Logger;


import cartago.Artifact;
import cartago.OPERATION;
import cartago.OpFeedbackParam;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;
import jason.asSyntax.NumberTerm;
import jason.asSyntax.NumberTermImpl;
import jason.util.Pair;
import jason.asSyntax.Atom;


public class TeamArtifact extends Artifact {

	private static Logger logger = Logger.getLogger(TeamArtifact.class.getName());

	private static Map<String, String>  agentNames 	 	= new HashMap<String, String>();
	
	private static Map<Integer, Set<String>> actionsByStep   = new HashMap<Integer, Set<String>>();
	
	private Map<String, Set<Point>>  map1 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map2 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map3 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map4 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map5 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map6 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map7 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map8 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map9 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map10 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map11 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map12 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map13 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map14 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map15 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map16 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map17 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map18 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map19 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map20 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map21 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map22 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map23 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map24 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map25 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map26 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map27 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map28 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map29 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map30 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map31 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map32 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map33 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map34 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map35 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map36 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map37 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map38 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map39 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map40 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map41 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map42 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map43 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map44 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map45 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map46 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map47 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map48 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map49 	 	= new HashMap<String, Set<Point>>();
	private Map<String, Set<Point>>  map50 	 	= new HashMap<String, Set<Point>>();
	
	private Map<String, Map<String, Set<Point>>> agentmaps = new HashMap<String, Map<String, Set<Point>>>();
	
	private int maxPlanners = 50;
	private int planners;
	
//	private int retrievers;
	//private int bullys;
	
	private String firstToStop;
	
	private String cartographerY1;
	private String cartographerY2;
	
	private String cartographerX1;
	private String cartographerX2;
	
	private int sizeX;
	private int sizeY;
	
	private int maxTeams;
	
	private int activeTeam;
	
	private int teamsComplete;
	
	private String teamLeader;
	
//	private String goalAgent;
//	private Integer targetTaskX;
//	private Integer targetTaskY;
//	private Integer targetGoalX;
//	private Integer targetGoalY;
//	private Integer targetTaskX2;
//	private Integer targetTaskY2;
//	private Integer targetGoalX2;
//	private Integer targetGoalY2;
	private List<Point> retrieversAvailablePositions = new ArrayList<>();
//	private List<Point> uselessAvailablePositions = new ArrayList<>();
	
	private Map<String, Team>  teams 	 	= new HashMap<String, Team>();
	
	void init(){
		logger.info("Team Artifact has been created!");
		agentmaps.put("agent1",map1);
		agentmaps.put("agent2",map2);
		agentmaps.put("agent3",map3);
		agentmaps.put("agent4",map4);
		agentmaps.put("agent5",map5);
		agentmaps.put("agent6",map6);
		agentmaps.put("agent7",map7);
		agentmaps.put("agent8",map8);
		agentmaps.put("agent9",map9);
		agentmaps.put("agent10",map10);
		agentmaps.put("agent11",map11);
		agentmaps.put("agent12",map12);
		agentmaps.put("agent13",map13);
		agentmaps.put("agent14",map14);
		agentmaps.put("agent15",map15);
		agentmaps.put("agent16",map16);
		agentmaps.put("agent17",map17);
		agentmaps.put("agent18",map18);
		agentmaps.put("agent19",map19);
		agentmaps.put("agent20",map20);
		agentmaps.put("agent21",map21);
		agentmaps.put("agent22",map22);
		agentmaps.put("agent23",map23);
		agentmaps.put("agent24",map24);
		agentmaps.put("agent25",map25);
		agentmaps.put("agent26",map26);
		agentmaps.put("agent27",map27);
		agentmaps.put("agent28",map28);
		agentmaps.put("agent29",map29);
		agentmaps.put("agent30",map30);
		agentmaps.put("agent31",map31);
		agentmaps.put("agent32",map32);
		agentmaps.put("agent33",map33);
		agentmaps.put("agent34",map34);
		agentmaps.put("agent35",map35);
		agentmaps.put("agent36",map36);
		agentmaps.put("agent37",map37);
		agentmaps.put("agent38",map38);
		agentmaps.put("agent39",map39);
		agentmaps.put("agent40",map40);
		agentmaps.put("agent41",map41);
		agentmaps.put("agent42",map42);
		agentmaps.put("agent43",map43);
		agentmaps.put("agent44",map44);
		agentmaps.put("agent45",map45);
		agentmaps.put("agent46",map46);
		agentmaps.put("agent47",map47);
		agentmaps.put("agent48",map48);
		agentmaps.put("agent49",map49);
		agentmaps.put("agent50",map50);
		planners = 0;
		firstToStop = null;
		cartographerY1 = null;
		cartographerY2 = null;
		cartographerX1 = null;
		cartographerX2 = null;
		teamLeader = null;
//		goalAgent = null;
//		targetTaskX = null;
//		targetTaskY = null;
//		targetGoalX = null;
//		targetGoalY = null;
//		targetTaskX2 = null;
//		targetTaskY2 = null;
//		targetGoalX2 = null;
//		targetGoalY2 = null;
//		deliverer2 = -1;
		sizeX = 0;
		sizeY = 0;
//		retrievers = 10;
		teamsComplete = 0;
		activeTeam = 15;
		//bullys = 1;
	}
	
	@OPERATION
	void firstToStop(String agent, OpFeedbackParam<Boolean> flag){
		if(this.firstToStop != null) {
			flag.set(false);
		}
		else {
			this.firstToStop = agent;
			this.teamLeader = agent;
			flag.set(true);
			logger.info("!!!! First to stop "+firstToStop);
		}
	}
	
	@OPERATION
	void addCartographer(String agent1, String agent2, OpFeedbackParam<Integer> flag){
		if(this.cartographerY1 == null) {
			flag.set(1);
			this.cartographerY1 = agent1;
			this.cartographerY2 = agent2;
			logger.info("!!!! Cartographers Y "+cartographerY1+" and "+cartographerY2);
		}
		else if (this.cartographerX1 == null && this.cartographerY1 != agent1 && this.cartographerY1 != agent2 && this.cartographerY2 != agent1 && this.cartographerY2 != agent2) {
			flag.set(2);
			this.cartographerX1 = agent1;
			this.cartographerX2 = agent2;
			logger.info("!!!! Cartographers X "+cartographerX1+" and "+cartographerX2);
		}
		else {
			flag.set(0);
		}
		
	}
	
	@OPERATION
	void callPlanner(OpFeedbackParam<Boolean> flag){
//		logger.info("Calling planner with planners "+this.planners);
		if(this.planners+1 <= this.maxPlanners) {
			this.planners++;
			flag.set(true);
		}
		else {
			flag.set(false);
		}
	}
	
	@OPERATION
	void plannerDone(){
		this.planners--;
//		logger.info("Planner done, decreasing planners "+this.planners);
	}
	
	
	@OPERATION
	void joinStopGroup(OpFeedbackParam<String> flag, OpFeedbackParam<String> teamLead){
		if (this.teamsComplete != this.maxTeams) {
	//		if (this.goalAgent2 == null) {
	//			flag.set("origin2");
	//			this.goalAgent2 = this.getCurrentOpAgentId().getAgentName();
	//		}
			if (this.activeTeam == 15) {
				logger.info("NEW DELIVERER "+getCurrentOpAgentId().getAgentName());
				this.activeTeam = activeTeam - 2;
				flag.set("deliverer");
				teamLead.set(this.teamLeader);
			}
			else if (this.activeTeam > 1) {
				this.activeTeam--;
				flag.set("retriever");
				teamLead.set(this.teamLeader);
			}
			else if (this.activeTeam == 1) {
				this.activeTeam--;
				this.teamsComplete++;
				flag.set("bully");
				teamLead.set(this.teamLeader);
			}
			else {
				this.activeTeam = 15;
				this.teamLeader = getCurrentOpAgentId().getAgentName();
				flag.set("origin");
				logger.info("NEW TEAM LEADER "+this.teamLeader);
				teamLead.set(this.teamLeader);
			}
//		else {
//			flag.set("useless");
//		}
		}
		else {
			flag.set("bully");
			teamLead.set(this.teamLeader);
		}
	}
	
	
	@OPERATION
	void getTargetGoal(String name, OpFeedbackParam<Integer> x, OpFeedbackParam<Integer> y){
		x.set(teams.get(name).getTargetGoalX());
		y.set(teams.get(name).getTargetGoalY());
	}
	
	@OPERATION
	void getTargetGoals(OpFeedbackParam<Literal[]> goals){
		List<Literal> targetGoals = new ArrayList<Literal>();
		for(Entry<String, Team> team : teams.entrySet()) {
			Literal literal = ASSyntax.createLiteral("goal");
			NumberTerm x = new NumberTermImpl(team.getValue().targetGoalX);
			NumberTerm y = new NumberTermImpl(team.getValue().targetGoalY);
			literal.addTerm(x);
			literal.addTerm(y);
			targetGoals.add(literal);
		}
		Literal[] arrayGoals = targetGoals.toArray(new Literal[targetGoals.size()]);
		goals.set(arrayGoals);
	}
	
//	@OPERATION
//	void getTargetGoal2(OpFeedbackParam<String> name, OpFeedbackParam<Integer> x, OpFeedbackParam<Integer> y){
//		name.set(goalAgent2);
//		x.set(targetGoalX2);
//		y.set(targetGoalY2);
//	}
	
	@OPERATION
	void getTargetTaskboard(String name, OpFeedbackParam<Integer> x, OpFeedbackParam<Integer> y){
		x.set(teams.get(name).getTargetTaskX());
		y.set(teams.get(name).getTargetTaskY());
	}
	
//	@OPERATION
//	void getTargetTaskboard2(OpFeedbackParam<Integer> x, OpFeedbackParam<Integer> y){
//		x.set(targetTaskX2);
//		y.set(targetTaskY2);
//	}
	
	@OPERATION
	void setTargets(String name, int taskx, int tasky, int goalx, int goaly){
		this.retrieversAvailablePositions.clear();
//		this.uselessAvailablePositions.clear();
//		for (int i = 0; i < 50; i++) {
//			Point p = new Point(goalx-25+i, goaly-10);
//			this.uselessAvailablePositions.add(p);
//		}
		for (int i = goaly - 1; i <= goaly + 5; i = i + 3) { // add west line of the rectangle
			Point p = new Point(goalx-9, i);
			this.retrieversAvailablePositions.add(p);
//			Point p2 = new Point(goalx-11, i);
//			this.retrieversAvailablePositions.add(p2);
		}
		for (int i = goaly - 1; i <= goaly + 5; i = i + 3) { // add east line of the rectangle
			Point p = new Point(goalx+9, i);
			this.retrieversAvailablePositions.add(p);
//			Point p2 = new Point(goalx+11, i);
//			this.retrieversAvailablePositions.add(p2);
		}
		for (int i = goalx - 9; i <= goalx + 9; i = i + 3) { // add north line of the rectangle
			Point p = new Point(i, goaly-4);
			this.retrieversAvailablePositions.add(p);
//			Point p2 = new Point(i, goaly-6);
//			this.retrieversAvailablePositions.add(p2);
		}
		for (int i = goalx - 9; i <= goalx + 9; i = i + 3) { // add south line of the rectangle
			Point p = new Point(i, goaly+8);
			this.retrieversAvailablePositions.add(p);
//			Point p2 = new Point(i, goaly+10);
//			this.retrieversAvailablePositions.add(p2);
		}
//		logger.info("Size of retriever positions: "+this.retrieversAvailablePositions.toArray().length);
//		for(Point p: this.retrieversAvailablePositions) {
//			logger.info("@@@@ position("+p.x+","+p.y+")");
//		}
		Team team = new Team(taskx, tasky, goalx, goaly, retrieversAvailablePositions);
		teams.put(name, team);
		this.retrieversAvailablePositions.clear();
	}
	
//	@OPERATION
//	void setTargets(String name, int taskx, int tasky, int goalx, int goaly, int taskx2, int tasky2, int goalx2, int goaly2){
//		this.goalAgent = name;
//		this.targetTaskX = taskx;
//		this.targetTaskY = tasky;
//		this.targetGoalX = goalx;
//		this.targetGoalY = goaly;
//		this.targetTaskX2 = taskx2;
//		this.targetTaskY2 = tasky2;
//		this.targetGoalX2 = goalx2;
//		this.targetGoalY2 = goaly2;
//		this.retrieversAvailablePositions.clear();
//		for (int i = goaly - 1; i <= goaly + 5; i = i + 3) { // add west line of the rectangle
//			Point p = new Point(goalx-9, i);
//			this.retrieversAvailablePositions.add(p);
////			Point p2 = new Point(goalx-11, i);
////			this.retrieversAvailablePositions.add(p2);
//		}
//		for (int i = goaly - 1; i <= goaly + 5; i = i + 3) { // add east line of the rectangle
//			Point p = new Point(goalx+9, i);
//			this.retrieversAvailablePositions.add(p);
////			Point p2 = new Point(goalx+11, i);
////			this.retrieversAvailablePositions.add(p2);
//		}
//		for (int i = goalx - 9; i <= goalx + 9; i = i + 3) { // add north line of the rectangle
//			Point p = new Point(i, goaly-4);
//			this.retrieversAvailablePositions.add(p);
////			Point p2 = new Point(i, goaly-6);
////			this.retrieversAvailablePositions.add(p2);
//		}
//		for (int i = goalx - 9; i <= goalx + 9; i = i + 3) { // add south line of the rectangle
//			Point p = new Point(i, goaly+8);
//			this.retrieversAvailablePositions.add(p);
////			Point p2 = new Point(i, goaly+10);
////			this.retrieversAvailablePositions.add(p2);
//		}
////		logger.info("Size of retriever positions: "+this.retrieversAvailablePositions.toArray().length);
////		for(Point p: this.retrieversAvailablePositions) {
////			logger.info("@@@@ position("+p.x+","+p.y+")");
////		}
//	}
	
	
	@OPERATION
	void updateTargets(String name, int x, int y) {
		this.retrieversAvailablePositions.clear();
		this.retrieversAvailablePositions.addAll(teams.get(name).getRetrieversAvailablePositions());
		if (sizeX != 0 && sizeY != 0) {
			List<Point> retaux = new ArrayList<>();
			if (teams.get(name).getTargetTaskX() + x < 0) {
				teams.get(name).setTargetTaskX(((teams.get(name).getTargetTaskX() + x) % sizeX) + sizeX);
			} else {
				teams.get(name).setTargetTaskX((teams.get(name).getTargetGoalX() + x) % sizeX);
			}
			if (teams.get(name).getTargetTaskY() + y < 0) {
				teams.get(name).setTargetTaskY(((teams.get(name).getTargetTaskY() + y) % sizeY) + sizeY);
			} else {
				teams.get(name).setTargetTaskY((teams.get(name).getTargetTaskY() + y) % sizeY);
			}
			if (teams.get(name).getTargetGoalX() + x < 0) {
				teams.get(name).setTargetGoalX(((teams.get(name).getTargetGoalX() + x) % sizeX) + sizeX);
			} else {
				teams.get(name).setTargetGoalX((teams.get(name).getTargetGoalX() + x) % sizeX);
			}
			if (teams.get(name).getTargetGoalY() + y < 0) {
				teams.get(name).setTargetGoalY(((teams.get(name).getTargetGoalY() + y) % sizeY) + sizeY);
			} else {
				teams.get(name).setTargetGoalY((teams.get(name).getTargetGoalY() + y) % sizeY);
			}
			
			for(Point p: this.retrieversAvailablePositions) {
				Point pnew = new Point(0, 0);
				if (p.x + x < 0) {
					pnew.x = ((p.x + x) % sizeX) + sizeX;
				} else {
					pnew.x = (p.x + x) % sizeX;
				}
				if (p.y + y < 0) {
					pnew.y = ((p.y + y) % sizeY) + sizeY;
				} else {
					pnew.y = (p.y + y) % sizeY;
				}
				retaux.add(pnew);
			}
			retrieversAvailablePositions.clear();
			retrieversAvailablePositions.addAll(retaux);
//			for(Point p: this.uselessAvailablePositions) {
//				Point pnew = new Point(0, 0);
//				if (p.x + x < 0) {
//					pnew.x = ((p.x + x) % sizeX) + sizeX;
//				} else {
//					pnew.x = (p.x + x) % sizeX;
//				}
//				if (p.y + y < 0) {
//					pnew.y = ((p.y + y) % sizeY) + sizeY;
//				} else {
//					pnew.y = (p.y + y) % sizeY;
//				}
//				retaux.add(pnew);
//			}
//			uselessAvailablePositions.clear();
//			uselessAvailablePositions.addAll(retaux);
		}
		else if (sizeX != 0) {
			List<Point> retaux = new ArrayList<>();
			if (teams.get(name).getTargetTaskX() + x < 0) {
				teams.get(name).setTargetTaskX(((teams.get(name).getTargetTaskX() + x) % sizeX) + sizeX);
			} else {
				teams.get(name).setTargetTaskX((teams.get(name).getTargetTaskX() + x) % sizeX);
			}
			teams.get(name).setTargetTaskY(teams.get(name).getTargetTaskY() + y);
			if (teams.get(name).getTargetGoalX() + x < 0) {
				teams.get(name).setTargetGoalX(((teams.get(name).getTargetGoalX() + x) % sizeX) + sizeX);
			} else {
				teams.get(name).setTargetGoalX((teams.get(name).getTargetGoalX() + x) % sizeX);
			}
			teams.get(name).setTargetGoalY(teams.get(name).getTargetGoalY() + y);
			for(Point p: this.retrieversAvailablePositions) {
				Point pnew = new Point(0, 0);
				if (p.x + x < 0) {
					pnew.x = ((p.x + x) % sizeX) + sizeX;
				} else {
					pnew.x = (p.x + x) % sizeX;
				}
				pnew.y += y;
				retaux.add(pnew);
			}
			retrieversAvailablePositions.clear();
			retrieversAvailablePositions.addAll(retaux);
//			for(Point p: this.uselessAvailablePositions) {
//				Point pnew = new Point(0, 0);
//				if (p.x + x < 0) {
//					pnew.x = ((p.x + x) % sizeX) + sizeX;
//				} else {
//					pnew.x = (p.x + x) % sizeX;
//				}
//				pnew.y += y;
//				retaux.add(pnew);
//			}
//			uselessAvailablePositions.clear();
//			uselessAvailablePositions.addAll(retaux);
		}
		else if (sizeY != 0) {
			List<Point> retaux = new ArrayList<>();
			teams.get(name).setTargetTaskX(teams.get(name).getTargetTaskX() + x);
			if (teams.get(name).getTargetTaskY() + y < 0) {
				teams.get(name).setTargetTaskY(((teams.get(name).getTargetTaskY() + y) % sizeY) + sizeY);
			} else {
				teams.get(name).setTargetTaskY((teams.get(name).getTargetTaskY() + y) % sizeY);
			}
			teams.get(name).setTargetGoalX(teams.get(name).getTargetGoalX() + x);
			if (teams.get(name).getTargetGoalY() + y < 0) {
				teams.get(name).setTargetGoalY(((teams.get(name).getTargetGoalY() + y) % sizeY) + sizeY);
			} else {
				teams.get(name).setTargetGoalY((teams.get(name).getTargetGoalY() + y) % sizeY);
			}
			for(Point p: this.retrieversAvailablePositions) {
				Point pnew = new Point(0, 0);
				pnew.x += x;
				if (p.y + y < 0) {
					pnew.y = ((p.y + y) % sizeY) + sizeY;
				} else {
					pnew.y = (p.y + y) % sizeY;
				}
				retaux.add(pnew);
			}
			retrieversAvailablePositions.clear();
			retrieversAvailablePositions.addAll(retaux);
//			for(Point p: this.uselessAvailablePositions) {
//				Point pnew = new Point(0, 0);
//				pnew.x += x;
//				if (p.y + y < 0) {
//					pnew.y = ((p.y + y) % sizeY) + sizeY;
//				} else {
//					pnew.y = (p.y + y) % sizeY;
//				}
//				retaux.add(pnew);
//			}
//			uselessAvailablePositions.clear();
//			uselessAvailablePositions.addAll(retaux);
		} else {
			teams.get(name).setTargetTaskX(teams.get(name).getTargetTaskX() + x);
			teams.get(name).setTargetTaskY(teams.get(name).getTargetTaskY() + y);
			teams.get(name).setTargetGoalX(teams.get(name).getTargetGoalX() + x);
			teams.get(name).setTargetGoalY(teams.get(name).getTargetGoalY() + y);
			for(Point p: this.retrieversAvailablePositions) {
				p.x += x;
				p.y += y;
			}
//			for(Point p: this.uselessAvailablePositions) {
//				p.x += x;
//				p.y += y;
//			}
		}
		teams.get(name).setRetrieversAvailablePositions(this.retrieversAvailablePositions);
		this.retrieversAvailablePositions.clear();
	}
	
	
//	@OPERATION
//	void initRetrieverAvailablePos(String name) {
////		logger.info("initRetrieversAvailablePos");
//		if(this.targetGoalX == null | this.targetGoalY == null) return;
//		this.retrieversAvailablePositions.clear();
//		for(String key : agentmaps.get(name).keySet()) {
//			if(key.startsWith("goal_")) {
//				for(Point pp : agentmaps.get(name).get(key)) {
//					if(targetGoalX == pp.x && targetGoalY == pp.y) {
////						logger.info("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
////						logger.info(((OriginPoint) pp).retrievers+"");
//						for(Point retriever : ((OriginPoint) pp).retrievers) {
////							logger.info("[" + name + "]" + "( " + retriever.x + ", " + retriever.y + " ) retriever added");
//							this.retrieversAvailablePositions.add(retriever);
//						}
//						return;
//					}
//				}
//			}
//		}
//	}
	
	@OPERATION
	void getRetrieverAvailablePos(String name, int myX, int myY, OpFeedbackParam<Integer> x, OpFeedbackParam<Integer> y) {
		this.retrieversAvailablePositions.clear();
		this.retrieversAvailablePositions.addAll(teams.get(name).getRetrieversAvailablePositions());
		int toRemove = -1;
		double dist = Double.MAX_VALUE;
		for(int i = 0; i < this.retrieversAvailablePositions.size(); i++) {
			double d = Math.abs(myX - this.retrieversAvailablePositions.get(i).x) + Math.abs(myY - this.retrieversAvailablePositions.get(i).y);
			if(d < dist) {
				toRemove = i;
				dist = d;
			}
		}
		if(toRemove != -1) {
			x.set(this.retrieversAvailablePositions.get(toRemove).x);
			y.set(this.retrieversAvailablePositions.get(toRemove).y);
			this.retrieversAvailablePositions.remove(toRemove);
		}
		teams.get(name).setRetrieversAvailablePositions(this.retrieversAvailablePositions);
		this.retrieversAvailablePositions.clear();
	}
	
//	@OPERATION
//	void getUselessAvailablePos(int myX, int myY, OpFeedbackParam<Integer> x, OpFeedbackParam<Integer> y) {
//		int toRemove = -1;
//		double dist = Double.MAX_VALUE;
//		for(int i = 0; i < this.uselessAvailablePositions.size(); i++) {
//			double d = Math.abs(myX - this.uselessAvailablePositions.get(i).x) + Math.abs(myY - this.uselessAvailablePositions.get(i).y);
//			if(d < dist) {
//				toRemove = i;
//				dist = d;
//			}
//		}
//		if(toRemove != -1) {
//			x.set(this.uselessAvailablePositions.get(toRemove).x);
//			y.set(this.uselessAvailablePositions.get(toRemove).y);
//			this.uselessAvailablePositions.remove(toRemove);
//		}
//	}
	
	@OPERATION
	void addRetrieverAvailablePos(String name, int x, int y) {
//		logger.info("(" + x + ", " + y + ") is now a retriever available position");
		teams.get(name).addRetrieversAvailablePositions(x, y);
	}

	@OPERATION
	void addTeamSize(int size){
		maxTeams = size;
	}
	
	@OPERATION
	void addServerName(String agent, String agentServer){
		agentNames.put(agent,agentServer);
	}
	
	@OPERATION
	void getServerName(String agent, OpFeedbackParam<String> agentServer){
		agentServer.set(agentNames.get(agent));
	}
	
	@OPERATION 
	void setSizeX(int x){
		sizeX = x;
	}
	
	@OPERATION 
	void setSizeY(int y){
		sizeY = y;
	}
	
	@OPERATION
	void evaluateOrigin(String name, int x, int y, String evaluation) {
		//if(evaluation.equals("boh")) return;
//		logger.info("evaluateOrigin(" + name + ", " + x + ", " + y + ", " + evaluation + ")");
		for(String key : agentmaps.get(name).keySet()) {
			if(key.startsWith("goal_")) {
				for(Point pp : agentmaps.get(name).get(key)) {
					if(x == pp.x && y == pp.y) {
						if(pp instanceof OriginPoint) {
							if(((OriginPoint) pp).evaluated.equals("boh")) {
								((OriginPoint) pp).evaluated = evaluation;
							} 
							return;
						}
						agentmaps.get(name).get(key).remove(pp);
						agentmaps.get(name).get(key).add(new OriginPoint(x, y, evaluation));
						return;
					}
				}
			}
		}
//		logger.info("not found it");
	}
	
	@OPERATION
	void evaluateOrigin(String name, int x, int y, String evaluation, int maxPosS, int maxPosW, int maxPosE) {
		//if(evaluation.equals("boh")) return;
//		logger.info("evaluateOrigin(" + name + ", " + x + ", " + y + ", " + evaluation + ")");
		for(String key : agentmaps.get(name).keySet()) {
			if(key.startsWith("goal_")) {
				for(Point pp : agentmaps.get(name).get(key)) {
					if(x == pp.x && y == pp.y) {
						if(pp instanceof OriginPoint) {
							if(((OriginPoint) pp).evaluated.equals("boh")) {
								((OriginPoint) pp).evaluated = evaluation;
								((OriginPoint) pp).maxPosS = maxPosS;
								((OriginPoint) pp).maxPosW = maxPosW;
								((OriginPoint) pp).maxPosE = maxPosE;
							} 
							return;
						}
						agentmaps.get(name).get(key).remove(pp);
						agentmaps.get(name).get(key).add(new OriginPoint(x, y, evaluation, maxPosS, maxPosW, maxPosE));
						return;
					}
				}
			}
		}
//		logger.info("not found it");
	}
	
	@OPERATION
	void addScoutToOrigin(String name, int originX, int originY, int scoutX, int scoutY) {
		for(String key : agentmaps.get(name).keySet()) {
			if(key.startsWith("goal_")) {
				for(Point pp : agentmaps.get(name).get(key)) {
					if(pp instanceof OriginPoint & originX == pp.x && originY == pp.y) {
						((OriginPoint) pp).scouts.add(new Point(scoutX, scoutY));
						return;
					}
				}
			}
		}
	}
	
	@OPERATION
	void addRetrieverToOrigin(String name, int originX, int originY, int retrieverX, int retrieverY) {
		for(String key : agentmaps.get(name).keySet()) {
			if(key.startsWith("goal_")) {
				for(Point pp : agentmaps.get(name).get(key)) {
					if(pp instanceof OriginPoint & originX == pp.x && originY == pp.y) {
//						logger.info("[" + name + "]" + "(" + retrieverX + ", " + retrieverY + ") retriever added to cluster " + key);
						((OriginPoint) pp).retrievers.add(new Point(retrieverX, retrieverY));
						return;
					}
				}
			}
		}
//		logger.info("[" + name + "]" + "addRetrieverToOrigin has not add anything");
	}
	
	@OPERATION
	void updateGoalMap(String name, int x, int y, OpFeedbackParam<String> clusterInserterIn, OpFeedbackParam<Boolean> isANewCluster) {
		Point p = new Point(x, y);
//		logger.info("[" + name + "]: Try to add goal (" + x + ", " + y + ")");
		double minDistance = 5;
		String myCluster = null;
		int id = 0;
		for(String key : agentmaps.get(name).keySet()) {
			if(key.startsWith("goal_")) {
				double distance = 0;
				for(Point pp : agentmaps.get(name).get(key)) {
					if(p.x == pp.x && p.y == pp.y) {
						return;
					}
					distance += Math.abs(p.x-pp.x) + Math.abs(p.y-pp.y);
					//System.out.println("Point (" + p.x + ", " + p.y + ") distance from (" + pp.x + ", " + pp.y + "):" + (Math.abs(p.x-pp.x) + Math.abs(p.y-pp.y)));
				}
				distance = distance / agentmaps.get(name).get(key).size();
				if(distance < minDistance) {
					minDistance = distance;
					myCluster = key;
				}
				id++;
			}
		}
		if(myCluster == null) {
			//logger.info("ID: " + id);
			Set<Point> set = new HashSet<Point>();
			//set.add(new OriginPoint(x, y));
			set.add(p);
			agentmaps.get(name).put("goal_" + id, set);
			clusterInserterIn.set("goal_" + id);
			isANewCluster.set(true);
			//logger.info("[" + name + "]" + " added point (" + p.x + ", " + p.y + ") to cluster " + agentmaps.get(name).get("goal_" + id) + " because distance is: " + minDistance);
		} else {
			//logger.info("[" + name + "]" + " added point (" + p.x + ", " + p.y + ") to cluster " + agentmaps.get(name).get(myCluster) + " because distance is: " + minDistance);
			clusterInserterIn.set(myCluster);
			isANewCluster.set(false);
			agentmaps.get(name).get(myCluster).add(p);
		}
	}
	
	@OPERATION
	void updateMap(String name, String type, int x, int y) {
		Point p = new Point(x, y);
//		if(!type.startsWith("goal_")) {
			if (!agentmaps.get(name).containsKey(type)) {
				Set<Point> set = new HashSet<Point>();
				set.add(p);
				agentmaps.get(name).put(type, set);
			}
			else {
				agentmaps.get(name).get(type).add(p);
			}
//		}
	}
	
	@OPERATION
	void updateLocations(String name, String axis, int size) {
		Map<String, Set<Point>>  mapaux 	 	= new HashMap<String, Set<Point>>();
		for (Map.Entry<String, Set<Point>> entry : agentmaps.get(name).entrySet()) {
			for (Point p : entry.getValue()) {
				int x;
				int y;
				if (axis.equals("x")) {
					if (p.x % size < 0) {
						x = p.x % size + size;
					} else {
						x = p.x % size;
					}
					y = p.y;
				} else {
					x = p.x;
					if (p.y % size < 0) {
						y = p.y % size + size;
					} else {
						y = p.y % size;
					}
				}
				Point pnew = new Point(x, y);
				if (!mapaux.containsKey(entry.getKey())) {
					Set<Point> set = new HashSet<Point>();
					set.add(pnew);
					mapaux.put(entry.getKey(), set);
				}
				else {
					mapaux.get(entry.getKey()).add(pnew);
				}
			}
		}
		agentmaps.get(name).clear();
		agentmaps.get(name).putAll(mapaux);
	}
	
	private static class OriginPoint extends Point{
		private String evaluated = "boh";
		private List<Point> scouts = new ArrayList<>();
		private List<Point> retrievers = new ArrayList<>();
		private int maxPosS;
		private int maxPosW;
		private int maxPosE;
		
		public OriginPoint(int x, int y, String evaluated) {
			super(x, y);
			this.evaluated = evaluated;
		}
		
		public OriginPoint(int x, int y, String evaluated, int maxPosS, int maxPosW, int maxPosE) {
			super(x, y);
			this.evaluated = evaluated;
			this.maxPosS = maxPosS;
			this.maxPosW = maxPosW;
			this.maxPosE = maxPosE;
		}
		// nothing different to add for now
	}
	
	@OPERATION 
	void getAllSize(String name, OpFeedbackParam<Integer> size){
		size.set(agentmaps.get(name).values().stream().mapToInt(Set::size).sum());
	}
	
	@OPERATION 
	void getDispensers(String name, OpFeedbackParam<Literal[]> dispensers){
		List<Literal> things = new ArrayList<Literal>();
		for (Map.Entry<String, Set<Point>> entry : agentmaps.get(name).entrySet()) {
			if (!entry.getKey().startsWith("goal") && !entry.getKey().startsWith("taskboard")) {
	//		    logger.info(name+"  :   "+entry.getKey() + " = " + entry.getValue());
				Atom type = new Atom(entry.getKey());
				for (Point p : entry.getValue()) {
					Literal literal = ASSyntax.createLiteral("dispenser");
					NumberTerm x = new NumberTermImpl(p.x);
					NumberTerm y = new NumberTermImpl(p.y);
					literal.addTerm(type);
					literal.addTerm(x);
					literal.addTerm(y);
					things.add(literal);
				}
			}
		}
		Literal[] arraythings = things.toArray(new Literal[things.size()]);
		dispensers.set(arraythings);
	}
	
	@OPERATION 
	void getTaskboards(String name, OpFeedbackParam<Literal[]> taskboards){
		List<Literal> things = new ArrayList<Literal>();
		for (Map.Entry<String, Set<Point>> entry : agentmaps.get(name).entrySet()) {
			if (entry.getKey().startsWith("taskboard")) {
				for (Point p : entry.getValue()) {
					Literal literal = ASSyntax.createLiteral("taskboard");
					NumberTerm x = new NumberTermImpl(p.x);
					NumberTerm y = new NumberTermImpl(p.y);
					literal.addTerm(x);
					literal.addTerm(y);
					things.add(literal);
				}
			}
		}
		Literal[] arraythings = things.toArray(new Literal[things.size()]);
		taskboards.set(arraythings);
	}
	
	@OPERATION 
	void getGoals(String name, OpFeedbackParam<Literal[]> goals){
		List<Literal> things = new ArrayList<Literal>();
		for (Map.Entry<String, Set<Point>> entry : agentmaps.get(name).entrySet()) {
			if (entry.getKey().startsWith("goal")) {
				for (Point p : entry.getValue()) {
					Literal literal = ASSyntax.createLiteral("goal");
					NumberTerm x = new NumberTermImpl(p.x);
					NumberTerm y = new NumberTermImpl(p.y);
					literal.addTerm(x);
					literal.addTerm(y);
					things.add(literal);
				}
			}
		}
		Literal[] arraythings = things.toArray(new Literal[things.size()]);
		goals.set(arraythings);
	}
	
	@OPERATION 
	void getGoalClusters(String name, OpFeedbackParam<Literal[]> clusters){
		List<Literal> things 		= new ArrayList<Literal>();
		for (Map.Entry<String, Set<Point>> entry : agentmaps.get(name).entrySet()) {
			if (entry.getKey().startsWith("goal_")) {
	//		    logger.info(name+"  :   "+entry.getKey() + " = " + entry.getValue());
				Literal cluster = ASSyntax.createLiteral("cluster");
				cluster.addTerm(ASSyntax.createAtom(entry.getKey()));
				List<Literal> goals = new ArrayList<Literal>();
				for (Point p : entry.getValue()) {
					Literal literal = null;
					if(p instanceof OriginPoint) {
						literal = ASSyntax.createLiteral("origin");
						literal.addTerm(new Atom(((OriginPoint) p).evaluated));
					} else {
						literal = ASSyntax.createLiteral("goal");
					}
					NumberTerm x = new NumberTermImpl(p.x);
					NumberTerm y = new NumberTermImpl(p.y);
					literal.addTerm(x);
					literal.addTerm(y);
					goals.add(literal);
				}
				cluster.addTerm(ASSyntax.createList(goals.toArray(new Literal[goals.size()])));
				things.add(cluster);
			}
		}
		Literal[] arraythings = things.toArray(new Literal[things.size()]);
		clusters.set(arraythings);
	}
	
	@OPERATION 
	void getGoalClustersWithScouts(String name, OpFeedbackParam<Literal[]> clusters){
		List<Literal> things 		= new ArrayList<Literal>();
		for (Map.Entry<String, Set<Point>> entry : agentmaps.get(name).entrySet()) {
			if (entry.getKey().startsWith("goal_")) {
	//		    logger.info(name+"  :   "+entry.getKey() + " = " + entry.getValue());
				Literal cluster = ASSyntax.createLiteral("cluster");
				cluster.addTerm(ASSyntax.createAtom(entry.getKey()));
				List<Literal> goals = new ArrayList<Literal>();
				for (Point p : entry.getValue()) {
					Literal literal = null;
					if(p instanceof OriginPoint) {
						literal = ASSyntax.createLiteral("origin");
						literal.addTerm(new Atom(((OriginPoint) p).evaluated));
						List<Literal> scouts = new ArrayList<Literal>();
						for(Point scout : ((OriginPoint)p).scouts) {
							Literal s = ASSyntax.createLiteral("scout");
							s.addTerm(new NumberTermImpl(scout.x));
							s.addTerm(new NumberTermImpl(scout.y));
							scouts.add(s);
						}
						List<Literal> retrievers = new ArrayList<Literal>();
						for(Point retriever : ((OriginPoint)p).retrievers) {
							Literal s = ASSyntax.createLiteral("retriever");
							s.addTerm(new NumberTermImpl(retriever.x));
							s.addTerm(new NumberTermImpl(retriever.y));
							retrievers.add(s);
						}
						literal.addTerm(ASSyntax.createList(scouts.toArray(new Literal[scouts.size()])));
						literal.addTerm(ASSyntax.createList(retrievers.toArray(new Literal[retrievers.size()])));
						literal.addTerm(new NumberTermImpl(((OriginPoint)p).maxPosS));
						literal.addTerm(new NumberTermImpl(((OriginPoint)p).maxPosW));
						literal.addTerm(new NumberTermImpl(((OriginPoint)p).maxPosE));
					} else {
						literal = ASSyntax.createLiteral("goal");
					}
					NumberTerm x = new NumberTermImpl(p.x);
					NumberTerm y = new NumberTermImpl(p.y);
					literal.addTerm(x);
					literal.addTerm(y);
					goals.add(literal);
				}
				cluster.addTerm(ASSyntax.createList(goals.toArray(new Literal[goals.size()])));
				things.add(cluster);
			}
		}
		Literal[] arraythings = things.toArray(new Literal[things.size()]);
		clusters.set(arraythings);
	}
	
//	@OPERATION 
//	void getGoals(String name, String cluster, OpFeedbackParam<Literal[]> goals){
//		List<Literal> things 		= new ArrayList<Literal>();
//		for(Point p : agentmaps.get(name).get(cluster)) {
//			Literal literal = null;
//			if(p instanceof OriginPoint) {
//				literal = ASSyntax.createLiteral("origin");
//				literal.addTerm(new Atom(((OriginPoint) p).evaluated));
//			} else {
//				literal = ASSyntax.createLiteral("goal");
//			}
//			NumberTerm x = new NumberTermImpl(p.x);
//			NumberTerm y = new NumberTermImpl(p.y);
//			literal.addTerm(x);
//			literal.addTerm(y);
//			things.add(literal);
//		}
//		Literal[] arraythings = things.toArray(new Literal[things.size()]);
//		goals.set(arraythings);
//	}
	
	@OPERATION
	void addAvailableAgent(String leader, String name, String type) {
		teams.get(leader).addAgentAvailable(name, type);
	}
	
	@OPERATION
	void removeAvailableAgent(String leader, String name) {
		teams.get(leader).removeAgentAvailable(name);
	}
	
	@OPERATION 
	void getAvailableAgent(String leader, OpFeedbackParam<Literal[]> list){
		List<Literal> agents 		= new ArrayList<Literal>();
		for (Map.Entry<String, String> entry :teams.get(leader).getAgentAvailable().entrySet()) {
			Literal literal = ASSyntax.createLiteral("agent");	
			Atom name = new Atom(entry.getKey());
			Atom type = new Atom(entry.getValue());
			literal.addTerm(name);
			literal.addTerm(type);
			agents.add(literal);
		}
		Literal[] arrayagents = agents.toArray(new Literal[agents.size()]);
		list.set(arrayagents);
	}
	
	@OPERATION 
	void getAvailableMeType(String leader, String me, OpFeedbackParam<String> type) {
		type.set(teams.get(leader).getAgentAvailableType(me));
	}
	
	@OPERATION
	void getBlocks(String name, OpFeedbackParam<Literal[]> list) {
		List<Literal> things = new ArrayList<Literal>();
		for(Pair<String, String> p : teams.get(name).getTheBlocks()) {
			Literal literal = ASSyntax.createLiteral("block");	
			literal.addTerm(ASSyntax.createAtom(p.getFirst()));
			literal.addTerm(ASSyntax.createAtom(p.getSecond()));
			things.add(literal);
		}
		Literal[] arraythings = things.toArray(new Literal[things.size()]);
		list.set(arraythings);
	}
	
	@OPERATION
	void addBlock(String leader, String ag, String b) {
		teams.get(leader).addBlock(ag, b);
	}
	
	@OPERATION
	void removeBlock(String leader, String ag) {
		teams.get(leader).removeBlock(ag);
	}
	
	@OPERATION
	void clearTeam() {
		agentNames.clear();
		actionsByStep.clear();
		agentmaps.clear();
		map1.clear();
		map2.clear();
		map3.clear();
		map4.clear();
		map5.clear();
		map6.clear();
		map7.clear();
		map8.clear();
		map9.clear();
		map10.clear();
		retrieversAvailablePositions.clear();
		teams.clear();
		this.init();
	}
	
	@OPERATION
	void chosenAction(int step) {
		String agent = getCurrentOpAgentId().getAgentName();
		
		Set<String> agents = actionsByStep.remove(step);
		if (agents == null)
			agents = new HashSet<String>();
		
		if (!agents.contains(agent)) {
			agents.add(agent);
			actionsByStep.put(step, agents);
			
			if (this.getObsPropertyByTemplate("chosenActions", step,null) != null)
				this.removeObsPropertyByTemplate("chosenActions", step, null);
			this.defineObsProperty("chosenActions", step, agents.toArray());
			
//			clean belief
			if (actionsByStep.containsKey(step-3)) {
				actionsByStep.remove(step-3);
				this.removeObsPropertyByTemplate("chosenActions", step-3, null);
			}
		}	
	}
	
	/*
	 * The following methods are for deciding where to send the explorer
	 * agent if we do not have enough knowledge about goal positions
	 * 
	 * NOTE: all the following methods assume that the size of the map is known. 
	 */
	
	
	/*
	 * Input: GLOBAL coordinate of the source and GLOBAL coordinate of the target
	 * 
	 * Output: returns the minimum Manhattan distance between source and target while
	 * assuming that we can go over the edge of the map
	 * 
	 */
	private int getMinimalDistanceFromTarget(Point sourceCoordinates, Point targetCoordinates) {
		int maxX = this.sizeX / 2;
		int maxY = this.sizeY / 2;
		int tmpX = Math.abs((int)targetCoordinates.getX() - (int)sourceCoordinates.getX());
		
		int finalX = tmpX;
		if(tmpX > maxX)
			finalX = this.sizeX - tmpX;
		
		int tmpY = Math.abs((int)targetCoordinates.getY() - (int)sourceCoordinates.getY());
		
		int finalY = tmpY;
		if(tmpY > maxY)
			finalY = this.sizeY - tmpY;
		
		return finalX + finalY;
	}
	
	/*
	 * Input: GLOBAL coordinate of the source and the name of the agent in order to
	 * understand which map to look at
	 * 
	 * Output: returns the minimum distance to the closest entity (dispenser, taskboard, goal position)
	 * 
	 */
	private int getMinimalDistanceFromAll(Point sourceCoordinates, String agentName) {
		Map<String, Set<Point>> agentMap = this.agentmaps.get(agentName);
		Set<Point> coordinatesToCheck = new HashSet<Point>();
		
		//Putting all coordinates of known dispensers/goals/taskboards together
		for(String key : agentMap.keySet())
			coordinatesToCheck.addAll(agentMap.get(key));
		
		//Fictitious value known to be greater than any minimal distance
		int minimalDistance = this.sizeX + this.sizeY;
		
		for(Point target : coordinatesToCheck) {
			int minimalDistanceFromTarget = getMinimalDistanceFromTarget(sourceCoordinates, target);
			if(minimalDistanceFromTarget < minimalDistance)
				minimalDistance = minimalDistanceFromTarget;
		}
			
		return minimalDistance;
	}
	
	/*
	 * Input: agent name (to use the right map), starting coordinates and their minimal distance from known entities
	 * 
	 * Output: the reachable cell which is further away from known entities starting from the given coordinates
	 * 
	 */
	private Point getSinkFromCell(String agentName, Point sourceCoordinates, int sourceMinimalDistance) {
		Point nextCell = sourceCoordinates;
		int maximalDistance = sourceMinimalDistance;
		
		//Computing coordinates and minimal distances of neighbour cells
		Point northCell = new Point((int)sourceCoordinates.getX(), ((int)sourceCoordinates.getY() - 1) % this.sizeY);
		int minimalNorth = getMinimalDistanceFromAll(northCell, agentName);
		
		Point eastCell = new Point(((int)sourceCoordinates.getX() + 1) % this.sizeX, (int)sourceCoordinates.getY());
		int minimalEast = getMinimalDistanceFromAll(eastCell, agentName);
		
		Point southCell = new Point((int)sourceCoordinates.getX(), ((int)sourceCoordinates.getY() + 1) % this.sizeY);
		int minimalSouth = getMinimalDistanceFromAll(southCell, agentName);
		
		Point westCell = new Point(((int)sourceCoordinates.getX() - 1) % this.sizeX, (int)sourceCoordinates.getY());
		int minimalWest = getMinimalDistanceFromAll(westCell, agentName);
		
		//update the maximal distance if one of the neighbours is further away from a known entity
		if(maximalDistance < minimalNorth) {
			nextCell = northCell;
			maximalDistance = minimalNorth; 
		}
		
		if(maximalDistance < minimalEast) {
			nextCell = eastCell;
			maximalDistance = minimalEast;
		}
		
		if(maximalDistance < minimalSouth) {
			nextCell = southCell;
			maximalDistance = minimalSouth;
		}
		
		if(maximalDistance < minimalWest) {
			nextCell = westCell;
			maximalDistance = minimalWest;
		}
		
		//Recursive call if the maximal distance has changed
		if(maximalDistance != sourceMinimalDistance)
			return getSinkFromCell(agentName, nextCell, maximalDistance);
		
		//Otherwise
		return nextCell;
	}
	
	/*
	 * Sven's suggestion
	 * 
	 * Input: agent name (to use the right map) and its coordinates 
	 * 
	 * Output: coordinates of a sink reachable from the vision edge of the agent
	 * 
	 * NOTE: this method can be reduced to very few lines by using a Pair class and an auxiliary method. I didn't find a Pair class
	 * on the spot and didn't want to implement one... 
	 */
	private Point getSinkFromAgentPosition(String agentName, Point agentCoordinates) {
		Point startingCell = agentCoordinates;
		int maximalDistance = -1;
		
		//checking the north cell
		Point tmpCell = new Point((int)agentCoordinates.getX(), ((int)agentCoordinates.getY() - 5) % this.sizeY);
		int tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
		
		if(maximalDistance < tmpDistance) {
			maximalDistance = tmpDistance;
			startingCell = tmpCell;
		}
		
		//checking the east cell
		tmpCell = new Point(((int)agentCoordinates.getX() + 5) % this.sizeX, (int)agentCoordinates.getY());
		tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
		
		if(maximalDistance < tmpDistance) {
			maximalDistance = tmpDistance;
			startingCell = tmpCell;
		}
		
		//checking the south cell
		tmpCell = new Point((int)agentCoordinates.getX(), ((int)agentCoordinates.getY() + 5) % this.sizeY);
		tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
		
		if(maximalDistance < tmpDistance) {
			maximalDistance = tmpDistance;
			startingCell = tmpCell;
		}
		
		//checking the west cell
		tmpCell = new Point(((int)agentCoordinates.getX() - 5) % this.sizeX, (int)agentCoordinates.getY());
		tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
		
		if(maximalDistance < tmpDistance) {
			maximalDistance = tmpDistance;
			startingCell = tmpCell;
		}
		
		//checking the other cells at the vision edge
		for(int i = 1; i < 5; i++) {
			int j = 5 - i;
			
			tmpCell = new Point(((int)agentCoordinates.getX() + i) % this.sizeX, ((int)agentCoordinates.getY() + j) % this.sizeY);
			tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
			
			if(maximalDistance < tmpDistance) {
				maximalDistance = tmpDistance;
				startingCell = tmpCell;
			}
			
			tmpCell = new Point(((int)agentCoordinates.getX() + i) % this.sizeX, ((int)agentCoordinates.getY() - j) % this.sizeY);
			tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
			
			if(maximalDistance < tmpDistance) {
				maximalDistance = tmpDistance;
				startingCell = tmpCell;
			}
			
			tmpCell = new Point(((int)agentCoordinates.getX() - i) % this.sizeX, ((int)agentCoordinates.getY() + j) % this.sizeY);
			tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
			
			if(maximalDistance < tmpDistance) {
				maximalDistance = tmpDistance;
				startingCell = tmpCell;
			}
			
			tmpCell = new Point(((int)agentCoordinates.getX() - i) % this.sizeX, ((int)agentCoordinates.getY() - j) % this.sizeY);
			tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
			
			if(maximalDistance < tmpDistance) {
				maximalDistance = tmpDistance;
				startingCell = tmpCell;
			}
		}
		
		return getSinkFromCell(agentName, startingCell, maximalDistance);
	}
	
	
	/*
	 * 
	 * Input: the agent name to use the right map
	 * 
	 * Output: the best cell among a bunch of cells on the map
	 *  
	 * 
	 */
	private Point getDestinationFromRandomPoints(String agentName) {
		//paramenters to play with
		int xDistance = 20;
		int yDistance = 20;
		
		int xIterations = this.sizeX / xDistance;
		int yIterations = this.sizeY / yDistance;
		
		//actual algorithm
		int maximalDistance = - 1;
		Point returnedPoint = null;
		
		for(int x = 0; x <= xIterations; x++)
			for(int y = 0; y <= yIterations; y++) {
				
				Point tmpCell = new Point(x * xDistance,  y * yDistance);
				int tmpDistance = getMinimalDistanceFromAll(tmpCell, agentName);
				
				if(maximalDistance < tmpDistance) {
					maximalDistance = tmpDistance;
					returnedPoint = tmpCell;
				}
			}
		
		return returnedPoint;
	}
	
	
	/*
	 * 
	 * Like the method above, but looks for a sink starting from the returned point
	 * 
	 */
	private Point getSinkFromRandomPoint(String agentName) {
		Point startingCell = getDestinationFromRandomPoints(agentName);
		return getSinkFromCell(agentName, startingCell, getMinimalDistanceFromAll(startingCell, agentName));
	}
	
	/*
	 * Input: agent name (to use the right map), its GLOBAL coordinates and the variables to store the coordinates of the destination
	 * 
	 */
	@OPERATION
	void getExplorerDestination(String agentName, int agentX, int agentY, OpFeedbackParam<Integer> destinationX, OpFeedbackParam<Integer> destinationY) {
		
		//Three possibility so far, uncomment the one you want to try
		Point destination = getSinkFromAgentPosition(agentName, new Point(agentX, agentY));
		//Point destination = getDestinationFromRandomPoints(agentName)
		//Point destination = getSinkFromRandomPoint(agentName);
		
		destinationX.set((int)destination.getX());
		destinationY.set((int)destination.getY());
	}
	
	public class Team {
		int targetTaskX;
		int targetTaskY;
		int targetGoalX;
		int targetGoalY;
		List<Point> retrieversAvailablePositions = new ArrayList<>();
		Map<String, String>  agentAvailable 	 	= new HashMap<String, String>();
		List<Pair<String, String>> ourBlocks = new ArrayList<>();
		
		public Team(int targetTaskX, int targetTaskY, int targetGoalX, int targetGoalY, List<Point> retrieversAvailablePositions) {
			this.targetTaskX = targetTaskX;
			this.targetTaskY = targetTaskY;
			this.targetGoalX = targetGoalX;
			this.targetGoalY = targetGoalY;
			this.retrieversAvailablePositions.addAll(retrieversAvailablePositions);
			this.agentAvailable.clear();
			this.ourBlocks.clear();
		}
		
		public int getTargetTaskX()
		{
			return targetTaskX;
		}
		
		public int getTargetTaskY()
		{
			return targetTaskY;
		}
		
		public int getTargetGoalX()
		{
			return targetGoalX;
		}
		
		public int getTargetGoalY()
		{
			return targetGoalY;
		}
		
		public List<Point> getRetrieversAvailablePositions()
		{
			return retrieversAvailablePositions;
		}
		
		public void setTargetTaskX(int x)
		{
			this.targetTaskX = x;
		}
		
		public void setTargetTaskY(int y)
		{
			this.targetTaskY = y;
		}
		
		public void setTargetGoalX(int x)
		{
			this.targetGoalX = x;
		}
		
		public void setTargetGoalY(int y)
		{
			this.targetGoalY = y;
		}
		
		public void setRetrieversAvailablePositions(List<Point> list)
		{
			this.retrieversAvailablePositions.clear();
			this.retrieversAvailablePositions.addAll(list);
		}
		
		public void addRetrieversAvailablePositions(int x, int y) {
			this.retrieversAvailablePositions.add(new Point(x,y));
		}
		
		public Map<String, String> getAgentAvailable()
		{
			return agentAvailable;
		}
		
		public String getAgentAvailableType(String name)
		{
			return agentAvailable.get(name);
		}
		
		public void addAgentAvailable(String name, String type) {
			this.agentAvailable.put(name,type);
		}

		public void removeAgentAvailable(String name) {
			this.agentAvailable.remove(name);
		}
		
		public List<Pair<String, String>> getTheBlocks()
		{
			return ourBlocks;
		}
		
		public void addBlock(String ag, String b) {
			this.ourBlocks.add(new Pair<String, String>(ag, b));
		}

		public void removeBlock(String ag) {
			this.ourBlocks.removeIf(p -> p.getFirst().equals(ag));
		}
		
	}
	
}
