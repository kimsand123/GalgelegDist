package client;

import brugerautorisation.data.Bruger;
import interfaces.IEntryPoint;
import interfaces.IUserAuth;

import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.URL;
import  java.util.Scanner;

public class GalgeClient {

    public static void main(String[] args) throws Exception {

        boolean testEnvironment = false;

        IEntryPoint spil = null;
        IUserAuth auth = null;
        Scanner input = new Scanner(System.in);
        String brugernavn = "";
        String password = "";
        boolean loginOK;
        boolean isGameOver = false;
        HangManGraphics graphics = new HangManGraphics();



        final String urlPrefix = "http://";
        final String LOCAL_ENV = "localhost";
        final String PROD_ENV = "130.225.170.204";
        final String nameSpace = "http://server/";
        final String gameLocalPart = "GalgeLogikImplService";
        final String authLocalPart = "EntryPointImplService";
        final int AUTHPORT = 9876;
        final int GAMEPORT = 9876;

        String token;
        String GAMEURL, AUTHURL;
        if (testEnvironment) {
            System.out.println("Der spilles på localhost......");
            AUTHURL = urlPrefix + LOCAL_ENV + ":" + AUTHPORT + "/entrypoint?wsdl";
            GAMEURL = urlPrefix + LOCAL_ENV + ":" + GAMEPORT + "/entrypoint?wsdl";
        } else {
            System.out.println("Der spilles gennem EntryPointServer......");
            AUTHURL = urlPrefix + PROD_ENV + ":" + AUTHPORT + "/entrypoint?wsdl";
            GAMEURL = urlPrefix + PROD_ENV + ":" + GAMEPORT + "/entrypoint?wsdl";
        }

        System.out.println("AUTHURL: " + AUTHURL);
        System.out.println("GAMEURL: " + GAMEURL);


        URL gameurl = new URL(GAMEURL);
        QName gameQname = new QName(nameSpace, gameLocalPart);
        Service gameservice = Service.create(gameurl, gameQname);
        spil = gameservice.getPort(IEntryPoint.class);

/*        URL authUrl = new URL(AUTHURL);
        QName authQname = new QName(nameSpace, authLocalPart);
        Service authService = Service.create(authUrl, authQname);
        auth = authService.getPort(IUserAuth.class);
        HangManGraphics graphics = new HangManGraphics();
*/

        Bruger user = null;
        do{
            System.out.print("Indtast brugernavn: ");
            brugernavn = input.nextLine();
            System.out.print("\nIndtast password: ");
            password = input.nextLine();
            token = spil.epLogOn(brugernavn, password);
            if (token!=null ){
                loginOK = true;
                //TODO skal laves så man kan skrive navnet ud.
                //user = auth.getUser(brugernavn);

                System.out.println("\n\n* * * * * * * * * *");
                System.out.println("Velkommen til spillet");
               // System.out.println("Velkommen til spillet " + user.fornavn + " " + user.efternavn + "!");
                System.out.println("* * * * * * * * * *\n\n");
            }else{
                System.out.println("Du har ikke indtastet rigtigt brugernavn og/eller password. Prøv igen.");
                loginOK = false;
            }
        }while(!loginOK);

        if(testEnvironment) {
            System.out.println("ordet er: " + spil.epGetOrdet(token));
        }

        String letter;
        String visibleWord;
        String endGameResponse;
        //Loop hvis spillet ikke er tabt og ikke er vundet
        while (!isGameOver) {

            //Hent synligt ord og vis det.
            visibleWord = spil.epGetSynligtOrd(token);
            System.out.println("Det synlige ord er: " + visibleWord);

            letter = "";
            //loop indtil længden på det indtastede er = 1
            while (letter.length() != 1) {
                //Hent input
                System.out.print("Indtast det bogstav du vil gætte på: \n");
                letter = input.nextLine().toLowerCase();
                System.out.println("\n");

                //Hvis længden != 1 så skriv ledetekst, ellers kør videre med spillet
                if (letter.length() != 1) {
                    System.out.println("Du skal indtaste 1 bogstav, hverken mere eller mindre\n");
                } else {

                    //Send input, og check om bogstavet var korrekt
                    spil.epGætBogstav(token, letter);

                    if (spil.epErSpilletVundet(token)==1) {
                        System.out.println("Tillykke " + user.fornavn + ", du har vundet spillet");
                        System.out.println("Ordet var: " + spil.epGetOrdet(token) + "\n\n");

                        System.out.println("Vil du gerne spille igen " + user.fornavn + "? [y/n]");
                        endGameResponse = input.nextLine().toLowerCase();
                        System.out.println("");


                        if(endGameResponse.equals("y")) {
                            System.out.println("* * * * * * * * * *");
                            System.out.println("Nyt spil starter nu!");
                            System.out.println("* * * * * * * * * *\n");
                            isGameOver = false;
                        } else if(endGameResponse.equals("n")) {
                            System.out.println("* * * * * * * * * *");
                            System.out.println("Ok, farvel " + user.fornavn);
                            System.out.println("* * * * * * * * * *");
                            isGameOver = true;
                            break;
                        } else {
                            System.out.println("Spillet afsluttes fordi du indtastede et ugyldigt svar...");
                            isGameOver = true;
                            break;
                        }
                    } else if (spil.epErSpilletTabt(token)==1) {
                        System.out.println(graphics.getTheMan(spil.epGetAntalForkerteBogstaver(token)-1));
                        System.out.println("Du har desværre tabt spillet " + user.fornavn);
                        System.out.println("Ordet var:" + spil.epGetOrdet(token));

                        System.out.println("Vil du gerne spille igen " + user.fornavn + "? [y/n]");
                        endGameResponse = input.nextLine().toLowerCase();
                        System.out.println("\n");

                        if(endGameResponse.equals("y")) {
                            System.out.println("* * * * * * * * * *");
                            System.out.println("Nyt spil starter nu!");
                            System.out.println("* * * * * * * * * *\n");
                            isGameOver = false;
                        } else if(endGameResponse.equals("n")) {
                            System.out.println("* * * * * * * * * *");
                            System.out.println("Ok, farvel");
                            spil.epLogOff(token);
                           // System.out.println("Ok, farvel " + user.fornavn);
                            System.out.println("* * * * * * * * * *");
                            isGameOver = true;
                            break;
                        } else {
                            System.out.println("Spillet afsluttes fordi du indtastede et ugyldigt svar...");
                            isGameOver = true;
                            break;
                        }
                    } else {
                        if (spil.epErSidsteBogstavKorrekt(token)==1) {
                            System.out.println("Bogstavet " + letter + " findes i ordet");


                        } else {
                            //hangman picture
                            System.out.println("Bogstavet " + letter + " findes ikke i ordet");
                            System.out.println("antal forkerte bogstaver: "+ spil.epGetAntalForkerteBogstaver(token));
                            System.out.println(graphics.getTheMan(spil.epGetAntalForkerteBogstaver(token)-1));
                        }
                        System.out.println("De brugte bogstaver er: " + spil.epGetBrugteBogstaver(token));
                        System.out.println("----------------------\n\n");
                    }
                }
            }
        }
    }
}
