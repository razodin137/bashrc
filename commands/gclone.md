```bash
gclone() {
    # 1. Fetch repos and select one using fzf
    local selected_repo=$(gh repo list --limit 1000 --json nameWithOwner --jq ".[].nameWithOwner" | fzf --height 40% --layout=reverse --border --prompt="Select repo to clone: ")

    if [ -z "$selected_repo" ]; then
        echo "No repo selected."
        return 1
    fi

    # 2. Extract the repo name (e.g., "my-project" from "user/my-project")
    local repo_name="${selected_repo#*/}"
    
    # 3. Determine the parent directory (defaults to current dir ".")
    local parent_dir="${1:-.}"
    local target_path="$parent_dir/$repo_name"

    # 4. SAFETY CHECK: Does this folder already exist?
    if [ -d "$target_path" ]; then
        echo "Error: Directory '$target_path' already exists!"
        echo "Aborting to prevent overwriting your work."
        return 1
    fi

    # 5. Clone and Jump In
    echo "Cloning $selected_repo into $target_path..."
    if git clone "https://github.com/$selected_repo.git" "$target_path"; then
        cd "$target_path" || return
        echo "Done! You are now in $(pwd)"
    else
        echo "Clone failed. Check your internet connection or permissions."
    fi
}
```
