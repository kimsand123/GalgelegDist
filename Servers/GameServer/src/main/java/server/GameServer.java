package server;

import javax.xml.ws.Endpoint;

public class GameServer {
    public static void main(String[] arg) throws Exception{

        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        System.out.println("Publicerer Galgeleg via SOAP");
        Endpoint.publish("http://[::]:9898/galgespil", galgeLogik);
        System.out.println("Galgeleg server is running..\n\n");
    }
}
