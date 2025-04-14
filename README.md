SPACE-GAME: LEARNING ZIG THROUGH GAME DEV
=========================================

A minimalistic Zig experiment using game mechanics and Raylib.
Focus: Build system, memory control, C interop, error handling.

---

SETUP & QUICK START
-------------------

Requirements:
* Zig (latest) - https://ziglang.org/download/
* Raylib auto-fetched via build.zig.zon

Run:
    git clone https://github.com/AkitooSama/space-game.git
    cd space-game
    zig build run

---

PROJECT STRUCTURE
-----------------
src/
|-- main.zig        : Core logic entry
|-- json.zig        : Config loader
|-- settings.json   : Game parameters

Note: Scratch files (root.zig, test.zig) excluded - experimental use only.

---

WHY THIS EXISTS?
----------------

* [ZIG BUILD SYSTEM] Dependency mgmt via build.zig.zon
* [MEMORY CONTROL] Manual allocators, zero hidden magic
* [C INTEROP] Direct Raylib C API integration
* [VISUAL FEEDBACK] Game loop = instant result validation
* [EXPERIMENT] Break -> Refactor -> Learn loop

> Experiment-first approach, no pressure :)

---

LICENSE
-------
MIT Licensed. Clone, modify, learn - no strings.
Full terms in ./LICENSE.