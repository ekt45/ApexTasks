trigger CaseTrigger on Case (before insert, before update, after insert, after update, after delete, after undelete) {
    
    //if(UpdatePriorityHandler.hasSObjectField('prioridad__c', Trigger.new[0])){
    if(Trigger.isBefore){
        if(Trigger.isInsert){
           CaseHandler.updatePriority(null,Trigger.new); //Inserto la nueva prioridad
        }
         else if(Trigger.isUpdate){
            CaseHandler.updatePriority(Trigger.old,Trigger.new); // Actualizo la nueva prioridad asegurándome de que el tipo de caso no es el mismo al que se actualiza
         }
    }
    else if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            CaseHandler.updateAccountDescription(Trigger.new); //Actualizo descripción
        }
        else if (Trigger.isDelete) {
            CaseHandler.emailSender(true,Trigger.old);  //Envío email al owner - Si es delete, es true, si es undelete, es false
        }
        else if (Trigger.isUndelete) {
            CaseHandler.emailSender(false,Trigger.new); //Lo mismo que el delete
        }
    }
}