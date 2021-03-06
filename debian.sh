#! /bin/sh
# Configure your paths and filenames
SOURCEBINPATH=.
SOURCEDIR=goblin
SOURCEBIN=side.lua
SOURCELOC=goblin/side.lua
SOURCEDOC=README.md
DEBFOLDER=svirfneblin-goblin
DEBVERSION=20151120
if [ -n "$BASH_VERSION" ]; then
	TOME="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
else
	TOME=$( cd "$( dirname "$0" )" && pwd )
fi
cd $TOME
git pull origin master
DEBFOLDERNAME="$TOME/../$DEBFOLDER-$DEBVERSION"
DEBPACKAGENAME=$DEBFOLDER\_$DEBVERSION

# Copy your script to the source dir
cp -R $TOME $DEBFOLDERNAME/
cd $DEBFOLDERNAME

mkdir -p usr/share/doc/svirfneblin-goblin
cp README.md usr/share/doc/svirfneblin-goblin/README.md

pwd
# Create the packaging skeleton (debian/*)
dh_make --indep --createorig 

mkdir -p debian/tmp/usr

cp -R usr debian/tmp/usr
cp -R etc debian/tmp/etc
# Remove make calls
grep -v makefile debian/rules > debian/rules.new 
mv debian/rules.new debian/rules 
# debian/install must contain the list of scripts to install 
# as well as the target directory
echo etc/xdg/svirfneblin/rc.lua.$SOURCEDIR.example etc/xdg/svirfneblin > debian/install
echo etc/xdg/svirfneblin/$SOURCEDIR/quicklaunch/gedit etc/xdg/svirfneblin/$SOURCEDIR/quicklaunch >> debian/install
echo etc/xdg/svirfneblin/$SOURCELOC etc/xdg/svirfneblin/$SOURCEDIR >> debian/install
echo usr/share/doc/$DEBFOLDER/$SOURCEDOC usr/share/doc/$DEBFOLDER >> debian/install

echo "Source: $DEBFOLDER
Section: unknown
Priority: optional
Maintainer: cmotc <cmotc@openmailbox.org>
Build-Depends: debhelper (>= 9)
Standards-Version: 3.9.5
Homepage: https://www.github.com/cmotc/$DEBFOLDER
#Vcs-Git: git@github.com:cmotc/cmotc/$DEBFOLDER
#Vcs-Browser: https://www.github.com/cmotc/$DEBFOLDER

Package: $DEBFOLDER
Architecture: all
Depends: lightdm, lightdm-gtk-greeter, awesome (>= 3.4), ${misc:Depends}
Description: An awesomewm hideable quick-lauch widget.
" > debian/control

#echo "gsettings set org.gnome.desktop.session session-name awesome-gnome
#dconf write /org/gnome/settings-daemon/plugins/cursor/active false
#gconftool-2 --type bool --set /apps/gnome_settings_daemon/plugins/background/active false
#" > debian/postinst
# Remove the example files
rm debian/*.ex
rm debian/*.EX

# Build the package.
# You  will get a lot of warnings and ../somescripts_0.1-1_i386.deb
debuild -us -uc >> ../log
