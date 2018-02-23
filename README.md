# Testing

## [Live Site (ES2+ES3)](http://kai.graphics/deqp-web-harness-live/)

## Running Tests

First, enter a test root and click "Load Root".
This test root can be any test group, e.g.:

* `dEQP-GLES2`
* `dEQP-GLES2.functional`
* `dEQP-GLES2.functional.shaders.preprocessor.conditional_inclusion`

(It can't be an individual test, currently.)

To run a test or test group, click the Run button.
If you're debugging a particular test or test group, you probably want to have
your browser's development tools open.

## Viewing Test Results

Each test run will produce a new `.qpa` file.
These files can be loaded in
[Cherry](https://android.googlesource.com/platform/external/cherry/+/master/README)'s
"Results" tab.
(Tests cannot be executed in the web harness directly from Cherry.)

## Known Issues

* The tests in `dEQP-GLES3.functional` all run without crashing the harness,
  but (at least on some machines/browsers) it may run out of memory in the
  middle of a contiguous run.
* Builds with more optimization flags load faster than RelWithDebInfo builds,
  but both run equally fast. There may be a better set of build flags than the
  one used for RelWithDebInfo.
* There is no way to run GLES2 tests against WebGL 2.0.
* All page state (including `.qpa` file output) is transient and will disappear
  if the page is reloaded or crashes.

# Building

## Prerequisites

These steps have been tested on Linux and macOS.

* [emsdk-portable](https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html)
    * (Don't forget to `source emsdk_env.sh` so you can use `emcmake`.)
* Pull the submodules: `git submodule update --init --recursive`
* Fetch dEQP's dependencies and configure zlib (this is done automatically by
  the Makefile):
    ```
    cd deqp/external
    python fetch_sources.py
    cd zlib/src
    emcmake cmake .
    ```

## Configuring

* Make a build directory (in the deqp-web-harness repository root).
* Generate the build files using CMake.

```
# This is the build config used by the Makefile.
mkdir build
cd build
emcmake cmake ../deqp
    # This is the only tested build type.
    -DCMAKE_BUILD_TYPE=RelWithDebInfo
    # Include patches needed to prevent some tests from crashing the harness.
    -DCMAKE_EXE_LINKER_FLAGS='--js-library ../third_party/emscripten-library_gl/library_gl.js'
    # (optional) Use Ninja instead of Make.
    -GNinja
    # (optional) Enable ES2 (ON by default)
    -DDEQP_SUPPORT_GLES2=ON
    # (optional) Enable ES3 (ON by default)
    -DDEQP_SUPPORT_GLES3=ON
    # (optional) Disable ES3.1 (ON by default)
    -DDEQP_SUPPORT_GLES31=OFF
```

## Building

```
ninja deqp.js
```

## Known Issues

* Incremental builds do not always work - some changes are not reflected (such
  as changes to `library_gl.js`). To work around this, delete `build/deqp.js`.
