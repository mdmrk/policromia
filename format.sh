#!/bin/bash

stylua --glob '**/*.lua' .
find . -name "*.md" -exec prettier --write {} \;
find . -name "*.sh" -exec shfmt -w {} \;
