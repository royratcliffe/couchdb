:- module(couchdb_utils, [tag_dict/2]).

tag_dict(Dict, Tag) :-
    is_dict(Dict, Tag),
    dict_pairs(Dict, Tag, Pairs),
    tag_pairs(Pairs, Tag).

tag_pairs([], _).
tag_pairs([Key-Value|T], Tag) :-
    (   is_dict(Value)
    ->  atomic_list_concat([Tag, Key], '_', Tag_),
        tag_dict(Value, Tag_)
    ;   true
    ),
    tag_pairs(T, Tag).
