🚀 space-game — learning Zig via game dev
=========================================

This repo is not meant to become a full game.  
It's a **Zig learning quest**, where I use game mechanics and Raylib to explore Zig's capabilities — from build system to memory to C interop.

Project Structure
-----------------
```
src/
├── main.zig        # Entry point
├── json.zig        # JSON config loader
├── settings.json   # External game settings
```

> Files like `root.zig`, and `test.zig` are ignored.  
> They're used for scratch logic and experimentation.


🔧 Setup
--------

Requirements:

- Zig (latest, from https://ziglang.org/download/)
- Raylib is bundled via `build.zig.zon` (no need to install manually)

Clone and run:

    git clone https://github.com/AkitooSama/space-game.git
    cd space-game
    zig build run

Why this project?
--------------------

- Explore Zig's **build system**, **error handling**, **interop with C**, and **low-level control**
- Use Raylib as a visual and interactive playground
- Make mistakes, refactor, and learn

> This is an experiment-first repo — not a production-grade game engine.

🪪 License
----------

MIT or public domain — free to use, clone, and idk learn from it?