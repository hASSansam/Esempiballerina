// Importa il modulo http per gestire le richieste HTTP.
import ballerina/http;

// Configura la porta su cui il servizio sarà in ascolto.
configurable int port = 8080;

// Definisce un tipo di record Album con campi id, title, artist e price.
type Album readonly & record {|
    string id;
    string title;
    string artist;
    decimal price;
|};

// Crea una tabella di album con l'id come chiave.
table<Album> key(id) albums = table [
        {id: "1", title: "Blue Train", artist: "John Coltrane", price: 56.99},
        {id: "2", title: "Jeru", artist: "Gerry Mulligan", price: 17.99},
        {id: "3", title: "Sarah Vaughan and Clifford Brown", artist: "Sarah Vaughan", price: 39.99}
    ];

// Crea un servizio HTTP in ascolto sulla porta configurata.
service / on new http:Listener(port) {
    // Definisce una funzione di risorsa per gestire le richieste GET a /albums.
    // Restituisce un array di album.
    resource function get albums() returns Album[] {
        return albums.toArray();
    }

    // Definisce una funzione di risorsa per gestire le richieste GET a /albums/{id}.
    // Restituisce un album specifico o un errore 404 se l'album non esiste.
    resource function get albums/[string id]() returns Album|http:NotFound {
        Album? album = albums[id];
        if album is () {
            return http:NOT_FOUND;
        } else {
            return album;
        }
    }

    // Definisce una funzione di risorsa per gestire le richieste POST a /albums.
    // Aggiunge un nuovo album alla tabella e lo restituisce.
    resource function post albums(@http:Payload Album album) returns Album {
        albums.add(album);
        return album;
    }
}