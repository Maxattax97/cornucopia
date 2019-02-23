all: wildcard fix test

wildcard:
	@python3 ./scripts/wildcard.py

fix:
	@find . \( -name "*.scad" \) -exec uncrustify -c .uncrustify.cfg --no-backup {} +

test:
	@python3 -m pytest
