import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class solution {
    public static void main(String[] args) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
        while (true) {
            String line = null;
            try {
                line = reader.readLine();
            } catch (IOException ex) {
                break;
            }

            if (line == null) {
                break;
            }

            line = line.trim();
            if (line.length() == 0) {
                continue;
            }

            System.out.println(line);
        }
    }
}
