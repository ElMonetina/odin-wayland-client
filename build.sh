#!/bin/bash

# python3 wayland/client/generator.py wayland/client/protocols
# odin run src/basic -collection:wayland=wayland/
# odin run src/vulkan -collection:wayland=wayland/
odin run src/vulkan+input -collection:wayland=wayland/
