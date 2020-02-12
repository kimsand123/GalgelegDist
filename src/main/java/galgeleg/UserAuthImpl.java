package galgeleg;

import brugerautorisation.data.Bruger;
import brugerautorisation.transport.soap.Brugeradmin;

import javax.jws.WebService;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.URL;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;
import java.util.Iterator;

@WebService(endpointInterface = "galgeleg.IUserAuth")
public class UserAuthImpl extends UnicastRemoteObject implements IUserAuth {

    protected UserAuthImpl() throws RemoteException {
    }

    public boolean login(String username, String password) {
        try {

            URL url = new URL("http://javabog.dk:9901/brugeradmin?wsdl");
            QName qName = new QName("http://soap.transport.brugerautorisation/", "BrugeradminImplService");
            Service service = Service.create(url, qName);

            Iterator iterator = service.getPorts();

            while (iterator.hasNext()) {
                System.out.println("Port available: " + iterator.next().toString());
            }
            System.out.println("More info: " + service.getWSDLDocumentLocation().toString());
            System.out.println("More info: " + service.getServiceName().toString());

            Brugeradmin ba = service.getPort(Brugeradmin.class);
            Bruger user = ba.hentBruger(username, password);
            System.out.println("User: " + user.brugernavn + " signed in with the password: " + user.adgangskode);
            return true;
        } catch(Exception e) {
            System.out.println("UserAuthImpl.java: Something went wrong - " + e.getMessage());
            System.out.println("Full stack:" + e.getStackTrace().toString());
            return false;
        }
    }
}
