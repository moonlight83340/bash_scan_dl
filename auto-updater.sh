#!/bin/bash
#Author Gaëtan

selfUpdate() {
	set -o errexit
	#control for all argument, $1 the URL and $2 the filename
	
	FILE="$2.zip"
	UPDATE_BASE=$1
	UPDATESCRIPT="updateScript.sh"
	
	echo "Performing self-update..."
	# Download new version
	echo "Downloading latest version..."
	
	if ! wget --quiet --output-document="$FILE" $UPDATE_BASE/$FILE ; then
		echo "Failed: Error while trying to dowload the new version!"
		echo "File requested: $UPDATE_BASE/$FILE"
		exit 1
	fi 
	echo "Done."

	unzip $FILE -d "$2"
	
	# Copy over modes from old version
	OCTAL_MODE=$(stat -c '%a' "${0##*/}")
	if ! chmod -R $OCTAL_MODE "$2" ; then
		echo "Failed: Error while trying to set mode on $FILE."
		exit 1
	fi
	
	# Spawn update script
	cat > "$UPDATESCRIPT" << EOF
#!/bin/bash
# Overwrite old file with new
if mv $PWD/$2/* "$PWD"; then
  echo "Done. Update complete."
  rm \$0
else
  echo "Failed!"
fi
EOF
	chmod +x "$UPDATESCRIPT"
	echo "Inserting update process..."
	./$UPDATESCRIPT
}
