global with sharing class CaseService {


    //Get 
    global static Case getCase(id CaseId) {
        return [SELECT Id, Subject, Description, Priority, Status, Owner.Name FROM Case WHERE Id = :CaseId];
    }

    //Post
    global static id createCase(string jsonString) {
        
        Case c = (Case)JSON.deserialize(jsonString, Case.class); 
        if (c.Subject == null || c.Subject == '' || c.Description == null || c.Description == '' || c.Origin == null || c.Origin == ''){
            //Lanzamos excepcion DML si los campos obligatorios no estan rellenados. PD si no lo lanzamos no salta la excepción, ya que se le asigna el valor por defecto
            throw new DmlException('Faltan campos requeridos');
        }
        if (!Schema.SObjectType.Case.isCreateable())throw new DmlException('Errores en los campos picklist');
        insert c;
        return c.Id;
    }

    //Patch
    global static id updateCase(id CaseId, string jsonString){
        Case caseToUpdate = (Case)JSON.deserialize(jsonString, Case.class); //No termino de entender el funcionamiento del método
        caseToUpdate.Id = CaseId;
        if (!Schema.SObjectType.Case.isUpdateable())throw new DmlException('Errores en los campos picklist');
        update caseToUpdate;
        return caseToUpdate.Id;
    }
    
    //Delete
    global static void deleteCase(id CaseId){
        delete [SELECT Id FROM Case WHERE Id = :CaseId];
    }
}