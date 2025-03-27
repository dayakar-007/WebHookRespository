trigger UpdateContactPhone on Account (after update) {

    List<Contact> updateContactPhone = new List<Contact>();
    for (Account newAcc : Trigger.new) {
        Account oldAcc = Trigger.oldMap.get(newAcc.Id);
        if (newAcc.Phone != oldAcc.Phone) {
            List<Contact> conList = [SELECT Id, Phone FROM Contact WHERE AccountId = :newAcc.Id];
            for (Contact con : conList) {
                con.Phone = newAcc.Phone;
                updateContactPhone.add(con);
            }
        }
    }
    if (!updateContactPhone.isEmpty()) {
        update updateContactPhone;
    }
}