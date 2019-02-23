all: wildcard fix test

wildcard:
	@echo "Not yet implemented"

fix:
	@find . \( -name "*.scad" \) -exec uncrustify -c .uncrustify.cfg --no-backup {} +

test:
	@python3 -m pytest
