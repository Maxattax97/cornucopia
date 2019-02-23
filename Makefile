all: wildcard test #fix

wildcard:
	@python3 ./scripts/wildcard.py

# fix:
#     @find . \( -name "*.scad" \) -exec uncrustify -c .uncrustify.cfg --no-backup {} +

test:
	@OPENSCADPATH=/home/max/.local/share/OpenSCAD/libraries python3 -m pytest
