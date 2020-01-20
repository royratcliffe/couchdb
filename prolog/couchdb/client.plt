:- begin_tests(couchdb_client).

:- public test/2.

client_localhost(couchdb_client{base_url:'http://localhost'}).

test(url, [true(URL =@= 'http://localhost/')]) :-
    client_localhost(Client),
    Client.url('') = URL.
test(url, [true(URL =@= 'http://localhost/_all_dbs')]) :-
    client_localhost(Client),
    Client.url('_all_dbs') = URL.

:- end_tests(couchdb_client).
