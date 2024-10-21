reload() {
	source ~/.bash_profile
}

code() {
	flatpak run com.visualstudio.code $*
}

distrobox() {
	if [ $1 == "make" ]; then
		distroboxname=$2
		distroboxpath=$2

		if [ ! -z $3 ]; then
			distroboxpath=$3
		fi

		command distrobox create \
			--yes \
			--unshare-devsys \
			--unshare-groups \
			--unshare-ipc \
			--unshare-process \
			--name $distroboxname \
			--image docker.io/library/ubuntu:latest \
			--volume /media/xxx/Storage/Projects/$distroboxpath:/$distroboxpath \
			--home /media/xxx/Storage/home/$distroboxname \
			--init-hooks "sudo apt-get update && sudo apt-get upgrade && curl -fsSL https://deno.land/install.sh | sh && echo 'cd /$distroboxpath' >> ~/.bashrc" \
			--additional-packages "nodejs npm curl nano"
	else
		command distrobox $@
	fi
}
