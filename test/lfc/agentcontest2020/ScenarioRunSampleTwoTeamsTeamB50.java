package lfc.agentcontest2020;

import org.junit.Before;
import org.junit.Test;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;


public class ScenarioRunSampleTwoTeamsTeamB50 {
	
	@Before
	public void setUp() {
		try {			
			JaCaMoLauncher.main(new String[] {"lfc-mapc2020-50-TeamB.jcm"});
		} catch (JasonException e) {
			System.out.println("Exception: "+e.getMessage());
			e.printStackTrace();
		}
	}
	
	@Test
	public void run() {		
	}
}