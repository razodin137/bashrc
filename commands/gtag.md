```bash
gtag() {
  echo "🤖 Rebuilding agents_context.md and copying payload..."

  # 1. Gather Metadata & Context
  local BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "N/A")
  local STATUS=$(git status -s 2>/dev/null || echo "Clean.")
  local TODOS=$(grep -rEi "TODO:|FIXME:" . --exclude-dir={.git,node_modules,dist,build,bin,out,.next} | head -n 10 2>/dev/null)
  
  # Versioning
  local VERSION="N/A"
  [ -f "package.json" ] && VERSION=$(grep '"version":' package.json | cut -d'"' -f4)

  # 2. History with Impact Stats
  # Merges commit message and stats into one line for the AI
  local LOGS_TABLE=$(printf "| Hash | Message & Impact |\n| :--- | :--- |\n")
  local LOG_DATA=$(git log -n 10 --pretty=format:"| %h | %s" --shortstat 2>/dev/null | perl -pe 's/\n / /g')
  LOGS_TABLE+="${LOG_DATA:-"| N/A | No commits found |"}"

  # 3. Project Structure (Tree View)
  # Generates a map of your files, ignoring the "noise"
  local TREE=$(find . -maxdepth 3 -not -path '*/.*' -not -path './node_modules*' -not -path './dist*' -not -path './build*' | sed -e 's/[^-][^\/]*\// |/g' -e 's/|\([^ ]\)/|-\1/' | head -n 30)

  # 4. Assemble the Markdown
  cat <<EOF > agents_context.md
# Project Context
**Branch:** $BRANCH | **Version:** $VERSION | **Last Update:** $(date)

## 📂 Project Structure
\`\`\`text
$TREE
\`\`\`

## 📜 Recent History
$LOGS_TABLE

## 🛠 Files in Flux (Uncommitted)
\`\`\`text
${STATUS:-"No changes pending."}
\`\`\`

## 📝 AI Guidance
### 🎯 Next Steps & TODOs
${TODOS:-"- No automated TODOs found."}
- [ ] *Manual Entry: What is the current focus?*

### 🧠 Tech Stack & Debt
- **Tech Stack:** *Update this manually*
- **Known Issues:** *List any blockers here*
EOF

  # 5. Copy to Clipboard
  if command -v pbcopy >/dev/null 2>&1; then
    cat agents_context.md | pbcopy
  elif command -v clip.exe >/dev/null 2>&1; then
    cat agents_context.md | clip.exe
  elif command -v xclip >/dev/null 2>&1; then
    cat agents_context.md | xclip -selection clipboard
  fi

  echo "✅ agents_context.md updated & project tree mapped!"
}
```
