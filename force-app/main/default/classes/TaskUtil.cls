public class TaskUtil {
    public static String getTaskPriority(String leadState) {
        if(String.isBlank(leadstate) || leadstate.length()>2)
        {
            return null;
        }
        if(leadstate=='CA')
        {
            return 'High';
        }
        return 'Normal';


    }
        // Validate input
}