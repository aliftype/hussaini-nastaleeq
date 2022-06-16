NAME=hussaini-nastaleeq
VERSION=0.02

DIST=$(NAME)-$(VERSION)

PY=python3

define SCRIPT
import sys
import fontforge
from fontTools.ttLib import TTFont
f = fontforge.open(sys.argv[1])
f.mergeFeature(sys.argv[3])
f.version = "$(VERSION)"
f.generate(sys.argv[2], flags=("omit-instructions", "opentype", "no-mac-names"))
f.close()
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
