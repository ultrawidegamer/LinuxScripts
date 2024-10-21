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
			--name $distroboxname \
			--image docker.io/library/ubuntu:latest \
			--volume /media/xxx/Storage/Projects/$distroboxpath:/$distroboxpath \
			--init-hooks "sudo apt-get update && sudo apt-get upgrade" \
			--additional-packages "nodejs npm curl"
	else
		command distrobox $@
	fi
}
