:- module(couchdb_server, []).

:- use_module(library(http/http_client)).
:- use_module(library(http/http_open)).
:- use_module(library(http/http_json), []).

:- use_module(utils).

:- public
    db//1,
    welcome//0,
    all_dbs//0,
    all_databases//0,
    membership//0,

    head_url//1,
    get_url//1,
    put_url//2,
    url//1.

Server.db(Db) := couchdb_database{server:Server, db:Db}.

Server.welcome() := Welcome :-
    Server.get_url('') = 200-Welcome,
    tag_dict(Welcome, couchdb_welcome).

Server.all_dbs() := AllDbs :-
    Server.get_url('_all_dbs') = 200-AllDbs0,
    maplist([String, Atom]>>atom_string(Atom, String), AllDbs0, AllDbs).

Server.all_databases() := AllDatabases :-
    Server.all_dbs() = AllDbs,
    maplist({Server}/[Db, Database]>>
            (Server.db(Db) = Database), AllDbs, AllDatabases).

Server.membership() := Membership :-
    Server.get_url('_membership') = 200-Membership,
    tag_dict(Membership, couchdb_membership).

options([request_header(accept=application/json), json_object(dict)]).

Server.head_url(URL) := Status :-
    http_open(Server.url(URL), Stream, [method(head), status_code(Status)]),
    close(Stream).

Server.get_url(URL) := Status-Reply :-
    options(Options),
    http_get(Server.url(URL), Reply, [status_code(Status)|Options]).

Server.put_url(URL, Data) := Status-Reply :-
    options(Options),
    http_put(Server.url(URL), json(Data), Reply, [status_code(Status)|Options]).

Server.post_url(URL, Data) := Status-Reply :-
    options(Options),
    http_post(Server.url(URL), json(Data), Reply, [status_code(Status)|Options]).

Server.delete_url(URL) := Status-Reply :-
    options(Options),
    http_delete(Server.url(URL), Reply, [status_code(Status)|Options]).

Server.url(URL0) := URL :-
    parse_url(URL0, Server.base_url, Attributes),
    parse_url(URL, Attributes).
