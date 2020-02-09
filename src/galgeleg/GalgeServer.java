package galgeleg;
import java.rmi.Naming;

public class GalgeServer {

    public static void main(String[] arg) throws Exception{

        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        java.rmi.registry.LocateRegistry.createRegistry(2000);
        Naming.rebind("rmi://localhost:2000/Galgespil", galgeLogik);

        System.out.println("Galgeserver er registreret i NameRegistry");
        System.out.println("Server is running..\n\n");
    }
}
