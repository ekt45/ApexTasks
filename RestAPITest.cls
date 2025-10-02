@isTest
public class RestAPITest {

    //Test para get
    public static testMethod void getTest(){

        Case c = new Case();
        c.Subject = 'Test';
        c.Description = 'Test';
        c.Origin = 'Email';
        insert c;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/cases/' + c.Id;
        req.httpMethod = 'GET';

        //Asigno el request y response a la clase RestContext
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        CaseRestController.getCase();
        Test.stopTest();

        System.Assert.areEqual(200, res.statusCode); //Compruebo que ha sido ok
        //System.Assert.areEqual(404, res.statusCode);
    }

    //Test para post
    public static testMethod void postTest(){
        
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        //Establezco url, el método y el body de la solicitud HTTP
        req.requestURI = '/services/apexrest/cases';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"Subject":"Test","Description":"Test","Origin":"Email"}');

        //Asigno el request y response a la clase RestContext
        RestContext.request = req;
        RestContext.response = res;

    
        Test.startTest();
        CaseRestController.createCase(); //Llamo al método que quiero testear 
        Test.stopTest();

        System.Assert.areEqual(201, res.statusCode); //Compruebo que se ha creado correctamente
        //System.Assert.areEqual(400, res.statusCode);
        //System.Assert.areEqual(403, res.statusCode);
    }

    //Test para Patch
    public static testMethod void patchTest(){

        Case c = new Case();
        c.Subject = 'Test';
        c.Description = 'Test';
        c.Origin = 'Email';
        insert c;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/cases/' + c.Id;
        req.httpMethod = 'PATCH';
        req.requestBody = Blob.valueOf('{"Subject":"Test25"}');

        //Asigno el request y response a la clase RestContext
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        CaseRestController.updateCustomCase();
        Test.stopTest();

        System.Assert.areEqual(200, res.statusCode); //Compruebo que esta OK
        //System.Assert.areEqual(400, res.statusCode);
        //System.Assert.areEqual(403, res.statusCode);
    }

    //Test para delete
    public static testMethod void deleteTest(){

        Case c = new Case();
        c.Subject = 'Test';
        c.Description = 'Test';
        c.Origin = 'Email';
        insert c;

        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/cases/' + c.Id;
        req.httpMethod = 'DELETE';

        //Asigno el request y response a la clase RestContext
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        CaseRestController.deleteCase();
        Test.stopTest();

        System.Assert.areEqual(204, res.statusCode); //Compruebo que se ha eliminado correctamente
    }
}