:- module(couchdb_database, []).

:- use_module(utils).

:- public
    info//0,
    exists//0,
    create//0.

Database.info() := Info :-
    Database.client.get_url(Database.db) = Info,
    tag_dict(Info, couchdb_info).

Database.exists() := Status :-
    Database.client.head_url(Database.db) = Status.

Database.create() := Status-Reply :-
    Database.client.put_url(Database.db, _{}) = Status-Reply,
    tag_dict(Reply, couchdb_create).

Database.delete() := Status-Reply :-
    Database.client.delete_url(Database.db) = Status-Reply,
    tag_dict(Reply, couchdb_delete).
