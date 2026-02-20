```bash
# Create a new private GitHub repository with the name of the current directory (or provided name), initializing git first
gnew-p() {
    local repo_name="${1:-$(basename "$PWD")}"
    echo "Creating private repository on GitHub: $repo_name"

    if [ ! -d .git ]; then
        git init
        git branch -M master
    fi

    git add .
    if ! git diff --cached --quiet; then
        git commit -m "Initial commit" || echo "Nothing to commit"
    fi

    if gh repo create "$repo_name" --private --source=. --remote=origin; then
        echo "Repository created successfully."
    else
        echo "Failed to create repository."
    fi

    git push -u origin master
}
```
