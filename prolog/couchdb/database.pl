:- module(couchdb_database, []).

:- use_module(utils).

:- public
    info//0,
    exists//0,
    create//0.

Database.doc(ID) := couchdb_document{database:Database, id:ID_} :-
    atom_string(ID_, ID).

Database.info() := Info :-
    Database.server.get_url(Database.db) = 200-Info,
    tag_dict(Info, couchdb_info).

Database.exists() := Status :-
    Database.server.head_url(Database.db) = Status.

Database.create() := Status-Reply :-
    Database.server.put_url(Database.db, _{}) = Status-Reply,
    tag_dict(Reply, couchdb_reply).

Database.delete() := Status-Reply :-
    Database.server.delete_url(Database.db) = Status-Reply,
    tag_dict(Reply, couchdb_reply).

Database.new_doc(Doc) := Status-Reply :-
    Database.server.post_url(Database.db, Doc) = Status-Reply,
    tag_dict(Reply, couchdb_reply).

Database.new_rev(Doc) := Revision :-
    Database.new_doc(Doc) = Status-Reply,
    memberchk(Status, [201, 202]),
    get_dict(ok, Reply, true),
    get_dict(id, Reply, ID),
    get_dict(rev, Reply, Rev),
    Database.doc(ID) = Document,
    Document.rev(Rev) = Revision.
