NAME=hussaini-nastaleeq
VERSION=0.05

DIST=$(NAME)-$(VERSION)

OPT ?= t

PY=python3

define SCRIPT
import sys
import fontforge
f = fontforge.open(sys.argv[1])
f.mergeFeature(sys.argv[3])
f.version = "$(VERSION)"
flags = ["omit-instructions", "opentype", "no-mac-names"]
if sys.argv[4] == "t":
  flags += ["short-post", "no-FFTM-table"]
f.generate(sys.argv[2], flags=flags)
f.close()
endef
export SCRIPT

SFD=$(NAME:%=%.sfd)
TTF=$(NAME:%=%.ttf)
WOFF=$(NAME:%=%.woff)
WOFF2=$(NAME:%=%.woff2)
SVG=sample.svg

all: ttf svg
ttf: $(TTF)
svg: $(SVG)

$(NAME).ttf: $(NAME).sfd $(NAME).fea
	@echo "Building $@"
	fontforge -c "$$SCRIPT" $< $@ $(NAME).fea $(OPT)

%.woff: %.ttf
	woff $<

%.woff2: %.ttf
	woff2_compress $<

%.pdf: %.tex $(TTF)
	lualatex --interaction=batchmode $<

%.svg: %.pdf
	pdftocairo -svg $< $@


dist: $(TTF) $(WOFF) $(WOFF2)
	@echo "Making dist tarball"
	@mkdir -p $(DIST)/{desktop,web}
	@cp $(TTF) $(DIST)/desktop
	@cp $(WOFF) $(WOFF2) $(DIST)/web
	@cp LICENSE $(DIST)
	@cp README.md $(DIST)/README.txt
	@zip -r $(DIST).zip $(DIST)

clean:
	@rm -rf $(TTF) $(WOFF) $(WOFF2) $(DIST) $(DIST).zip
