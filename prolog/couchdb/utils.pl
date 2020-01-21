:- module(couchdb_utils, [tag_dict/2]).

%!  tag_dict(+Dict, ?Tag) is semidet.
%
%   Tags Dict with Tag if currently   untagged.  Fails if already tagged
%   but not matching Tag, just like is_dict/2   with a ground tag. Never
%   mutates ground tags as  a  result.   Additionally  Tags  all  nested
%   sub-dictionaries using Tag and the   sub-key for the sub-dictionary.
%   An underscore delimiter concatenates the tag and key.
%
%   The implementation uses atomic concatenation to   merge  Tag and the
%   dictionary  sub-keys.  Note  that   atomic_list_concat/3  works  for
%   non-atomic keys, including numbers and   strings.  Does not traverse
%   sub-lists. Ignores sub-dictionaries where a   dictionary  value is a
%   list containing dictionaries. Perhaps future versions will.

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
