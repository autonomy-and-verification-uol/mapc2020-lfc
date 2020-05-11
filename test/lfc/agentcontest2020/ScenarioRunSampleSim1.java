package lfc.agentcontest2020;

import java.io.File;
import java.io.IOException;
import java.util.Arrays;

import org.apache.commons.io.FileUtils;
import org.junit.Before;
import org.junit.Test;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;
import massim.Server;


public class ScenarioRunSampleSim1 {
	
	@Before
	public void cleanUpFolders() throws IOException {

		File currentDir = new File("");
		String path = currentDir.getAbsolutePath();	
				
		ScenarioRunSampleSim1 deletefiles = new ScenarioRunSampleSim1();
		deletefiles.delete(5, path + "/logs");
		deletefiles.delete(4, path + "/log");
		deletefiles.delete(5, path + "/replays");	
		
	}
	
	public void delete(long nFiles, String directoryFolder) throws IOException {
		File folder = new File(directoryFolder);
		if(folder.exists()) {
			File[] listFiles = folder.listFiles();
			Arrays.sort(listFiles);
			for ( int i=0; i < listFiles.length - nFiles ; i++ ){
				if (!listFiles[i].getName().equals(".keepfolder")) {
//					System.out.println(listFiles[i].getName());
					listFiles[i].delete();
					FileUtils.deleteDirectory(listFiles[i]);
				}
			}		
		}
	}		
	
	@Before
	public void setUp() {

		new Thread(new Runnable() {
			@Override
			public void run() {
				try {
					
					Server.main(new String[] {"-conf", "conf/SampleConfigSim1.json", "--monitor"});				
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}).start();

		try {			
			JaCaMoLauncher.main(new String[] {"lfc-mapc2020-15.jcm"});
		} catch (JasonException e) {
			System.out.println("Exception: "+e.getMessage());
			e.printStackTrace();
		}

	}
	
	@Test
	public void run() {		
	}

		
}







