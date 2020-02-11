package galgeleg;

import javax.xml.ws.Endpoint;

public class GalgeServer {



    public static void main(String[] arg) throws Exception{
        GalgeLogikImpl galgeLogik = new GalgeLogikImpl();
        System.out.println("Publicerer Galgeleg over SOAP");
        Endpoint.publish("http://[::]:9898/galgespil", galgeLogik);
        System.out.println("Server is running..\n\n");
    }
}
