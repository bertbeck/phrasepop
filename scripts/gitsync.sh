rsync -avc  \
  --exclude='.git' \
  --exclude='build' \
  --exclude='.dart_tool' \
  --exclude='.idea' \
  --exclude='.vscode' \
  --exclude='ios/Pods' \
  --exclude='node_modules' \
  /Users/bert/Downloads/phrasepop/ \
  ./