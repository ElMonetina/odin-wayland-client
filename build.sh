#!/bin/bash

# python3 wayland/client/generator.py wayland/client/protocols
# odin run example/basic -collection:wayland=wayland/
# odin run example/vulkan -collection:wayland=wayland/
odin run example/vulkan+input -collection:wayland=wayland/
