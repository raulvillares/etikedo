#!/bin/sh

cp scripts/git-hooks .git/hooks/
chmod +x .git/hooks/pre-push
echo "Git hooks installed"
