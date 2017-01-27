NAME     = soundex

OCAMLC   = ocamlfind ocamlc -g
OCAMLL   = $(OCAMLC) -package "$(REQUIRES)" -linkpkg graphics.cma
OCAMLOPT = ocamlfind ocamlopt
OCAMLDEP = ocamldep

EXECS = postagger postagger-opt compute-stats gen-corpus

REQUIRES =
PREDICATES =

.PHONY: all pkg optpkg

all: $(EXECS)

postagger-opt: stats.cmx pos.cmx postagger.cmx
	$(OCAMLOPT) $^ -o $@

postagger: stats.cmo pos.cmo postagger.cmo
	$(OCAMLL) $^ -o $@

compute-stats: stats.cmo compute-stats.cmo
	$(OCAMLL) $^ -o $@

gen-corpus: gen-corpus.cmo
	$(OCAMLL) $^ -o $@

pkg: $(ARCHIVE)
optpkg: $(XARCHIVE)

$(ARCHIVE): $(OBJECTS)
	$(OCAMLC) -a -o $(ARCHIVE) -package "$(REQUIRES)" -linkpkg \
	-predicates "$(PREDICATES)" $(OBJECTS)
$(XARCHIVE): $(XOBJECTS)
	$(OCAMLOPT) -a -o $(XARCHIVE) -package "$(REQUIRES)" -linkpkg \
	-predicates "$(PREDICATES)" $(XOBJECTS)

.SUFFIXES: .cmo .cmi .cmx .ml .mli

.ml.cmo:
	$(OCAMLC) -package "$(REQUIRES)" -predicates "$(PREDICATES)" \
	-c $<
.mli.cmi:
	$(OCAMLC) -package "$(REQUIRES)" -predicates "$(PREDICATES)" \
	-c $<
.ml.cmx:
	$(OCAMLOPT) -package "$(REQUIRES)" -predicates "$(PREDICATES)" \
	-c $<

include depend

depend: $(wildcard *.ml*)
	if ! ($(OCAMLDEP) *.mli *.ml >depend); then rm depend; fi

.PHONY: install uninstall clean

install: all
	{ test ! -f $(XARCHIVE) || extra="$(XARCHIVE) "`basename $(XARCHIVE) .cmxa`.a }; \
	ocamlfind install $(NAME) *.mli *.cmi $(ARCHIVE) META $$extra

uninstall:
	ocamlfind remove $(NAME)

clean:
	rm -f depend *.cmi *.cmo *.cmx *.cma *.cmxa *.a $(EXECS)
	rm -f depend *.dvi *.log *.aux *.ps
