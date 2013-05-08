
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

erl_docgen_privdir:=$(shell escript erl_docgen_privdir.escript)/
dtd_html_ent_dir=$(erl_docgen_privdir)/dtd_html_entities/
dtd_dir=$(erl_docgen_privdir)/dtd/
dtd_files=$(addprefix $(dtd_dir), chapter.dtd part.dtd)
ent_file=$(dtd_html_ent_dir)/xhtml-lat1.ent

generation_date=$(shell date +"%B %e %Y")

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

# The ent_file and dtd_files dependencies are there to make sure
# xsltproc can find the .ent and .dtd files it needs. If it can't
# find them, it'll silently produce broken output.
obj/faq.html: $(sources) $(XSL_FILES) $(ent_file) $(dtd_files) 
	xsltproc --stringparam outdir obj --stringparam gendate "$(generation_date)" --stringparam topdocdir . --xinclude -path $(dtd_dir) -path $(dtd_html_ent_dir) faq_html.xsl faq.xml

image_dir=$(erl_docgen_privdir)/images
css_dir=$(erl_docgen_privdir)/css

# Copy needed images, stylesheets and scripts
local_copy_of_definions:
	cp -a $(erl_docgen_privdir)/css/otp_doc.css obj/
	cp -a $(erl_docgen_privdir)/images/* obj/
	mkdir -p obj/js/flipmenu
	cp -a $(erl_docgen_privdir)/js/flipmenu/* obj/js/flipmenu


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
