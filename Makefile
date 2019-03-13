all: wildcard test #fix

wildcard:
	@python3 ./scripts/wildcard.py

fix:
	@openscad-format -i './**/*.scad'
	@#../openscad-format/index.js -i './**/*.scad'

test:
	@OPENSCADPATH=/home/max/.local/share/OpenSCAD/libraries python3 -m pytest
