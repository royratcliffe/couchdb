:- module(couchdb_document, []).

:- use_module(utils).

Document.rev(Rev) := couchdb_revision{document:Document, rev:Rev_} :-
    atom_string(Rev_, Rev).

Document.url() := URL :-
    atomic_list_concat([Document.database.db, Document.id], /, URL).

Document.get() := Doc :-
    Document.database.client.get_url(Document.url()) = Doc.
