public class FlowActions {
    public class FlowInput{
        @InvocableVariable(required=true)
        public String input;
        
        public FlowInput(String input)
        {
            this.input = input;
        }
    }
    public class FlowOut{
        @InvocableVariable(required=true)
        public String output;
        public FlowOut(String output)
        {
            this.output = output;
        }
        
    }
    @InvocableMethod(label='Process Data' description='Processes input and returns processed value')
    public static void processRequest(List<String> name)
    {
        /*List<FlowOut> result = new List<FlowOut>();
        for(FlowInput flow:flowInputs)
        {
            result.add(new FlowOut(flow.input+'Cloud Odyssey'));
        }
        return result;*/
        System.debug(name);
    }
}