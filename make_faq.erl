%% Wrapper for docb_transform which allows me to call from unix shell (make)
-module(make_faq).
-export([go/0]).

go() ->
  docb_transform:file("faq.xml", [{outdir, "obj/"}]).
