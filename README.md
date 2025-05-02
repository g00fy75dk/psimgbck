I had been looking for a backup script (powershell) that could traverse a specific folder structure and, instead of a simple copy, archive each subfolder, making it easier to manage the backup.

Since I could not find something that would do exactly what I wanted, I did read other posts where others seemed to look for something similar, so I decided to give it a try myself.

Hopefully this script will have some ideas that others might find useful for their own projects.

It can be a bit difficult to read, as I had to replace the command "get-childitem" with the much, much faster "[System.IO.Directory", but the increase in speed was unbelievable!

As with all "projects" extra features got added and now the following is handled by the script:
.image folder are cleared of non-image files
.image files are renamed with correct extension
.images are converted into the same format
.images in jpg are losslesly converted to jxl
.images are archived for easier management

All features are functions, so they can individually be enabled or disabled.
The processing is done in parallel to speed things up significantly.
PowerShell commands have been tweaked to be as fast as possible.

I was not able to get ImageMagic to encode losslessly into JXL.
Maybe when the format is a bit more mature this will change.
So for now, there is a two-step approach of first converting to jpg and then using the native tools for the jxl-lossless convertion (which is still ~20% smaller).
