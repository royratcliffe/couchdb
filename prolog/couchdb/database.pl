:- module(couchdb_database, []).

:- use_module(utils).

:- public
    info//0,
    exists//0,
    create//0.

Database.doc(ID) := couchdb_document{database:Database, id:ID_} :-
    atom_string(ID_, ID).

Database.info() := Info :-
    Database.client.get_url(Database.db) = Info,
    tag_dict(Info, couchdb_info).

Database.exists() := Status :-
    Database.client.head_url(Database.db) = Status.

Database.create() := Status-Reply :-
    Database.client.put_url(Database.db, _{}) = Status-Reply,
    tag_dict(Reply, couchdb_reply).

Database.delete() := Status-Reply :-
    Database.client.delete_url(Database.db) = Status-Reply,
    tag_dict(Reply, couchdb_reply).

Database.new_doc(Doc) := Status-Reply :-
    Database.client.post_url(Database.db, Doc) = Status-Reply,
    tag_dict(Reply, couchdb_reply).

Database.new_rev(Doc) := Revision :-
    Database.new_doc(Doc) = Status-Reply,
    memberchk(Status, [201, 202]),
    get_dict(ok, Reply, true),
    get_dict(id, Reply, ID),
    get_dict(rev, Reply, Rev),
    Database.doc(ID) = Document,
    Document.rev(Rev) = Revision.
