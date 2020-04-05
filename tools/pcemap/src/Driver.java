public class Driver {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.out.println("Usage: pcemap in.tmx out.bin");
            return;
        }
        MapReader reader = new MapReader(args[0]);
        reader.outputMap(args[1]);
    }
}
