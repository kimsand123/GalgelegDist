package galgeleg;
import java.rmi.Naming;

public class GalgeServer {



    public static void main(String[] arg) throws Exception{

        boolean testEnvironment = false;
        final int PORT =9999;
        final String TEST_ENV ="";
        final String PROD_ENV ="rmi://130.225.170.204:"+PORT+"/";

        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        java.rmi.registry.LocateRegistry.createRegistry(PORT);

        System.out.println("Registrer Galgeserver i NameRegistry");

        if(testEnvironment){
            Naming.rebind("rmi://130.225.170.204:"+PORT+"/Galgespil", galgeLogik);
        }else{
            Naming.rebind("rmi://localhost:"+PORT+"/Galgespil", galgeLogik);
        }

        System.out.println("Galgeserver er registreret i NameRegistry");
        System.out.print("Server kører.....\n\n");



    }
}
