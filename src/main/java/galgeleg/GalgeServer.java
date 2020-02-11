package galgeleg;

import javax

public class GalgeServer {



    public static void main(String[] arg) throws Exception{

        boolean testEnvironment = true;
        final int PORT =9898;
        final String TEST_ENV ="";
        final String PROD_ENV ="rmi://130.225.170.204:"+PORT+"/";

        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        System.out.println("Publicerer Galgeleg over SOAP");
        Endpoint.publish("rmi://localhost:2000/Galgespil", galgeLogik);

        System.out.println("Galgeserver er registreret i NameRegistry");
        System.out.print("Server kører.....\n\n");



    }
}
