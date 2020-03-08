package server;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mashape.unirest.http.HttpResponse;
import com.mashape.unirest.http.JsonNode;
import com.mashape.unirest.http.Unirest;
import com.mashape.unirest.http.exceptions.UnirestException;
import interfaces.IEntryPoint;
import interfaces.IGalgeLogik;

import io.javalin.Javalin;
import io.javalin.http.Context;
import org.json.JSONObject;

import javax.jws.WebService;
import javax.xml.namespace.QName;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import javax.xml.ws.Service;
import java.util.List;
import java.util.Map;

@WebService(endpointInterface = "interfaces.IEntryPoint")
public class EntryPointImpl implements IEntryPoint {

    //Setting up the clientpart of this service.
    // Connection to the gameserver on Jacobs machine.
    static final String nameSpace = "http://server/";

    private IGalgeLogik spil;
    private List<String> inGamers = new ArrayList<String>();
    private String authURL = "";
    private String distServer = "130.225.170.204";
    private String localhostServer = "localhost";

    // Must be here because of WebService requirements
    public EntryPointImpl() throws MalformedURLException {
        new EntryPointImpl(9875,9898, 8970, false);
    }

    public EntryPointImpl(int entryPort, int gamePort, int authPort, boolean isRunningLocal) throws MalformedURLException {
        super();

        // Setup urls for entrypoint
        String entryPointIp = isRunningLocal ? localhostServer + entryPort : distServer + ":" + entryPort;
        String chosenGameURL = isRunningLocal ? "http://" + localhostServer + ":" + gamePort + "/galgespil?wsdl" : "http://" + distServer + ":" + gamePort + "/galgespil?wsdl";
        authURL = isRunningLocal ? "http://" + localhostServer + ":" + authPort +"/auth/" : "http://" + distServer + ":" + authPort +"/auth";

        URL gameUrl = new URL(chosenGameURL);
        QName gameQname = new QName(nameSpace, "GalgeLogikImplService");
        Service gameService = Service.create(gameUrl, gameQname);
        spil = gameService.getPort(IGalgeLogik.class);

        //Setting up Javalin Endpoints
        Javalin restServer = Javalin.create().start(entryPort);

        //Til debugging or logging, should probably write to a file instead.
        restServer.before(ctx -> {
            // uncomment because of print-spamming
            //System.out.println("EntryPointServer got request " + ctx.method() + " on url " + ctx.url() + " with parameters " + ctx.queryParamMap() + ", formParam: " + ctx.formParamMap() + ", and body:" + ctx.body() + "\n");
        });

        restServer.get("/", ctx -> ctx.contentType("text/html; charset=utf-8")
                .result("<html><body>Velkommen til Online-Galgeleg<br/>\n<br/>\n" +
                        "Du skulle tage at logge ind og spille med. Der findes en consol og en flutter app til at spille spillet"));
        // Enten den her organisation


        restServer.get("bogstaver/", ctx ->  ctx.contentType("text/html; charset=utf-8")
                .result("<html><body>bogstaver/<br/>\n<br/>\n" +
                        "<a href=\"http://"+ entryPointIp +"/bogstaver/gaet/\">  HUSK \"token\":\"value\":\"letter\":\"value\" i body som formdata. Gætter på et bogstav<br/>\n</br>\n"+
                        "<a href=\"http://"+ entryPointIp +"/bogstaver/brugte/\">   HUSK \"token\":\"value\" i body som formdata. Returnerer de brugte bogstaver<br/>\n</br>\n"+
                        "<a href=\"http://"+ entryPointIp +"/bogstaver/antalforkerte/\">  HUSK \"token\":\"value\" i body som formdata. Returnerer antal forkerte gæt om<br/>\n</br>\n"+
                        "<a href=\"http://"+ entryPointIp +"/bogstaver/ersidstekorrekt/\">   HUSK \"token\":\"value\" i body som formdata. Returnerer om det sidste bogstav var korrekt <br/>\n</br>\n"
                ));
        restServer.post("bogstaver/gaet/", ctx -> restGaetBogstav(ctx));
        restServer.get("bogstaver/brugte/", ctx -> restBrugteBogstaver(ctx));
        restServer.get("bogstaver/antalforkerte/", ctx -> restAntalForkerteBogstaver(ctx));
        restServer.get("bogstaver/ersidstekorrekt/", ctx -> restSidsteBogstavKorrekt(ctx));

        restServer.get("ordet/", ctx ->  ctx.contentType("text/html; charset=utf-8")
                        .result("<html><body>ordet/<br/>\n<br/>\n" +
                                "<a href=\"http://"+ entryPointIp +"/ordet/ord/\">  HUSK \"token\":\"value\" i body som formdata. Returnerer ordet der bliver spillet om<br/>\n</br>\n"+
                                "<a href=\"http://"+ entryPointIp +"/ordet/synligt/\">   HUSK \"token\":\"value\" i body som formdata. Returnerer det der er synligt af ordet indtil videre<br/>\n</br>\n"
                                ));
        restServer.get("ordet/ord/", ctx -> restOrdet(ctx));
        restServer.get("ordet/synligt/", ctx -> restSynligtOrd(ctx));

        restServer.get("spillet/", ctx ->  ctx.contentType("text/html; charset=utf-8")
                .result("<html><body>spillet/<br/>\n<br/>\n" +
                        "<a href=\"http://"+ entryPointIp +"/spillet/vundet/\">  HUSK \"token\":\"value\" i body som formdata. Returnerer om spillet er vundet<br/>\n</br>\n"+
                        "<a href=\"http://"+ entryPointIp +"/spillet/tabt/\">   HUSK \"token\":\"value\" i body som formdata. Returnerer om spillet er tabt<br/>\n</br>\n"
                ));
        restServer.get("spillet/vundet/", ctx -> restVundet(ctx));
        restServer.get("spillet/tabt/", ctx -> restTabt(ctx));
        restServer.post("spillet/nulstil/", ctx -> {
            System.out.println("token: " + ctx.formParam("token") + "\n");
            restNulstil(ctx);
        });

      /*  restServer.get("auth/", ctx -> {
        });*/
        restServer.get("auth/", ctx ->  ctx.contentType("text/html; charset=utf-8")
                .result("<html><body>auth/<br/>\n<br/>\n" +
                        "<a href=\"http://"+ entryPointIp +"/auth/logon/\">  HUSK \"username\":\"value\",\"password\":\"value\" i body som formdata. Logger på spillet<br/>\n</br>\n"+
                        "<a href=\"http://"+ entryPointIp +"/auth/logoff/\">   HUSK \"token\":\"value\" i body som formdata. Logger af spillet<br/>\n</br>\n"
                ));
        restServer.post("auth/logoff/", ctx -> {
            System.out.println("token: " + ctx.formParam("token") + "\n");
            restLogOff(ctx);
        });
        restServer.post("auth/logon/", ctx -> {
            System.out.println("username" + ctx.formParam("username") + "  password " + ctx.formParam("password") + "\n");
            restLogOn(ctx);
        });


    }

