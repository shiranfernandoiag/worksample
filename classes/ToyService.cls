@RestResource(urlMapping='/toys/*')
global with sharing class ToyService {
    
    @HttpPost
    global static void doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            List<ToyInquiry> inquiries = (List<ToyInquiry>) JSON.deserialize(req.requestBody.toString(), List<ToyInquiry>.class);

            Map<String, ToyInquiry> mapInquires = new Map<String, ToyInquiry>();
            for(ToyInquiry inq : inquiries) {
                mapInquires.put(inq.name.toLowerCase(), inq);
            }

            List<Toy> toys = new List<Toy>();
            for(Toy__c dbToy : [SELECT Name, Description__c, Is_Available__c, Price__c 
                                  FROM Toy__c WHERE Name IN :mapInquires.keySet()]) {
                Toy t = new Toy();
                t.name = dbToy.Name;
                t.description = dbToy.Description__c;
                t.isAvailable = dbToy.Is_Available__c;
                t.price = dbToy.Price__c;
                t.status = 'Match found';
                toys.add(t);

                mapInquires.remove(t.name.toLowerCase());
            }

            for(String name : mapInquires.keySet()) {
                Toy t = new Toy();
                t.name = name;
                t.status = 'no toy match found';
                toys.add(t);
            }

            res.headers.put('Content-Type', 'application/json');
            res.responseBody = Blob.valueOf(JSON.serialize(toys, true));
            res.statusCode = 200;
        } catch(Exception e) {
            res.headers.put('Content-Type', 'application/text');
            res.responseBody = Blob.valueOf('Unsupported input');
            res.statusCode = 400;
        }
    }

    class ToyInquiry {
        String name { get; set; }
    }

    class Toy {
        String status { get; set; }
        String name{ get; set; }
        String description { get; set; }
        Boolean isAvailable { get; set; }
        Decimal price { get; set; }
    }
}
