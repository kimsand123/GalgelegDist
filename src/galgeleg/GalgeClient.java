package galgeleg;

import java.rmi.Naming;
import java.rmi.RemoteException;

public class GalgeClient {

  public static void main(String[] args) throws Exception {

    IGalgeLogik spil = (IGalgeLogik) Naming.lookup("rmi://localhost:2000/Galgespil");

    spil.hentOrdFraDR();
    spil.logStatus();
    spil.nulstil();



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
