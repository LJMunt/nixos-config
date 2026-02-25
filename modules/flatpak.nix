{ config, pkgs, ...}:

{
   
     services.flatpak.enable = true;
     services.flatpak.package = pkgs.flatpak;
     
     system.activationScripts.flathub = ''
     	${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || true
	'';


}
