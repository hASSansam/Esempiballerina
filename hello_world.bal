import ballerina/http;

service / on new http:Listener(6969) {

    resource function get ciao() returns string {
        return "Hello, Dipi!";
    }
}