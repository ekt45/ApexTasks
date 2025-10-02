public with sharing class CaseHandler {
    //Comprueba si existe el campo prioridad en el caso
    public static boolean hasSObjectField(String fieldName, SObject so) {
        return so.getSobjectType()
            .getDescribe()
            .fields.getMap()
            .keySet()
            .contains(fieldName);
    }
    
    //Cambio el campo prioridad del caso en base al tipo
    public static void updatePriority(List<Case> Oldcases, List<Case> cases) {
        if(hasSObjectField('Prioridad__c', cases[0])){
            for (integer i = 0; i < cases.size(); i++) {
                if (
                    (Oldcases != null && Oldcases[i].Type == cases[i].Type) || cases[i].Prioridad__c != null
                ) {
                    continue;
                }
                
                switch on cases[i].Type {
                    when 'Mechanical' {
                        cases[i].Prioridad__c = 'Alta';
                    }
                    when 'Electrical' {
                        cases[i].Prioridad__c = 'Media';
                    }
                    when 'Electronic' {
                        cases[i].Prioridad__c = 'Baja';
                    }
                    when 'Sructural' {
                        cases[i].Prioridad__c = 'Media';
                    }
                    when 'Other' {
                        cases[i].Prioridad__c = 'Revisar';
                    }
                    when else {
                        cases[i].Prioridad__c = 'Baja';
                    }
                }
            }
        }
    }
    
    //Configuro la descripcion de la cuenta en base a la prioridad del caso
    public static void updateAccountDescription(List<Case> cases) {
        Map<id, List<Case>> relatedAccounts = new Map<id, List<Case>>();
        List<Account> updatedCases = new List<Account>();
        
        //Mapa de relación entre cuenta y casos
        for (Case c : cases) {
            if (relatedAccounts.containsKey(c.AccountId)) {
                relatedAccounts.get(c.AccountId).add(c);
            } else {
                relatedAccounts.put(c.AccountId, new List<Case>{ c });
            }
        }
        
        //Cogemos la prioridad del caso de cada cuenta mas reciente y actualizamos la descripcion de la cuenta en base al caso
        for (Account a : [SELECT Id, Description FROM Account WHERE Id IN :relatedAccounts.keySet()]) {
            List<Case> relatedCases = relatedAccounts.get(a.Id);
            Case mostRecentCase = relatedCases[0];
            
            for (Case c : relatedCases) {
                if (c.CreatedDate > mostRecentCase.CreatedDate) {
                    mostRecentCase = c;
                }
            }
            switch on mostRecentCase.Prioridad__c {
                when 'Alta' {
                    a.Description =
                        'Tiene un caso que tiene prioridad alta cuyo asunto es: ' +
                        mostRecentCase.Subject;
                }
                when 'Media' {
                    a.Description =
                        'Tiene un caso que tiene prioridad media cuyo asunto es: ' +
                        mostRecentCase.Subject;
                }
                when 'Baja' {
                    a.Description =
                        'Tiene un caso que tiene prioridad baja cuyo asunto es: ' +
                        mostRecentCase.Subject;
                }
                when 'Revisar' {
                    a.Description =
                        'Tiene un caso que tiene prioridad revisar cuyo asunto es: ' +
                        mostRecentCase.Subject;
                }
                when else {
                    a.Description =
                        'Tiene un caso que tiene prioridad está sin definir cuyo asunto es: ' +
                        mostRecentCase.Subject;
                }
            }
            updatedCases.add(a);
        }
        
        if (!updatedCases.isEmpty()) {
            update updatedCases;
        }
    }
    
    //Envia email al owner
    public static void emailSender(boolean isDeleted,List<Case> cases) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        string message = isDeleted ? 'eliminado' : 'reinsertado';
        for (Case c : cases) {
            User owner = [SELECT Name, Email FROM User WHERE Id = :c.OwnerId];
            
            if(owner.Email == null){
                //System.debug('email nulo ?');
                continue;
            }
            
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            email.setSubject('Nuevo caso ' + message);
            email.setPlainTextBody('Buenos días ' + owner.Name + ' se ha ' + message + ' un caso con el asunto: ' + c.Subject + '.');
            email.setToAddresses(new List<String>{owner.Email});
            emails.add(email);
        }
        Messaging.sendEmail(emails);
    }
}