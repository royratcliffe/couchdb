:- module(couchdb_document, []).

:- use_module(utils).

Document.rev(Rev) := couchdb_revision{document:Document, rev:Rev_} :-
    atom_string(Rev_, Rev).
