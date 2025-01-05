These tools enhance the functionality and usability of the terminal, especially when integrated into the fish shell.

SDKMAN
Description: SDKMAN is a tool for managing parallel versions of multiple Software Development Kits on most Unix-based systems.

Example: To install SDKMAN, you can run:

```bash
export SDKMAN_DIR="$HOME/.sdkman"
if [ ! -d "$SDKMAN_DIR" ]; then
  curl -s "https://get.sdkman.io" | bash
fi
source "$SDKMAN_DIR/bin/sdkman-init.sh"
```
