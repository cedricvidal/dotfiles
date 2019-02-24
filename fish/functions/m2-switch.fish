function m2-switch
	echo "Switching to Maven settings $argv[1]"
	ln -sf ~/.m2/settings.$argv[1].xml ~/.m2/settings.xml
end
