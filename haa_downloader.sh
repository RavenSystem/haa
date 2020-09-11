#!/bin/bash
#HAA Binary downloader By AJAX
download_haa(){
        echo "--------------------------------------------------------"
        echo ""
        validation=$(curl -s "https://api.github.com/repos/RavenSystem/haa/releases/tags/$version" | grep -Po '(?<="message": ")[^"]*')
        if [ -z "$validation" ]
        then
                if [ ! -d "$version" ]; then
                        mkdir "$version"
                fi
                for i in "${files[@]}"
                do
                        file_name="$(basename $i)"
                        echo -n "Saving ./$version/$file_name ... "
                        wget -qO "$version/$file_name" "$i"
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

files=($(curl -s "https://api.github.com/repos/RavenSystem/haa/releases/tags/3.1.2" | grep -Po '(?<="browser_download_url": ")[^"]*'))
echo ""
if [ -n "$1" ]; then
        version="$1"
        folder="$version/"
        echo "Attempting to download the specified verion: $version"
        download_haa
else
        version=$(curl -s "https://api.github.com/repos/RavenSystem/haa/releases/latest" | grep -Po '(?<="tag_name": ")[^"]*')
        echo "Attempting to download the latest version: $version"
        folder="$version/"
        download_haa
        echo ""
        echo -n "Copying latest files to: "
        pwd
        echo "--------------------------------------------------------"
        echo ""
        cp -v ./"$folder"* ./
fi
echo ""
echo "Complete, exiting"
echo ""