    //SOAP methods
    public ArrayList<String> epGetBrugteBogstaver(String token) {
        System.out.println("getbrugtebogstaver token: "+token + "\n");
        if (checkGamerToken(token)) {
            return spil.getBrugteBogstaver();
        }
        return null;
    }

    public String epGetSynligtOrd(String token) {
        System.out.println("getsynligtord token: "+token + "\n");
        if (checkGamerToken(token)) {
            return spil.getSynligtOrd();
        }
        return null;
    }

    public String epGetOrdet(String token) {
        System.out.println("getordet token: "+token + "\n");
        if (checkGamerToken(token)) {
            return spil.getOrdet();
        }
        return null;
    }

    public int epGetAntalForkerteBogstaver(String token) {
        System.out.println("antalforkertebogstaver token: "+token + "\n");
        if (checkGamerToken(token)) {
            return spil.getAntalForkerteBogstaver();
        }
        return -1;
    }

    public int epErSidsteBogstavKorrekt(String token) {
        System.out.println("ersidstebogstavkorrekt token: "+token + "\n");

        if (checkGamerToken(token)) {
            boolean janej;
            janej = spil.erSidsteBogstavKorrekt();
            if (janej) {
                return 1;
            } else {
                return 0;
            }
        } else
            return -1;
    }

    public int epErSpilletVundet(String token) {
        System.out.println("erspilletvundet token: "+token + "\n");
        if (checkGamerToken(token)) {
            boolean janej;

            janej = spil.erSpilletVundet();
            System.out.println("Er spillet vundet " + janej + "\n");
            if (janej) {
                return 1;
            } else {
                return 0;
            }
        }
        return -1;
    }

    public int epErSpilletTabt(String token) {
        System.out.println("erspillettabt token: "+token + "\n");
        if (checkGamerToken(token)) {
            boolean janej;
            janej = spil.erSpilletTabt();
            System.out.println("Er spillet tabt " + janej + "\n");
            if (janej) {
                return 1;
            } else {
                return 0;
            }
        }
        return -1;
    }

    public void epNulstil(String token) {
        System.out.println("epNulstil token: "+token);
        if (checkGamerToken(token)) {
            spil.nulstil();
        }
    }

    public void epGætBogstav(String token, String letter) {
        System.out.println("gætbogstav token: "+token + " bogstav: "+ letter + "\n");
        if (checkGamerToken(token)) {
            spil.gætBogstav(letter);
        }
    }

    public void logStatus(String token) {
        System.out.println("getbrugtebogstaver token: "+token + "\n");

        if (checkGamerToken(token)) {
            spil.logStatus();
        }
    }

    public void hentOrdFraDR(String token) {
        if (checkGamerToken(token)) {
            spil.hentOrdFraDR();
        }
    }

    public String epLogOff(String token) {
        System.out.println("logoff token: " + token + "\n");
        inGamers.remove(token);
        return "Du har nu logget af";
    }

