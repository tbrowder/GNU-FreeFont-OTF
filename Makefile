
dist:
	mkdir -p dist
	zip -r dist/gnu-freefont-addon-src.zip lib bin t README* META6.json .github Makefile 2>/dev/null || true
