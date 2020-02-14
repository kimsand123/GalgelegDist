package client;

import java.util.ArrayList;
import java.util.List;

public class HangManGraphics {

    List<String> hangMen = new ArrayList<String>();

    String man1 =   "..xxxxxxxx...\n"+
            "..x......x...\n"+
            "..x.....x.x..\n"+
            "..x......x...\n"+
            "..x..........\n"+
            "..x..........\n"+
            "..x..........\n"+
            "..x..........\n"+
            "..x..........\n"+
            "..x..........\n";

    String man2 =   "..xxxxxxxx...\n"+
            "..x......x...\n"+
            "..x.....x.x..\n"+
            "..x......x...\n"+
            "..x......X...\n"+
            "..x......x...\n"+
            "..x......x...\n"+
            "..x......x...\n"+
            "..x..........\n"+
            "..x..........\n";

    String man3 =   "..xxxxxxxx...\n"+
            "..x......x...\n"+
            "..x.....x.x..\n"+
            "..x......x...\n"+
            "..x...x..X...\n"+
            "..x....xxx...\n"+
            "..x......x...\n"+
            "..x......x...\n"+
            "..x..........\n"+
            "..x..........\n";

    String man4 =   "..xxxxxxxx...\n"+
            "..x......x...\n"+
            "..x.....x.x..\n"+
            "..x......x...\n"+
            "..x...x..X..x\n"+
            "..x....xxxxx.\n"+
            "..x......x...\n"+
            "..x......x...\n"+
            "..x..........\n"+
            "..x..........\n";


    String man5 =   "..xxxxxxxx...\n"+
            "..x......x...\n"+
            "..x.....x.x..\n"+
            "..x......x...\n"+
            "..x...x..X..x\n"+
            "..x....xxxxx.\n"+
            "..x......x...\n"+
            "..x......x...\n"+
            "..x.....x....\n"+
            "..x....x.....\n";

    String man6 =   "..xxxxxxxx...\n"+
                    "..x......x...\n"+
                    "..x.....x.x..\n"+
                    "..x......x...\n"+
                    "..x...x..X..x\n"+
                    "..x....xxxxx.\n"+
                    "..x......x...\n"+
                    "..x......x...\n"+
                    "..x.....x.x..\n"+
                    "..x....x...x.\n";


    public HangManGraphics(){
        hangMen.add(man1);
        hangMen.add(man2);
        hangMen.add(man3);
        hangMen.add(man4);
        hangMen.add(man5);
        hangMen.add(man6);
    }

    public String getTheMan (int whichOne){
        return hangMen.get(whichOne);
    }







}
