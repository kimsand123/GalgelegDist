package server;

import brugerautorisation.data.Bruger;
import brugerautorisation.transport.soap.Brugeradmin;
import interfaces.IUserAuth;

import javax.jws.WebService;
import javax.xml.namespace.QName;
import javax.xml.ws.Service;
import java.net.URL;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

@WebService(endpointInterface = "interfaces.IUserAuth")
public class UserAuthImpl extends UnicastRemoteObject implements IUserAuth {

    Brugeradmin ba;

    public UserAuthImpl() throws RemoteException {
        ba = getUserAdmin();
    }

    private Brugeradmin getUserAdmin() {
        try {
            URL url = new URL("http://javabog.dk:9901/brugeradmin?wsdl");
            QName qName = new QName("http://soap.transport.brugerautorisation/", "BrugeradminImplService");
            Service service = Service.create(url, qName);

            Brugeradmin ba = service.getPort(Brugeradmin.class);
            return ba;
        } catch(Exception e) {
            System.out.println("UserAuthImpl.java: Something went wrong - " + e.getMessage());
            System.out.println("Full stack:" + e.getStackTrace().toString());
            return null;
        }
    }

    public boolean login(String username, String password) {
            if(ba != null) {
                Bruger user = ba.hentBruger(username, password);
                System.out.println("* * * * * * * * * *");
                System.out.println("User: " + user.brugernavn + " signed in with the password: " + user.adgangskode + "");
                return true;
            } else {
                System.out.println("UserAdmin was not gathered...");
                return false;
            }
    }

    @Override
    public Bruger getUser(String username) {
        if(ba != null) {
            Bruger user = ba.hentBrugerOffentligt(username);
            System.out.println("Public user: " + user.fornavn + " " + user.efternavn + " from " + user.studeretning + " was fetched");
            System.out.println("* * * * * * * * * *\n\n");

            return user;
        } else {
            System.out.println("No public user fetched");
            return null;
        }
    }
}
