package server;

import javax.xml.ws.Endpoint;

public class GameServer {
    public static void main(String[] args) throws Exception{
        String portNumber = "9898";

        if (args.length == 0 || args[0] == null) {
            System.out.println("You have forgotten to add your desired config");
            System.out.println("-running default config:");
            System.out.println("[gameServerPort: '9898'");
        } else if (args.length > 1) {
            System.out.println("Argument list too long, only one port number is needed ex. '9898'");
            System.exit(0);
        } else if (! args[0].matches("\\b([0-9]){2,4}\\b")){
            System.out.println("You have entered a wrong port number, must be 2-4 digits ex. '9898'");
            System.exit(0);
        } else {
            portNumber = args[0];
        }

        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        System.out.println("Publishing GameServer via SOAP");
        Endpoint.publish("http://[::]:" + portNumber + "/galgespil", galgeLogik);
        System.out.println("\n\nGameServer is now running on port " + portNumber + "..\n\n");
    }
}
