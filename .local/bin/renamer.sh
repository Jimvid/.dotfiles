#!/bin/bash

echo "This script will run on all the files in the current folder."

read -p "Enter the text to search for within the filenames: " search_text

escaped_search_text=$(echo "$search_text" | sed 's/[][\/.^$*+?()[{|\-]/\\&/g')

read -p "Enter the replacement text (can be empty for removal): " replace_text

if [[ "$replace_text" == "<space>" ]]; then
    replace_text=" "
fi

echo "Preview of changes:"
matched_files=0
for file in *; do
    if [ -f "$file" ]; then
        new_name=$(echo "$file" | sed "s/$escaped_search_text/$replace_text/Ig")
        if [ "$file" != "$new_name" ]; then
            echo "$file -> $new_name"
            ((matched_files++))
        fi
    fi
done

if [ $matched_files -eq 0 ]; then
    echo "No files matched the criteria for renaming."
    exit 0
fi

read -p "Do you want to proceed with renaming these $matched_files file(s)? (y/n): " confirm

if [[ $confirm == [Yy]* ]]; then
    renamed_files=0
    for file in *; do
        if [ -f "$file" ]; then
            new_name=$(echo "$file" | sed "s/$escaped_search_text/$replace_text/Ig")
            if [ "$file" != "$new_name" ]; then
                mv "$file" "$new_name"
                ((renamed_files++))
            fi
        fi
    done
    echo "Renaming complete. $renamed_files file(s) were renamed."
else
    echo "Operation cancelled."
fi
