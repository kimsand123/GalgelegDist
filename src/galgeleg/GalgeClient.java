package galgeleg;

import javax.xml.namespace.QName;
import java.net.URL;
import java.rmi.Naming;
import  java.util.Scanner;
public class GalgeClient {

  public static void main(String[] args) throws Exception {


    boolean testEnvironment = true;
    final int PORT = 9898;
    final String TEST_ENV = "localhost:";
    final String PROD_ENV = "130.225.170.204:" + PORT + "/";
    IGalgeLogik spil;
    Scanner letterInput = new Scanner(System.in);

    if (!testEnvironment) {
      URL url = new URL("http://"+PROD_ENV+PORT+"/galgespil?wsdl");
      QName qname = new QName("http://"+PROD_ENV+"/", "galgespilServerImplService");
      spil = (IGalgeLogik) Naming.lookup("rmi://130.225.170.204:" + PORT + "/Galgespil");
    } else {
      spil = (IGalgeLogik) Naming.lookup("rmi://localhost:" + PORT + "/Galgespil");
    }

    System.out.println("ordet er: " + spil.getOrdet());

    while (!(spil.erSpilletTabt() && spil.erSpilletVundet())) {
      //Hent synligt ord og vis det.
      String visibleWord = spil.getSynligtOrd();
      System.out.println("Det synlige ord er: " + visibleWord);

      String letter = "";
      //loop indtil længden på det indtastede er = 1
      while (letter.length() != 1) {
        //Hent input
        System.out.print("Indtast det bogstav du vil gætte på: ");
        letter = letterInput.nextLine();

        //Hvis længden != 1 så skriv ledetekst, ellers kør videre med spillet
        if (letter.length() != 1) {
          System.out.println("Du skal indtaste 1 bogstav, hverken mere eller mindre");
        } else {

          //Send input, og check om bogstavet var korrekt
          spil.gætBogstav(letter);
          if (spil.erSpilletVundet()) {
            System.out.println("Tillykke I har vundet spiller");
            System.out.println("Ordet var: " + spil.getOrdet());
            break;
          }
          if (spil.erSidsteBogstavKorrekt()) {
            System.out.println("Bogstavet " + letter + " findes i ordet");
          } else {
            //hangman picture
            System.out.println("Bogstavet " + letter + " findes ikke i ordet");
          }
          System.out.println("De brugte bogstaver er: " + spil.getBrugteBogstaver());
        }
      }
    }
    if (spil.erSpilletTabt()) {
      System.out.println("I har desværre tabt spillet");
    }

  }
}
