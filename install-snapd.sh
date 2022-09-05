#
# Installation for snapd on debian 11 (bullseye) on chromeos crostini
#

set -e

source environment

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

# First, make sure all packages are up-to-date:
echo "Updating packages ..."
sudo apt update -y && sudo apt upgrade -y

# Now you need to install some dependencies and tools that we will be using:
echo "Installing needed dependencies ..."
sudo apt install "${depends[@]}" -y

# Now you will need to install libsquashfuse0 and squashfuse, you can manually compile these and link them,
# but for ease of use, you can just install their respective .deb packages for your ChromeOS Architecture.
# Snap will be installed at this point, but it will not successfully mount and install any Snaps,
# until you have libsquashfuse0 and squashfuse packages installed and linked.
echo "Downloading libsquashfuse0 ..."
if [ "${CPU}" == "amd64" ]; then
	wget "${debmirror}/${libsquashfuseamd64}"
elif [ "${CPU}" == "arm64" ]; then
	wget "${debmirror}/${libsqushfusearm64}"
fi

# Now after downloading the proper libsquashfuse0 from one of the commands above, you want to install it with dpkg.
echo "Installing libsquashfuse0 ..."
if [ "${CPU}" == "amd64" ]; then
	sudo dpkg -i "${libsquashfuseamd64}"
elif [ "${CPU}" == "arm64" ]; then
	sudo dpkg -i "${libsquashfusearm64}"
fi

# Now you will want to do the same thing with the squashfuse package as libsquashfuse0.
echo "Downloading squashfuse ..."
if [ "${CPU}" == "amd64" ]; then
	wget "${debmirror}/${squashfuseamd64}"
elif [ "${CPU}" == "arm64" ]; then
	wget "${debmirror}/${squashfusearm64}"
fi

# Now after downloading, the step is the same as above, run dpkg -i to install the *.deb package.
echo "Installing squashfuse ..."
if [ "${CPU}" == "amd64" ]; then
	sudo dpkg -i "${squashfuseamd64}"
elif [ "${CPU}" == "arm64" ]; then
	sudo dpkg -i "${squashfusearm64}"
fi

echo "Done."
exit $?
