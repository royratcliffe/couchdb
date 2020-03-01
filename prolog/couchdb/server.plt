:- begin_tests(couchdb_server).

:- public test/2.

server_localhost(couchdb_server{base_url:'http://localhost'}).

test(url, [true(URL =@= 'http://localhost/')]) :-
    server_localhost(Server),
    Server.url('') = URL.
test(url, [true(URL =@= 'http://localhost/_all_dbs')]) :-
    server_localhost(Server),
    Server.url('_all_dbs') = URL.

:- end_tests(couchdb_server).
