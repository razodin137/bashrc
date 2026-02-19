# Link current directory to an existing GitHub repo and sync
gconnect() {
    # 1. Fetch your repos and select one using fzf
    # FIX: Used --jq .[].nameWithOwner to avoid quote escaping issues
    local selected_repo=$(gh repo list --limit 1000 --json nameWithOwner --jq ".[].nameWithOwner" | fzf --height 40% --layout=reverse --border --prompt="Select repo to link: ")

    if [ -z "$selected_repo" ]; then
        echo "No repo selected."
        return 1
    fi

    # 2. Initialize git if not already a repo
    [ ! -d .git ] && git init
  
    # 3. Add or update the remote origin
    git remote remove origin 2>/dev/null || true
    git remote add origin "https://github.com/$selected_repo.git"

    # 4. Get the default branch name
    local default_branch=$(gh repo view "$selected_repo" --json defaultBranchRef --jq .defaultBranchRef.name)
    local is_empty=false
    
    if [ -z "$default_branch" ]; then
        echo "Repo appears to be empty (no default branch)."
        default_branch="master"
        is_empty=true
    fi

    # 5. Sync: Pull remote changes first if not empty
    if [ "$is_empty" = false ]; then
        echo "Syncing with $selected_repo..."
        if ! git pull origin "$default_branch" --rebase --allow-unrelated-histories; then
             echo "Pull failed. If this is a new repo, check if it is truly empty."
             # Continue to allow push attempt if user wants? No, better warn.
        fi
    else
        echo "Skipping pull for empty repository."
    fi

    # 6. Add, Commit, and Push your new files
    git add .
    if ! git diff --cached --quiet; then
        git commit -m "Update from gconnect"
        git push -u origin "$default_branch"
        echo "Successfully linked and pushed!"
    else
        # If we didn"t commit anything, we might still need to push existing commits (if any) or existing files.
        # But if diff cached quiet, it means nothing staged.
        # If the user has local commits that aren"t pushed yet, we should push them.
        echo "No new changes to commit."
        if [ "$is_empty" = true ]; then
             echo "Pushing to empty repo..."
             git push -u origin "$default_branch"
        else
             echo "Pushing any local commits..."
             git push -u origin "$default_branch"
        fi
        echo "Done."
    fi
}

