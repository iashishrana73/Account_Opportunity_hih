/**
 * Sample Trigger Handler for Account
 */
public class AccountHandler implements ITrigger 
{ 
  Map<Id, List<opportunity>> oppMap = new Map<Id, List<Opportunity>>();
  List<Opportunity> oppList = new List<Opportunity>();
  set<Id> accIds = new set<Id>();
   
    public void bulkAfter(){
  		system.debug('--- bulkAfter is called');
       //List<Account> accList = (List<Account>) Trigger.new;
        map<id,Account> accMap = (Map<id,Account>) Trigger.oldMap;
        if(Trigger.isUpdate){
            for(Account acc: (List<Account>) Trigger.new){
                if(acc.AnnualRevenue != null && acc.AnnualRevenue != accMap.get(acc.Id).AnnualRevenue){
                    accIds.add(acc.Id);
                }
            }
            if(!accIds.isEmpty()){
                for(Opportunity opp: [SELECT Id, AccountId,Amount FROM Opportunity WHERE AccountId IN: accIds]){
                    System.debug('Oppourtunity Id: ' + opp.Amount);
                    if(oppMap.containsKey(opp.AccountId)){
                        oppMap.get(opp.AccountId).add(opp);
                    }
                    else{
                        oppMap.put(opp.AccountId, new List<Opportunity>()); 
                        //oppList.add(opp);
                        oppMap.get(opp.AccountId).add(opp);                        
                    }
                }  
                 System.debug('Oppourtunity Map: ' + oppMap);
            }
        }
    }
     public void afterUpdate(SObject oldSo, SObject so){
        Account acc_new_List = (Account) so;
        Integer count=0;
        Integer Final_op = 0;
        if(oppMap.containsKey(acc_new_List.Id)){
            count = oppMap.get(acc_new_List.Id).size();
            Final_op = acc_new_List.AnnualRevenue.intValue() / count;
            for(Opportunity opp: oppMap.get(acc_new_List.Id)){
                if(opp.Amount != Final_op){
                    opp.Amount = Final_op;
                     System.debug('Oppourtunity Id with amount: ' + opp.Amount);
                    oppList.add(opp);
                }
            }

        }
  		system.debug('--- afterUpdate is called');      
    }
     public void andFinally(){
        if(!oppList.isEmpty()){
            update oppList;
        }
        system.debug('--- andFinally called');      
    }
    public void beforeInsert(SObject so){
  		system.debug('--- beforeInsert is called');      
    }
    public void beforeUpdate(SObject oldSo, SObject so){
  		system.debug('--- beforeUpdate is called');      
    }

    public void beforeDelete(SObject so){
  		system.debug('--- beforeDelete is called');      
    }

    public void afterInsert(SObject so){
  		system.debug('--- afterInsert is called');      
    }

    public void bulkBefore(){
  		system.debug('--- bulkbEfore is called');      
    }
    

    public void afterDelete(SObject so){
  		system.debug('--- afterDelete is called');      
    }
  

}