#
# Removal for snapd on debian 11 (bullseye) on chromeos crostini
#

set -e

# Define CPU architecture:
CPU=""

# Determine CPU architecture:
if lscpu | grep "Architecture" | grep "x86_64" > /dev/null; then
	CPU="amd64"
elif lscpu | grep "Architecture" | grep "aarch64" > /dev/null; then
	CPU="arm64"
else
	echo "Unsupported CPU architecture ..."; exit 1
fi

# Remove needed dependencies and tools.
echo "Remove needed dependencies ..."
sudo apt purge "${depends[@]}" -y
sudo apt autoremove -y

# remove libsquashfuse0.
echo "Removing libsquashfuse0 ..."
if [ "${CPU}" == "amd64" ]; then
	dpkg -r "${libsquashfuseamd64}"
elif [ "${CPU}" == "arm64" ]; then
	dpkg -r "${libsquashfusearm64}"
fi

# Remove squashfuse
echo "Removing squashfuse ..."
if [ "${CPU}" == "amd64" ]; then
	sudo dpkg -r "${squashfuseamd64}"
elif [ "${CPU}" == "arm64" ]; then
	sudo dpkg -r "${squashfusearm64}"
fi

echo "Done."
exit $?
