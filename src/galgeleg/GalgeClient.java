package galgeleg;

import java.rmi.Naming;
import java.rmi.RemoteException;

public class GalgeClient {

  public static void main(String[] args) throws Exception {

    boolean testEnvironment = true;
    final int PORT =9999;
    final String TEST_ENV ="";
    final String PROD_ENV ="rmi://130.225.170.204:"+PORT+"/";
    IGalgeLogik spil;

    if(!testEnvironment){
      spil = (IGalgeLogik) Naming.lookup("rmi://130.225.170.204:"+PORT+"/Galgespil");
    } else{
      spil = (IGalgeLogik) Naming.lookup("rmi://localhost:"+PORT+"/Galgespil");
    }
    
    spil.hentOrdFraDR();
    System.out.println("Server fetched word from DR: " + spil.getOrdet());
    spil.logStatus();
    System.out.println("\n**** STATUS ****");
    System.out.println("Visible word: " + spil.getSynligtOrd());

    boolean gameOver;
    gameOver = spil.erSpilletTabt() || spil.erSpilletVundet() ? true : false;
    System.out.println("Is game over? " + gameOver + "\n");

    spil.nulstil();
    System.out.println("Game reset");



    //Der hentes automatisk ord fra DR




    
    // Kommentér ind for at hente ord fra DR
    /*
    try {
      spil.hentOrdFraDr();
    } catch (Exception e) {
      e.printStackTrace();
    }
    */

    // Kommentér ind for at hente ord fra et online regneark
    /*
    try {
      spil.hentOrdFraRegneark("12");
    } catch (Exception e) {
      e.printStackTrace();
    }
    */

  }
}
