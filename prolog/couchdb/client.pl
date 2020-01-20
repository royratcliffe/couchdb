:- module(couchdb_client, []).

:- use_module(library(http/http_client)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_json), []).

:- use_module(utils).

:- public
    db//1,
    welcome//0,
    all_dbs//0,

    head_url//1,
    get_url//1,
    put_url//2,
    url//1.

Client.db(Db) := couchdb_database{client:Client, db:Db}.

Client.welcome() := Welcome :-
    Client.get_url('') = 200-Welcome,
    tag_dict(Welcome, couchdb_welcome).

Client.all_dbs() := AllDbs :-
    Client.get_url('_all_dbs') = 200-AllDbs0,
    maplist([String, Atom]>>atom_string(Atom, String), AllDbs0, AllDbs).

Client.all_databases() := AllDatabases :-
    Client.all_dbs() = AllDbs,
    maplist({Client}/[Db, Database]>>
            (Client.db(Db) = Database), AllDbs, AllDatabases).

Client.head_url(URL) := Status :-
    http_open(Client.url(URL), Stream, [method(head), status_code(Status)]),
    close(Stream).

Client.get_url(URL) := Status-Reply :-
    http_get(Client.url(URL), Reply, [json_object(dict), status_code(Status)]).

Client.put_url(URL, Data) := Status-Reply :-
    http_put(Client.url(URL), json(Data), Reply, [json_object(dict), status_code(Status)]).

Client.post_url(URL, Data) := Status-Reply :-
    http_post(Client.url(URL), json(Data), Reply, [json_object(dict), status_code(Status)]).

Client.delete_url(URL) := Status-Reply :-
    http_delete(Client.url(URL), Reply, [json_object(dict), status_code(Status)]).

Client.url(URL0) := URL :-
    parse_url(URL0, Client.base_url, Attributes),
    parse_url(URL, Attributes).
