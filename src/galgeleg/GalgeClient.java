package galgeleg;



import org.jcp.xml.dsig.internal.dom.DOMSubTreeData;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.URL;
import java.rmi.Naming;
import  java.util.Scanner;
import java.util.ServiceConfigurationError;

public class GalgeClient {

  public static void main(String[] args) throws Exception {


    boolean testEnvironment = true;
    final int PORT = 9898;
    final String TEST_ENV = "localhost:";
    final String PROD_ENV = "130.225.170.204:" + PORT + "/";
    IGalgeLogik spil=null;
    Scanner letterInput = new Scanner(System.in);
    String brugernavn = "";
    String password = "";
    boolean loginOK;


    if (testEnvironment) {
      URL url = new URL("http://[::]:9898/galgespil?wsdl");
      QName qname = new QName("http://galgeleg/", "GalgeLogikImplService");
      Service service = Service.create(url, qname);
      spil=service.getPort(IGalgeLogik.class);
      System.out.println("Spil: ");
    } else {
      URL url = new URL("http://130.225.170.204:9898/galgespil?wsdl");
      QName qname = new QName("http://galgeleg/", "GalgeLogikImplService");
      Service service = Service.create(url, qname);
      spil=service.getPort(IGalgeLogik.class);
    }
    do{
      System.out.print("Indtast brugernavn: ");
      brugernavn = letterInput.nextLine();
      System.out.print("\nIndtast password: ");
      password = letterInput.nextLine();
      if (spil.login(brugernavn, password)){
        loginOK = true;
      }else{
        System.out.println("Du har ikke indtastet rigtigt brugernavn og/eller password. Prøv igen.");
        loginOK = false;
      }
    }while(!loginOK);

    System.out.println("ordet er: " + spil.getOrdet());

    //Loop hvis spillet ikke er tabt og ikke er vundet
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
