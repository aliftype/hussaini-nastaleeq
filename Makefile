NAME=hussaini-nastaleeq
VERSION=0.02

DIST=$(NAME)-$(VERSION)

PY=python

define SCRIPT
import fontforge, sys
f = fontforge.open(sys.argv[1])
if len(sys.argv) > 3:
  f.mergeFeature(sys.argv[3])
f.version = $(VERSION)
f.generate(sys.argv[2], flags=("omit-instructions"))
endef

SFD=$(NAME:%=%.sfd)
TTF=$(NAME:%=%.ttf)

all: ttf

ttf: $(TTF)

$(NAME).ttf: $(NAME).sfd $(NAME).fea Makefile
	@echo "Building $@"
	@$(PY) -c "$$SCRIPT" $< $@ $(NAME).fea

dist: $(TTF)
	@echo "Making dist tarball"
	@mkdir -p $(DIST)
	@cp $(SFD) $(TTF) $(DIST)
	@cp Makefile LICENSE $(DIST)
	@cp README.md $(DIST)/README.txt
	@zip -r $(DIST).zip $(DIST)

clean:
	@rm -rf $(TTF) $(DIST) $(DIST).zip
