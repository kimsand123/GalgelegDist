package galgeleg;

import java.util.ArrayList;

public interface IGalgeLogik {
    ArrayList<String> getBrugteBogstaver();
    String getSynligtOrd();
    String getOrdet();
    int getAntalForkerteBogstaver();
    boolean erSidsteBogstavKorrekt();
    boolean erSpilletVundet();
    boolean erSpilletTabt();
    void nulstil();
    void gætBogstav(String bogstav);
    void logStatus();
}
