sources= \
	introduction.xml \
	faq_questions.xml \
	obtaining.xml \
	getting_started.xml \
	how_do_i.xml \
	libraries.xml \
	tools.xml \
	implementations.xml \
	problems.xml \
	academic.xml \
	mnesia.xml 

# Erlang compiler
ERL=12erl

all: obj obj/faq.html obj/t1.html

# Make a list of links in the document. I check these manually because
# an automatic checker is likely to miss semi-dead pages.
linkcheck: $(sources)
	grep http $(sources) | cut -d \" -f 2 | sort | uniq > /home/matthias/links


obj:
	mkdir obj

obj/faq.html: $(sources) make_faq.beam
	$(ERL) -s make_faq go -s init stop

# Historically, the FAQ started at t1.html. Preserve that to avoid breaking
# people's links.
obj/t1.html:
	cp obj/faq_frame.html obj/t1.html

%.beam: %.erl
	$(ERL) -make

ship:
	(cd ..; tar  -czvf ~/erlfaq.tgz faq/*.xml faq/Makefile faq/*erl faq/README faq/Makefile faq/erlang_magic_file)

clean:
	rm -rf obj/*
