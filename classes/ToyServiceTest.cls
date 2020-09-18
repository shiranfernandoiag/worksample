@isTest
public class ToyServiceTest {
    
    @isTest
    static void testMatchFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/toys';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader('charset', 'UTF-8');
        req.addHeader('Accept', 'application/json');
        req.requestBody = Blob.valueOf('[{"name":"toy 1"}]');
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ToyService.doPost();
        Test.stopTest();

        String resBody = res.responseBody.toString();
        System.debug(resBody);
        System.assert(resBody.contains('Match found'));
    }

    @isTest
    static void testNoMatchFound() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/toys';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader('charset', 'UTF-8');
        req.addHeader('Accept', 'application/json');
        req.requestBody = Blob.valueOf('[{"name":"toy 16"}]');
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ToyService.doPost();
        Test.stopTest();

        String resBody = res.responseBody.toString();
        System.assert(resBody.contains('no toy match found'));
    }

    @isTest
    static void testBadRequest() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        req.requestURI = '/services/apexrest/toys';
        req.addHeader('Content-Type', 'application/json');
        req.addHeader('charset', 'UTF-8');
        req.addHeader('Accept', 'application/json');
        req.requestBody = Blob.valueOf('[{"name":"toy 16"]');
        req.httpMethod = 'POST';

        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
            ToyService.doPost();
        Test.stopTest();
        System.assertEquals(400, res.statusCode);
    }

    @TestSetup
    static void makeData(){
        List<Toy__c> toys = new List<Toy__c>();
        Toy__c t = new Toy__c(Name='Toy 1', Description__c='Test Toy One', Is_Available__c=true, Price__c=110);
        toys.add(t);
        t = new Toy__c(Name='Toy 2', Description__c='Test Toy Two', Is_Available__c=false, Price__c=120);
        toys.add(t);
        t = new Toy__c(Name='Toy 3', Description__c='Test Toy Three', Is_Available__c=true, Price__c=150);
        toys.add(t);
        t = new Toy__c(Name='Toy 4', Description__c='Test Toy Four', Is_Available__c=false, Price__c=210);
        toys.add(t);
        t = new Toy__c(Name='Toy 5', Description__c='Test Toy Five', Is_Available__c=true, Price__c=410);
        toys.add(t);

        insert toys;
    }

}
