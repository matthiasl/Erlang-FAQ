
sources= \
	faq.xml \
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

XSL_FILES= \
	faq_html.xsl \
	faq_html_params.xsl

all: obj obj/faq.html obj/t1.html local_copy_of_definions

# Make a list of links in the document. I check these manually because
# an automatic checker is likely to miss semi-dead pages.
linkcheck: $(sources)
	egrep https?: $(sources) | cut -d \" -f 2 | sort | uniq > $(PWD)/link-check

obj:
	mkdir obj

obj/faq.html: $(sources) $(XSL_FILES)
	erl_docgen_privdir=`escript erl_docgen_privdir.escript`; \
	date=`date +"%B %e %Y"`; \
	xsltproc --stringparam outdir obj --stringparam gendate "$$date" --stringparam topdocdir . --xinclude -path $$erl_docgen_privdir/docbuilder_dtd -path $$erl_docgen_privdir/dtd_html_entities faq_html.xsl faq.xml

# Copy needed images, stylesheets and scripts
local_copy_of_definions:
	erl_docgen_privdir=`escript erl_docgen_privdir.escript`; \
	cp -a $$erl_docgen_privdir/css/otp_doc.css obj; \
	cp -a $$erl_docgen_privdir/images/* obj; \
	mkdir -p obj/js/flipmenu; \
	cp -a $$erl_docgen_privdir/js/flipmenu/* obj/js/flipmenu


# Historically, the FAQ started at t1.html. Preserve that to avoid breaking
# people's links.
obj/t1.html: obj/faq.html
	cp obj/faq.html obj/t1.html


# Install on erlang.org.
#
# We have to do some renaming to keep the traditional structure
# (faq.html should contain the frameset).
FAQ_ROOT=../public/faq

install: obj/faq.html
	mkdir -p $(FAQ_ROOT)
	cp -a obj/* $(FAQ_ROOT)

clean:
	rm -rf obj/*
