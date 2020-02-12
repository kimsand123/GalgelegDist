package galgeleg;

import javax.jws.WebMethod;
import javax.jws.WebService;

@WebService
public interface IUserAuth {
    @WebMethod
    boolean login(String username, String password);


}
