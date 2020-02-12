package galgeleg;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.URL;
import java.rmi.Naming;
import  java.util.Scanner;
import java.util.ServiceConfigurationError;

public class GalgeClient {

    public static void main(String[] args) throws Exception {

        boolean testEnvironment = true;


        IGalgeLogik spil = null;
        IUserAuth auth = null;
        Scanner letterInput = new Scanner(System.in);
        String brugernavn = "";
        String password = "";
        boolean loginOK;
        boolean spilletTabt = false;
        boolean spilletVundet = false;


        final String urlPrefix = "http://";
        final String LOCAL_ENV = "localhost";
        final String PROD_ENV = "130.225.170.204";
        final String nameSpace = "http://galgeleg/";
        final String gameLocalPart = "GalgeLogikImplService";
        final String authLocalPart = "UserAuthImplService";
        final int AUTHPORT = 9999;
        final int GAMEPORT = 9898;


        String GAMEURL, AUTHURL;
        if (testEnvironment) {
            AUTHURL = urlPrefix + LOCAL_ENV + ":" + AUTHPORT + "/userauth?wsdl";
            GAMEURL = urlPrefix + LOCAL_ENV + ":" + GAMEPORT + "/galgespil?wsdl";
        } else {
            System.out.println("Der spilles på localhost......");
            AUTHURL = urlPrefix + PROD_ENV + ":" + AUTHPORT + "/userauth?wsdl";
            GAMEURL = urlPrefix + PROD_ENV + ":" + GAMEPORT + "/galgespil?wsdl";
        }

        System.out.println("AUTHURL: " + AUTHURL);
        System.out.println("GAMEURL: " + GAMEURL);


        URL gameurl = new URL(GAMEURL);
        QName gameQname = new QName(nameSpace, gameLocalPart);
        Service gameservice = Service.create(gameurl, gameQname);
        spil = gameservice.getPort(IGalgeLogik.class);


        URL authUrl = new URL(AUTHURL);
        QName authQname = new QName(nameSpace, authLocalPart);
        Service authService = Service.create(authUrl, authQname);
        auth = authService.getPort(IUserAuth.class);


        do{
            System.out.print("Indtast brugernavn: ");
            brugernavn = letterInput.nextLine();
            System.out.print("\nIndtast password: ");
            password = letterInput.nextLine();
            if (auth.login(brugernavn, password)){
                loginOK = true;
            }else{
                System.out.println("Du har ikke indtastet rigtigt brugernavn og/eller password. Prøv igen.");
                loginOK = false;
            }
        }while(!loginOK);

        System.out.println("ordet er: " + spil.getOrdet());

        //Loop hvis spillet ikke er tabt og ikke er vundet
        while (true) {
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
                    if (spil.erSpilletTabt()) {
                        System.out.println("Du har desværre tabt spillet");
                        System.out.println("Ordet var:" + spil.getOrdet());
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
    }
}
