package galgeleg;

import javax.xml.ws.Endpoint;

public class GalgeServer {
    public static void main(String[] arg) throws Exception{

        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        System.out.println("Publicerer Galgeleg via SOAP");
        Endpoint.publish("http://[::]:9898/galgespil", galgeLogik);
        System.out.println("Galgeleg server is running..\n\n");


        UserAuthImpl userAuthImpl = new UserAuthImpl();
        System.out.println("Publicerer UserAuth via SOAP");
        Endpoint.publish("http://[::]:9999/userauth", userAuthImpl);
        System.out.println("UserAuth server is running...\n\n");

    }
}
