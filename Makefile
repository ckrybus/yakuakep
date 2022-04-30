lint:
	nimpretty src/*.nim

build:
	nim c --styleCheck:hint  src/*.nim

release:
	nim -d:release --opt:size --passL:-s c src/yakuakep.nim
