```bash
# Create a new public GitHub repository with the name of the current directory (or provided name), initializing git first
gnew() {
    local repo_name="${1:-$(basename "$PWD")}"
    echo "Creating public repository on GitHub: $repo_name"

    # Initialize git if needed
    if [ ! -d .git ]; then
        git init
        git branch -M master
    fi

    # Ensure we are on master (or use the current branch if you prefer, but script forced master)
    # The original script forced master, so we keep that consistent, but safe-guard against errors.
    # git branch -M master

    git add .
    
    # Check if there are commits, if not commit.
    if ! git diff --cached --quiet; then
        git commit -m "Initial commit" || echo "Nothing to commit"
    fi

    # Create repo on GitHub
    # We use --source=. to let gh handle the remote addition and pushing if possible, 
    # but the original script did it manually-ish to ensure remote is origin.
    # gh repo create handles adding remote if we pass --source=. and --remote=origin.
    
    if gh repo create "$repo_name" --public --source=. --remote=origin; then
        echo "Repository created successfully."
    else
        echo "Failed to create repository (it might already exist)."
    fi

    git push -u origin master
}
```
