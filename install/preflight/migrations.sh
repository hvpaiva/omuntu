OMUNTU_MIGRATIONS_STATE_PATH=~/.local/state/omuntu/migrations
mkdir -p $OMUNTU_MIGRATIONS_STATE_PATH

for file in ~/.local/share/omuntu/migrations/*.sh; do
  touch "$OMUNTU_MIGRATIONS_STATE_PATH/$(basename "$file")"
done
