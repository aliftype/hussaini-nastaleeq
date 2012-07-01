NAME=hussaini-nastaleeq
VERSION=0.02

DIST=$(NAME)-$(VERSION)

FF=fontforge -lang=ff
SCRIPT='Open($$1);\
       if ($$argc>3)\
         MergeFeature($$2);\
       endif;\
       SetFontNames("","","","","","$(VERSION)");\
       Generate($$argv[$$argc-1], "", -1)'

SFD=$(NAME:%=%.sfd)
TTF=$(NAME:%=%.ttf)

all: ttf

ttf: $(TTF)

hussaini-nastaleeq.ttf: hussaini-nastaleeq.sfd hussaini-nastaleeq.fea Makefile
	@echo "Building $@"
	@$(FF) -c $(SCRIPT) $< hussaini-nastaleeq.fea $@ 2>/dev/stdout 1>/dev/stderr | tail -n +4

dist: $(TTF)
	@echo "Making dist tarball"
	@mkdir -p $(DIST)
	@cp $(SFD) $(TTF) $(DIST)
	@cp Makefile LICENSE $(DIST)
	@cp README.md $(DIST)/README.txt
	@zip -r $(DIST).zip $(DIST)

clean:
	@rm -rf $(TTF) $(DIST) $(DIST).zip
