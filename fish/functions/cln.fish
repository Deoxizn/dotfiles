function cln --description 'Clear common cache, Chromium data, and old logs'
    echo "Starting cleanup..."

    # 1. Chromium cache (Delete contents only)
    if test -d ~/.config/chromium/Default/Cache
        find ~/.config/chromium/Default/Cache -mindepth 1 -delete
        echo "✓ Chromium cache cleared."
    end

    # 2. RAM-based XDG cache (Delete contents only)
    if test -d "$XDG_CACHE_HOME"
        find $XDG_CACHE_HOME -mindepth 1 -delete
        echo "✓ RAM cache ($XDG_CACHE_HOME) cleared."
    end

    # 3. Legacy ~/.cache (Delete contents only)
    if test -d ~/.cache
        find ~/.cache -mindepth 1 -delete
        echo "✓ Legacy ~/.cache cleared."
    end

    # 4. System-level cleanup (Requires sudo)
    # We use 'command rm' to bypass your 'rmm' alias
    sudo command rm -rf /tmp/*
    sudo find /var/log -type f -mtime +7 -delete
    echo "✓ System /tmp and old logs cleared."

    # 5. Ensure the completion directory exists (Silent check)
    if not test -d "$XDG_CACHE_HOME/fish/generated_completions"
        command mkdir -p "$XDG_CACHE_HOME/fish/generated_completions"
    end

    echo "Cleanup complete!"
end
