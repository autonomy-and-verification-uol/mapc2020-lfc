package lfc.agentcontest2020;

import org.junit.Before;
import org.junit.Test;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;


public class ScenarioRunSampleTwoTeamsTeamB {
	
	@Before
	public void setUp() {
		try {			
			JaCaMoLauncher.main(new String[] {"lfc-mapc2020-15-TeamB.jcm"});
		} catch (JasonException e) {
			System.out.println("Exception: "+e.getMessage());
			e.printStackTrace();
		}
	}
	
	@Test
	public void run() {		
	}
}