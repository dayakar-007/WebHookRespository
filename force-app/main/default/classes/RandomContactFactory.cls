public class RandomContactFactory {
   public static List<Contact>generateRandomContacts(Integer number_of_contacts,String last_name)
   {
        List<Contact> conList = new List<Contact>();
        for(Integer i=0;i<number_of_contacts;i++)
        {
            Contact con =new Contact(FirstName='Test'+i,LastName='lastname');
            conList.add(con);
        }
        return conList;
   }
}