    public String epLogOn(String username, String password) throws UnirestException {
        System.out.println("logon username: "+username + " password "+ password + "\n");

        String body = "{\"username\":\"" + username + "\",\"password\":\"" + password + "\"}\n";

        HttpResponse<JsonNode> response = Unirest.post(authURL)
                .body(body)
                .asJson();
        JSONObject json = response.getBody().getObject();

        String token = json.getString("token");
        System.out.println("gathered token: " + token);

        if (token != null) {
            inGamers.add(token);
        }
        return (token);
    }

    private boolean checkGamerToken(String token) {
        return inGamers.contains(token);
    }

    // REST methods
    private void restBrugteBogstaver(Context ctx) {
        String token = ctx.queryParam("token");
        List<String> brugteBogstaver;
        brugteBogstaver = epGetBrugteBogstaver(token);
        if (brugteBogstaver != null) {
            ctx.result("Her er de brugte bogstaver ").json(brugteBogstaver);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted

            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /brugtebogstaver/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restOrdet(Context ctx) {
        String token = ctx.queryParam("token");
        String ordet;
        ordet = epGetOrdet(token);
        if (ordet != null) {
            ctx.json(ordet);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted

            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /ordet/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restSynligtOrd(Context ctx) {
        String token = ctx.queryParam("token");
        String synligtOrd;
        synligtOrd=epGetSynligtOrd(token);
        if(synligtOrd != null){
            ctx.json(synligtOrd);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted

            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /ordet/\\033[3mvalidToken\\033[0m");
        }

    }

    private void restAntalForkerteBogstaver(Context ctx) {
        String token = ctx.queryParam("token");
        int antal = epGetAntalForkerteBogstaver(token);
        if (antal > -1) {
            ctx.json(antal);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted

            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /AntalForkerteBogstaver/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restSidsteBogstavKorrekt(Context ctx) {
        String token = ctx.queryParam("token");
        int korrekt = epErSidsteBogstavKorrekt(token);
        //TODO clients skal håndtere en int -1=ikke valideret, 0=falsk, 1=true
        if (korrekt > -1) {
            ctx.json(korrekt);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted

            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restVundet(Context ctx) {
        String token = ctx.queryParam("token");
        int vundet = epErSpilletVundet(token);
        if (vundet > -1) {
            ctx.json(vundet);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted
            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restTabt(Context ctx) {
        String token = ctx.queryParam("token");
        int tabt = epErSpilletTabt(token);
        if (tabt > -1) {
            ctx.json(tabt);
        } else {
            //TODO depending on which REST organisation the feedback should be adapted
            ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restGaetBogstav(Context ctx) {
        String body = ctx.body();
        ObjectMapper mapper = new ObjectMapper();

        try {
            // convert JSON string to Map
            Map<String, String> map = mapper.readValue(body, Map.class);

            String token = map.get("token");
            String letter = map.get("letter");

            //TODO interface til gætBogstav skal returnere om det gik godt eller dårligt med token check.
            if (checkGamerToken(token)) {
                epGætBogstav(token, letter);
            } else {
                //TODO depending on which REST organisation the feedback should be adapted
                ctx.status(401).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
            }

        } catch (IOException e) {
            e.printStackTrace();
            ctx.status(500).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restLogOn(Context ctx) throws UnirestException {
        String body = ctx.body();
        ObjectMapper mapper = new ObjectMapper();

        try {
            // convert JSON string to Map
            Map<String, String> map = mapper.readValue(body, Map.class);

            String username = map.get("username");
            String password = map.get("password");

            String token = epLogOn(username, password);

            if (!token.equals(null)) {
                ctx.json(token);
            } else {
                //TODO depending on which REST organisation the feedback should be adapted
                ctx.status(403).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
            }

        } catch (IOException e) {
            e.printStackTrace();
            ctx.status(500).result("Ikke Autoriseret. Du skal bruge en valideret token samt \n syntaksen /SidsteBogstavKorrekt/\\033[3mvalidToken\\033[0m");
        }
    }

    private void restLogOff(Context ctx) {
        String body = ctx.body();
        ObjectMapper mapper = new ObjectMapper();

        try {
            // convert JSON string to Map
            Map<String, String> map = mapper.readValue(body, Map.class);

            String token = map.get("token");

            String besked = epLogOff(token);

            ctx.status(200).result(besked);

        } catch (IOException e) {
            e.printStackTrace();
            ctx.status(500).result("Medsend venligst token, for at logge ud");
        }
    }

    private void restNulstil(Context ctx) {
        String body = ctx.body();
        ObjectMapper mapper = new ObjectMapper();

        try {
            // convert JSON string to Map
            Map<String, String> map = mapper.readValue(body, Map.class);

            String token = map.get("token");

            epNulstil(token);

            ctx.status(200);

        } catch (IOException e) {
            e.printStackTrace();
            ctx.status(500).result("Medsend venligst token, for at nulstille spillet");
        }
    }
}






