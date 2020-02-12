package galgeleg;

import javax.jws.WebMethod;
import javax.jws.WebService;
import java.net.MalformedURLException;

@WebService
public interface IUserAuth {
    @WebMethod
    boolean login(String username, String password) throws MalformedURLException;


}
