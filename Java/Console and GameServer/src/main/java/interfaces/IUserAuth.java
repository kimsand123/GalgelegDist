package interfaces;

import brugerautorisation.data.Bruger;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public interface IUserAuth {
    @WebMethod
    boolean login(String username, String password);

    @WebMethod
    Bruger getUser(String username);
}
