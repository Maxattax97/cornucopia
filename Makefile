all: wildcard fix test

wildcard:
	@echo "Not yet implemented"

fix:
	@find . \( -name "*.scad" \) -exec uncrustify -c .uncrustify.cfg --no-backup {} +

test:
	@echo "Not yet implemented"
