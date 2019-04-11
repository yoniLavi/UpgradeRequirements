#!/bin/bash -e
# Customize this script to automatically upgrade requirements.txt files in a python git repo
if [[ -z $1 ]]; then
    echo "Usage: $0 REPO-SSH-URL"
    exit 1
fi
repo=$1
repodir=$(basename "$repo" .git)

git clone "$repo"
cd "$repodir"

# For each requirements file:
find . -name requirements.txt | while read -r filename; do
    # Upgrade to known-good versions
    sed 's/Django.*/Django==1.11.19/' -i "$filename"
    sed 's/Flask.*/Flask==0.12.3/' -i "$filename"
    sed 's/Jinja2.*/Jinja2==0.12.3/' -i "$filename"

    # Future-proof by allowing compatible versions
    sed 's/==/~=/' -i "$filename"

    # Add newline if needed
    vi -escwq "$filename"

    # Show changes
    git --no-pager diff "$filename"
done

# Commit and push back
echo "******* All requirements upgrades completed successfully, pushing commit back *******"
git commit -am "Upgraded requirements to improve security"
git push

# Cleanup
cd ..
rm -rf "$repodir"
