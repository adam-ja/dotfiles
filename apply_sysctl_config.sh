#!/bin/bash

SETTINGS=(
  "fs.inotify.max_user_watches=524288"
  "fs.inotify.max_user_instances=1024"
  "fs.inotify.max_queued_events=32768"
)

SYSCTL_CONF="/etc/sysctl.conf"
NEEDS_UPDATE=false

for SETTING in "${SETTINGS[@]}"; do
  KEY=$(echo $SETTING | cut -d'=' -f1)
  # Check if the key exists in the file
  if ! grep -q "^$KEY" "$SYSCTL_CONF"; then
    echo "Adding $SETTING to $SYSCTL_CONF"
    echo "$SETTING" | sudo tee -a "$SYSCTL_CONF" > /dev/null
    NEEDS_UPDATE=true
  else
    # If the key exists but the value is different, update it
    CURRENT_VAL=$(grep "^$KEY" "$SYSCTL_CONF")
    if [ "$CURRENT_VAL" != "$SETTING" ]; then
      echo "Updating $KEY in $SYSCTL_CONF"
      sudo sed -i "s|^$KEY.*|$SETTING|" "$SYSCTL_CONF"
      NEEDS_UPDATE=true
    fi
  fi
done

# Apply changes if any updates were made
if [ "$NEEDS_UPDATE" = true ]; then
  sudo sysctl -p
  echo "Sysctl configs updated and applied."
else
  echo "Sysctl configs are already up to date."
fi
