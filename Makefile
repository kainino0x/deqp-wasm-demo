.PHONY: build
build: deqp/external/zlib/src/CMakeCache.txt
	mkdir -p build/ && \
	cd build/ && \
	emcmake cmake ../deqp -GNinja \
		-DCMAKE_BUILD_TYPE=RelWithDebInfo \
		-DCMAKE_EXE_LINKER_FLAGS="--js-library ../third_party/emscripten-library_gl/library_gl.js" \
		&& \
	ninja deqp.js && \
	cp ../src/index.html .

deqp/external/zlib/src/CMakeCache.txt: deqp/external/zlib/src/CMakeLists.txt
	cd deqp/external/zlib/src && emcmake cmake .

deqp/external/zlib/src/CMakeLists.txt:
	cd deqp/external && python fetch_sources.py
