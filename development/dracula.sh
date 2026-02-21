export DCONF_PROFILE=/home/john/.config/home-manager/test-profile
dconfdir=/org/gnome/terminal/legacy/profiles:
profile_id="$(uuidgen)"
echo old
old_ids="$(dconf read ${dconfdir}/list | tr -d ']')"
echo ${old_ids}
dconf write "${dconfdir}/list" "${old_ids}, '${profile_id}']"

# gotta do it this way because dconf write doesn't work (key doesn't exist)
profile_dump="$(dconf dump ${dconfdir}/)"
printf "${profile_dump}\n\n[:${profile_id}]\nvisible-name='dracula'" | dconf load ${dconfdir}/

./install.sh --scheme=Dracula --profile=dracula --skip-dircolors
