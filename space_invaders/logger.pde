import java.text.SimpleDateFormat;
import java.util.Date;

static class Logger{
    static void log(String level, String[] message){
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ssZ");
        String asctime = simpleDateFormat.format(new Date());
        println(String.format("%s :: %s :: %s", asctime, level, String.join(" ", message)));
    }

    static void debug(String ...message){
        log("debug", message);
    }

    static void info(String ...message){
        log("info ", message);
    }

    static void error(String ...message){
        log("error", message);
        System.exit(1);
    }
}
