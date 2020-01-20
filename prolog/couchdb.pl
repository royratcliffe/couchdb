:- module(couchdb,
          [   couchdb_connect/2,
              couchdb_client/2
          ]).

:- use_module(couchdb/client, []).
:- use_module(couchdb/database, []).
:- use_module(couchdb/document, []).
:- use_module(couchdb/revision, []).

:- dynamic connection/2.

couchdb_connect(ID, _) :-
    connection(ID, _),
    !.
couchdb_connect(ID, BaseURL) :-
    asserta(connection(ID, BaseURL)).

couchdb_client(ID, couchdb_client{base_url:BaseURL}) :-
    connection(ID, BaseURL).
