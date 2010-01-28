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
ERL=erl

all: obj obj/faq.html obj/t1.html

# Make a list of links in the document. I check these manually because
# an automatic checker is likely to miss semi-dead pages.
linkcheck: $(sources)
	grep http $(sources) | cut -d \" -f 2 | sort | uniq > /home/matthias/links

obj:
	mkdir obj

obj/faq.html: $(sources)
	$(ERL) -noshell -eval 'docb_transform:file("faq.xml",[{outdir,"obj/"}]),init:stop().'

# Historically, the FAQ started at t1.html. Preserve that to avoid breaking
# people's links.
obj/t1.html:
	cp obj/faq_frame.html obj/t1.html

ship:
	(cd ..; tar  -czvf ~/erlfaq.tgz faq/*.xml faq/Makefile faq/*erl faq/README faq/Makefile faq/erlang_magic_file)

# Install on erlang.org.
#
# We have to do some renaming to keep the traditional structure
# (faq.html should contain the frameset).
FAQ_ROOT=../public/faq

install: obj/faq.html
	mkdir -p $(FAQ_ROOT)
	cp -a obj/* $(FAQ_ROOT)
	sed 's/faq[.]html/faq_toc.html/' obj/faq_frame.html > $(FAQ_ROOT)/faq.html
	sed -e /faq_term/d -e /faq_cite/d obj/faq.html > $(FAQ_ROOT)/faq_toc.html

clean:
	rm -rf obj/*
