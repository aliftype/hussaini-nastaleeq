NAME=hussaini-nastaleeq
VERSION=0.03

DIST=$(NAME)-$(VERSION)

OPT ?= t

PY=python3

define SCRIPT
import sys
import fontforge
f = fontforge.open(sys.argv[1])
f.mergeFeature(sys.argv[3])
f.version = "$(VERSION)"
f.generate(sys.argv[2], flags=("omit-instructions", "opentype", "no-mac-names"))
f.close()
if sys.argv[4] == "t":
  from fontTools.ttLib import TTFont
  f = TTFont(sys.argv[2], lazy=False)
  f.ensureDecompiled()
  f["post"].formatType = 3
  del f["FFTM"]
  f.save(sys.argv[2])
endef
export SCRIPT

SFD=$(NAME:%=%.sfd)
TTF=$(NAME:%=%.ttf)

all: ttf

ttf: $(TTF)

$(NAME).ttf: $(NAME).sfd $(NAME).fea Makefile
	@echo "Building $@"
	@$(PY) -c "$$SCRIPT" $< $@ $(NAME).fea $(OPT)

dist: $(TTF)
	@echo "Making dist tarball"
	@mkdir -p $(DIST)
	@cp $(SFD) $(TTF) $(DIST)
	@cp Makefile LICENSE $(DIST)
	@cp README.md $(DIST)/README.txt
	@zip -r $(DIST).zip $(DIST)

clean:
	@rm -rf $(TTF) $(DIST) $(DIST).zip
