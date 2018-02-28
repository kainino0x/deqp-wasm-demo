# Testing

## [Live Site (ES2+ES3)](http://kai.graphics/deqp-web-harness-live/)

* [KhronosGroup/WebGL tracking issue](https://github.com/KhronosGroup/WebGL/issues/2599)
* [Test Results](https://drive.google.com/corp/drive/u/1/folders/1sfsWaMEzxpShfSZaFf6uWk90wBgM2Uzt)
* [Progress Report 2018-02-28](https://docs.google.com/document/d/1QtiiNBL0U5Dyv2IuDrJy5H1UIGxitd32IJBApSecZ7c/edit?usp=sharing)

See the Progress Report for much more detailed documentation.

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
These files can be downloaded, then loaded in
[Cherry](https://android.googlesource.com/platform/external/cherry/+/master/README)'s
"Results" tab.
Results between different test runs (different browsers, builds, etc.) can be
compared in Cherry using the "Compare selected" functionality.
(Tests cannot be executed in the web harness directly from Cherry.)

**Tip:** `.qpa` files can be concatenated. For example, in order to get test
results for `dEQP-GLES3` (which runs out of memory in the middle), I ran each
subgroup of `dEQP-GLES3.functional` separately, then concatenated them all
together (with `cat`) into one `.qpa` file.

## Known Issues

* The tests in `dEQP-GLES3.functional` all run without crashing the harness,
  but (at least on some machines/browsers) it may run out of memory in the
  middle of a contiguous run.
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
