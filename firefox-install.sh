#!/bin/sh

# AUTHOR: koalagang (https://github.com/koalagang)
# Dependencies: firefox-esr or firefox, wget, devour
# See the repository for this script at https://github.com/koalagang/firefox-config

command -v firefox-esr >/dev/null && browser='firefox-esr'
command -v firefox >/dev/null && browser='firefox'
[ -z "$browser" ] && echo 'error: missing firefox' && exit

profile_name="$1"

# Create profile
"$browser" -CreateProfile "$profile_name"
"$browser" -P "$profile_name" &
sleep 5
killall firefox-bin

#---Install add-ons
(
cd "$HOME/.mozilla/firefox/"*.$profile_name
mkdir extensions
cd extensions

# NoScript
if [ "$profile_name" = 'secure' ]; then
    wget -q --show-progress 'https://addons.mozilla.org/firefox/downloads/file/3916177/noscript_security_suite-11.3.7-an+fx.xpi'
    mv noscript*.xpi '{73a6fe31-595d-460b-a920-fcc0f8843232}.xpi'
elif [ "$profile_name" = 'school' ]; then
    wget -q --show-progress 'https://addons.mozilla.org/firefox/downloads/file/3913320/ublock_origin-1.41.8-an+fx.xpi'
    mv ublock_origin*.xpi 'uBlock0@raymondhill.net.xpi'
fi

# Cookie AutoDelete
wget -q --show-progress 'https://addons.mozilla.org/firefox/downloads/file/3711829/cookie_autodelete-3.6.0-an+fx.xpi'
mv cookie_autodelete*.xpi 'CookieAutoDelete@kennydo.com.xpi'

# Vimium C
wget -q --show-progress 'https://addons.mozilla.org/firefox/downloads/file/3903913/vimium_c-1.96.6-fx.xpi'
mv vimium_c*.xpi 'vimium-c@gdh1995.cn.xpi'

# Decentraleyes
wget -q --show-progress 'https://addons.mozilla.org/firefox/downloads/file/3902154/decentraleyes-2.0.17-an+fx.xpi'
mv decentraleyes*.xpi 'jid1-BoFifL9Vbdl2zQ@jetpack.xpi'

# Dark Reader
wget -q --show-progress 'https://addons.mozilla.org/firefox/downloads/file/3922130/dark_reader-4.9.47-an+fx.xpi'
mv dark_reader*.xpi 'addon@darkreader.org.xpi'

# Enable all add-ons and import their configurations
# Also customise toolbar
# Requires manual intervention
devour "$browser" -P "$profile_name"
)

# Install CSS template
cp -rv chrome "$HOME/.mozilla/firefox/"*".$profile_name"

# Configure preferences
cp -v user.js "$HOME/.mozilla/firefox/"*".$profile_name"

# Configure default search engine
cp -v search.json.mozlz4 "$HOME/.mozilla/firefox/"*".$profile_name"

# Change $profile_name to be the default profile and delete default profiles
# Requires manual intervention
devour "$browser" --ProfileManager
