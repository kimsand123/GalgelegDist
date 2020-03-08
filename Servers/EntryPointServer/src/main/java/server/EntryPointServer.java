package server;

import javax.xml.ws.Endpoint;
import java.net.ConnectException;
import java.net.MalformedURLException;


public class EntryPointServer {
    public static void main (String[] args) throws MalformedURLException {
        int entryRestPort = 9875;
        int entrySoapPort = 9876;
        int gamePort = 9898;
        int authPort = 8970;
        boolean isRunningLocal = false;

        // Handle different port options in run-time

        // If no arguments are here, run default
        if (args.length == 0) {
            System.out.println("You have forgotten to add your desired config");
            System.out.println("-running default config:");
            System.out.println("[entryRestPort: '9875', entrySoapPort: '9876' gamePort: '9898', authPort: '8970', isRunningLocal: 0]\n");

        } else if (args.length != 5) {
            // If arguments are not exactly 5
            if (args.length == 1 && args[0].matches("\\b([0-1])\\b")) {
                // If arguments are exactly 1
                isRunningLocal = args[0].equals("1");
            } else {
                System.out.println("Argument list is either too short or too long, you need 1 or 5 arguments:\n");
                System.out.println("java -jar [javafile] [entryRestPort] [entrySoapPort] [gamePort] [authPort] [isRunningLocal]");
                System.out.println("example: java -jar EntryPoint-1.0.jar 9875 9876 9898 8970 0\n");

                System.out.println("You can also choose just to run local with:");
                System.out.println("java -jar [javafile] [isRunningLocal]");
                System.out.println("example: java -jar EntryPoint-1.0.jar 1\n");
                System.exit(0);
            }

        } else {
            boolean entryRestOK = args[0].matches("\\b([0-9]){2,4}\\b");
            boolean entrySoapOK = args[1].matches("\\b([0-9]){2,4}\\b");
            boolean gameOK = args[2].matches("\\b([0-9]){2,4}\\b");
            boolean authOK = args[3].matches("\\b([0-9]){2,4}\\b");
            boolean isRunningLocalOK = args[4].matches("\\b([0-1])\\b");

            if (entryRestOK && entrySoapOK && gameOK && authOK && isRunningLocalOK) {
                entryRestPort = Integer.parseInt(args[0]);
                entrySoapPort = Integer.parseInt(args[1]);
                gamePort = Integer.parseInt(args[2]);
                authPort = Integer.parseInt(args[3]);
                isRunningLocal = args[4].equals("1");
            } else {
                System.out.println("You have entered the arguments wrong, please follow this:\n");
                System.out.println("java -jar [javafile] [entryRestPort] [entrySoapPort] [gamePort] [authPort] [isRunningLocal]");
                System.out.println("example: java -jar EntryPoint-1.0.jar 9875 9876 9898 8970 0\n");

                System.out.println("You can also choose just to run local with:");
                System.out.println("java -jar [javafile] [isRunningLocal]");
                System.out.println("example: java -jar EntryPoint-1.0.jar 1\n");
                System.exit(0);
            }
        }

        try {
            System.out.println("\nPublishing EntryPointserver via REST (locally: "+ isRunningLocal + ") on port: " + entryRestPort + "....\n");
            EntryPointImpl entryPoint = new EntryPointImpl(entryRestPort,gamePort, authPort, isRunningLocal);

            System.out.println("\nPublishing EntryPointserver via SOAP (locally: "+ isRunningLocal + ") on port: " + entrySoapPort + "....\n");
            Endpoint.publish("http://[::]:"+ entrySoapPort +"/entrypoint", entryPoint);

            System.out.println("\nEntryPointServer server is now running..\n\n");
        } catch (Exception e){
            System.out.println("Error: " + e.getMessage() + "\n");
            System.out.println("Are you sure you have started the AuthServer + GameServer before starting this?");
        }
    }

}
