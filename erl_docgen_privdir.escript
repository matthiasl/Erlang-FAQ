#!/usr/bin/env escript
%% -*- erlang -*-

main(_) ->
    io:format("~s", [code:priv_dir(erl_docgen)]).
