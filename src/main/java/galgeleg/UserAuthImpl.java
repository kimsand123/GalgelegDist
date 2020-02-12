package galgeleg;

import javax.jws.WebService;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.MalformedURLException;
import java.net.URL;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

@WebService(endpointInterface = "galgeleg.IUserAuth")
public class UserAuthImpl extends UnicastRemoteObject implements IUserAuth {

    protected UserAuthImpl() throws RemoteException {
    }

    public boolean login(String username, String password) throws MalformedURLException {
        URL url = new URL("http://javabog.dk:9901/brugeradmin?wsdl");
        QName qName = new QName("http://soap.transport.brugerautorisation/", "BrugeradminImplService");
        Service service = Service.create(url, qName);

        try {
            Brugeradmin ba = service.getPort(Brugeradmin.class);
            Bruger user = ba.hentBruger(username, password);
            System.out.println("User: " + user.brugernavn + " signed in with the password: " + user.adgangskode);
            return true;
        } catch(Exception e) {
            return false;
        }
    }
}
