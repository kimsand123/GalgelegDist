package galgeleg;
import java.rmi.Naming;

public class GalgeServer {
    public static void main(String[] arg) throws Exception{
        java.rmi.registry.LocateRegistry.createRegistry(2000);

        IGalgeLogik galgelogik = new GalgeLogikImpl();
        Naming.rebind("rmi://localhost:2000/Galgespil", galgelogik);
        System.out.println("Galgeserver er registreret i NameRegistry");
    }
}
