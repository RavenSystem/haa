#!/bin/bash
#       /-----------------------------------------------------------------------\
#       | HAA Binary File Downloader,                                           |
#       | Useful for downloading HAA Binary files for custom OTA update servers |
#       | Copyright (C) 2020 AJAX                                               |
#       |                                                                       |
#       | This program is free software: you can redistribute it and/or modify  |
#       | it under the terms of the GNU General Public License as published by  |
#       | the Free Software Foundation, either version 3 of the License, or     |
#       | (at your option) any later version.                                   |
#       |                                                                       |
#       | This program is distributed in the hope that it will be useful,       |
#       | but WITHOUT ANY WARRANTY; without even the implied warranty of        |
#       | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
#       | GNU General Public License for more details.                          |
#       |                                                                       |
#       | https://www.gnu.org/licenses/gpl-3.0.html                             |
#       \-----------------------------------------------------------------------/
#
download_haa(){
	echo "--------------------------------------------------------"
	echo
	version_meta=$(curl -s "https://api.github.com/repos/$owner/$repository/releases/tags/$version")
	validation=$(echo "$version_meta" | grep -Po '(?<="message": ")[^"]*')
	files=($(echo "$version_meta" | grep -Po '(?<="browser_download_url": ")[^"]*'))

	if [ -z "$validation" ]
	then
		if [ ! -d "$version" ]; then
			mkdir "$version"
		fi
		for i in "${files[@]}"
		do
			file_name="$(basename $i)"
			echo -n "Saving ./$version/$file_name ... "
			curl -sLo "./$version/$file_name" "$i"
			if [ "$?" -ne 0 ]
			then
				echo "Failed to retrieve, check connection or user permissions"
			else
				echo "Done"
			fi
		done
	else
		echo "Incorrect Version?"
	fi
}
owner="RavenSystem"
repository="haa"
echo
echo "============================================================="
echo "HAA Binary Downloader Copyright (C) 2020  AJAX
This program comes with ABSOLUTELY NO WARRANTY;
This is free software, and you are welcome to redistribute it
under certain conditions.
See the GNU General Public License for more details."
echo "============================================================="
echo
if [ -n "$1" ]; then
	version="$1"
	echo "Attempting to download the specified verion: $version"
	download_haa
else
	version=$(curl -s "https://api.github.com/repos/$owner/$repository/releases/latest" | grep -Po '(?<="tag_name": ")[^"]*')
	echo "Attempting to download the latest version: $version"
	download_haa
	echo
	echo -n "Copying latest files to: "
	pwd
	echo "--------------------------------------------------------"
	echo
	cp -v ./"$version"/* ./
fi
echo
rate_limit=$(curl -s "https://api.github.com/rate_limit" | grep -Pom 1 '(?<="limit": )[^,}]*')
rate_status=$(curl -s "https://api.github.com/rate_limit" | grep -Pom 1 '(?<="remaining": )[^,}]*')
echo "Github ratelimits unauthenticated request to $rate_limit per hour"
echo "this script uses two calls per run and you have $rate_status remaining"
echo
echo "Complete, exiting"
echo
