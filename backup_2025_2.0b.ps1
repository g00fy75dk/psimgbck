# VIEWING SOFTWARE
# WINDOWS: https://interversehq.com/qview/
# ANDROID: https://github.com/oupson/jxlviewer

# SOFTWARE REQUIRED
# https://www.7-zip.org/download.html
# https://www.bulkrenameutility.co.uk/Download.php
# https://artifacts.lucaversari.it/libjxl/libjxl/latest/
# https://imagemagick.org/script/download.php

# DUPLICATE IMAGE FINDER (options)
# https://ermig1979.github.io/AntiDupl/english/index.html
# https://github.com/qarmin/czkawka/releases
# https://github.com/ermig1979/AntiDuplX

# if required to run as admin 
# Set-ExecutionPolicy UnRestricted

# clears the screen
Clear-Host

# set variables
$source = "\\192.168.0.3\temp"
#$source = "d:\img_test\source"
$destination = "d:\img_test\destination"
#$destination = "\\192.168.0.3\backup"
#$destination = "\\192.168.0.3\usbshare1"
#$destination = "\\192.168.0.2\usbshare2"
$rootfolder = "PICTURES"
$topfolders = (Get-ChildItem -Directory "$source\$rootfolder").Where({$_.Name.Length -eq 3}) | Select-Object -ExpandProperty Name
$extensions = (".gif",".png",".bmp",".emf",".webp")
$unwanted = (".html",".txt",".nfo",".db",".idx",".diz",".url",".exe",".download",".css")
$startdate = Get-Date
$logname = (Get-Date).tostring("ddMMyy_HHmmss") + "_log.txt"
$total = 0
$new = 0
$updated = 0
$exists = 0
[Ref]$converted = 0
if ( (Get-CimInstance -ClassName Win32_Processor | Measure-Object -Property NumberOfCores -Sum).Sum -ge 4 ) { $corval = 3 } else { $corval = 1 }
if ( (Get-CimInstance win32_networkadapter -filter "netconnectionstatus = 2" | Select-Object -ExpandProperty Speed)[0]/1000000000 -gt 2 ) { $nicval = 2 } else { $nicval = 1 } 
$limit = $corval + $nicval

# set aliases
set-alias 7z "$env:ProgramFiles\7-Zip\7z.exe"
set-alias brc "$env:ProgramFiles\Bulk Rename Utility\cli\brc64.exe"
set-alias cjxl "$env:ProgramFiles\jxl\cjxl.exe"
set-alias magick "$env:ProgramFiles\ImageMagick\magick.exe"

# check if applications are avaiable
function checkapp($arg1)
{
    if ( ![system.io.file]::Exists("$arg1") )
    {
        Write-Host "Application $arg1 not installed..." -foregroundcolor "red"
        break
    }
}

# check target and source
function checktarget($arg1)
{
    if ( ![system.io.directory]::Exists("$arg1") )
    {
        Write-Host "$(("$arg1").Split("\")[-1]) folder unavailable..." -foregroundcolor "red" 
        break
    }
}

function Write-Log($arg1)
{
    Add-Content -LiteralPath $destination\$rootfolder\$logname -Value $arg1 -Encoding UTF8
}

# archive images in parallel and set archive time with most recent modified file
function turboarchiveimg($arg1)
{
    while ([System.Diagnostics.Process]::GetProcessesByName('7z').Count -gt $limit) { Start-Sleep -Milliseconds 500 }
    Write-Log("Creating archive: $destination\$rootfolder\$topfolder\$($arg1.split("\")[-1]).zip")
    Start-Process -NoNewWindow (get-alias 7z).Definition -ArgumentList "-mx0 a -tzip -stl `"$destination\$rootfolder\$topfolder\$($arg1.split("\")[-1]).zip`" `"$arg1`" -bso0 -bsp0"
}

# tidy extensions
function renameimg($arg1)
{
    brc /QUIET /EXECUTE /TIDYDS /NOFOLDERS /NODUP /PATTERN:"*.jpg.crdownload *.jfif *.jpeg *.jpe *.jpg-large" /FIXEDEXT:".jpg" /DIR:"$arg1"
}

# loop through and remove unwanted files
function removestuff($arg1)
{    
    foreach ($file in [System.IO.Directory]::EnumerateFiles($arg1, "*", [System.IO.SearchOption]::AllDirectories))
    {
        if (([System.IO.FileInfo]$file).Length -eq 0)
        {
            Remove-Item -force -literalpath "$file" >$null 2>&1
            if (!$?) { Write-Log("Unable to remove file: $file") }
            continue
        }
        if ($unwanted -contains [System.IO.Path]::GetExtension($file))
        #if ($unwanted -contains ([System.IO.FileInfo]$file).Extension)
        {
            Remove-Item -force -literalpath "$file" >$null 2>&1
            if (!$?) { Write-Log("Unable to remove file: $file") }
        }
    }
}


# change folder-date to that of latest file/folder and remove empty folders
function fixdate($arg1)
{
    $dateorg = [datetime]::MinValue.Ticks
    foreach ( $file in [System.IO.Directory]::EnumerateFileSystemEntries($arg1) )
    {
        if ( [System.IO.File]::GetLastWriteTime($file).Ticks -gt $dateorg )
        {
            $dateorg=[System.IO.File]::GetLastWriteTime($file).Ticks
        }        
    }
    if ( $dateorg -gt [datetime]::MinValue.Ticks )
    {
        [System.IO.Directory]::SetLastWriteTime($arg1, $dateorg)
    }
    else
    {
        Write-Log("Deleted empty folder: $arg1")
        Remove-Item -force -LiteralPath "$arg1" >$null 2>&1
    }
}

# get image type
function chckimg($arg1) {
    # Read first 512 bytes (JPEG subtype markers appear later)
    # Convert Int32 → Byte (0–255)
    $bytes = $(Get-Content -LiteralPath $arg1 -AsByteStream -TotalCount 512) | ForEach-Object { [byte]$_ }
    # --- WEBP (RIFF....WEBPVP8?) ---
    if ($bytes.Length -ge 16 -and
        $bytes[0] -eq 0x52 -and $bytes[1] -eq 0x49 -and $bytes[2] -eq 0x46 -and $bytes[3] -eq 0x46) {
        # Extract VP8?, bytes 12–15
        $codec = -join ($bytes[12..15] | ForEach-Object { [char]$_ })
        # if jpg image is webp, set correct extenstion
        Rename-Item -LiteralPath $arg1 -NewName ([System.IO.Path]::ChangeExtension($arg1, ".webp"))
        # function only works on folder, but im lazy...
        convertimg ("$([System.IO.Path]::GetDirectoryName($arg1))")
        return "WEBP ($codec)"
    }
    # --- JPEG (FF D8 FF) ---
    if ($bytes.Length -ge 3 -and
        $bytes[0] -eq 0xFF -and $bytes[1] -eq 0xD8 -and $bytes[2] -eq 0xFF) {
        # Look for baseline (FFC0) or progressive (FFC2)
        for ($i = 0; $i -lt $bytes.Length - 1; $i++) {
            if ($bytes[$i] -eq 0xFF) {
                switch ($bytes[$i+1]) {
                    0xC0 { return "JPEG (Baseline)" }
                    0xC2 { return "JPEG (Progressive)" }
                }
            }
        }
        return "JPEG (Subtype not found)"
    }
}

# convert to jpg and remove original (should be changed directly to JXL eventually)
function convertimg($arg1)
{
    foreach ($file in [System.IO.Directory]::EnumerateFiles($arg1, "*", 'AllDirectories'))
    {
        $ext = [System.IO.Path]::GetExtension($file)
        if ($extensions -contains $ext)
        {
            $folder = [System.IO.Path]::GetDirectoryName($file)
            $newfile = Join-Path $folder ([System.IO.Path]::GetFileNameWithoutExtension($file) + ".jpg")
            magick -quality 92 $file $newfile
            if ([System.IO.File]::Exists($newfile))
            {
                [System.IO.File]::SetLastWriteTime($newfile, [System.IO.File]::GetLastWriteTime($file))
                Remove-Item -Force -LiteralPath $file
                Write-Log("Converted file: $file")
                $converted.Value++
            }
            else
            {
                Write-Log("Issues with conversion: $file")
            }
        }
    }
}


# convert jpg to jxl(lossless) with orignal date-time and remove original
function losslessjxl($arg1)
{
    foreach ($file in [System.IO.Directory]::EnumerateFiles($arg1, "*.jpg", 'AllDirectories'))
    {
        $leftpart = [System.IO.Path]::GetFileNameWithoutExtension("$file")+".jxl"
	    $joinedvar = "$file".TrimEnd("$file".split("\")[-1])+"$leftpart"
        cjxl "$file" "$joinedvar" --lossless_jpeg=1 --quiet >$null 2>&1
        if ( [System.IO.File]::Exists("$joinedvar") )
        {
            [System.IO.File]::SetLastWriteTime($joinedvar, $([System.IO.File]::GetLastWriteTime($file).Ticks))
            Remove-Item -force -literalpath $file
            Write-Log("Converted file: $file")
            $converted.Value++
        }
        else
        {
            Write-Log("Issues with conversion, trying alternatives...")
            # checks if jpg is webp, renames and converts to jxl
            Write-Log(chckimg $file)
            # extract all information to determine image format and setting default values if issues
            $info = magick identify -verbose "$file" 2>$null
            # sampling
            $parts = (($line = ($info | Select-String "jpeg:sampling-factor" | Select-Object -First 1)) ? $line.ToString().Split(":")[2].Trim().Split(",")[0].Split("x") : $null)
            if ($parts.Count -ge 2)
            {
                $jpegSampling = "4:{0}:{1}" -f $parts[0], $parts[1]
            }
            else
            {
                $jpegSampling = "4:2:2"
            }
            # quality
            $quality = ( ($m = $info | Select-String "Quality:" 2>$null) ? ($m.ToString().Split(":")[1].Trim()) : 92 )
            # re-encode image to fix errors
            magick  $file -sampling-factor $jpegSampling -quality $quality -strip "$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" >$null 2>&1
            # convert image
            cjxl --quiet --lossless_jpeg=1 "$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" "$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file)).jxl" >$null 2>&1
            # retry with fixed values on error
            if (!$?)
            {
                magick $file -colorspace sRGB -sampling-factor 4:2:2 -quality $quality -strip "$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" >$null 2>&1
                cjxl --quiet --lossless_jpeg=1 "$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg" "$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file)).jxl" >$null 2>&1
            }
            # if new jxl file exists set orignal date and delete jpg
            if ( [System.IO.File]::Exists("$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file)).jxl") )
            {
                [System.IO.File]::SetLastWriteTime("$([System.IO.Path]::GetDirectoryName($file))\$([System.IO.Path]::GetFileNameWithoutExtension($file)).jxl", [System.IO.File]::GetLastWriteTime("$file"))
                Remove-Item $file, (Join-Path (Split-Path $file) ("$([System.IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg")) >$null 2>&1
            }
            else
            {
                Remove-Item (Join-Path (Split-Path $file) ("$([System.IO.Path]::GetFileNameWithoutExtension($file))-clean.jpg")) >$null 2>&1
                Write-Log("Unable to convert, maybe [$file] is corrupt?")
            }
        }
    }
}

# loops through all folders individually to allow output after each folder is processed
function loopthrough()
{
    foreach ($folder in @("$source\$rootfolder\$topfolder\$subfolder") + [System.IO.Directory]::EnumerateDirectories("$source\$rootfolder\$topfolder\$subfolder", "*", 'AllDirectories'))
    {
        removestuff $folder
        renameimg $folder
        convertimg $folder
        losslessjxl $folder
        fixdate $folder
    }
}

# output information
function textout($arg1, $arg2)
{
    Write-Host "$topfolder" "- " -f gray -nonewline; Write-Host "$subfolder" -f white -nonewline; Write-Host " $arg1" -f "$arg2"
}


# -------------------------------------------------
# MAIN PROGRAM
# -------------------------------------------------

# check if programs are installed and available
checkapp (get-alias brc).Definition
checkapp (get-alias 7z).Definition
checkapp (get-alias magick).Definition
checkapp (get-alias cjxl).Definition

# check if SOURCE and DESTINATION are available
checktarget $source
checktarget $destination

# create subfolder in target
if ( ![system.io.directory]::Exists("$destination\$rootfolder") )
{
    New-Item -ItemType directory -Path "$destination\$rootfolder" | Out-Null
}

# loop through only select top-level folders...
foreach ( $topfolder in $topfolders )
{
    foreach ( $subfolder in [system.io.directory]::EnumerateDirectories("$source\$rootfolder\$topfolder") | ForEach-Object { $_.split("\")[-1] } )
    {
        # skip empty topfolders
        if ([System.IO.Directory]::EnumerateFiles("$source\$rootfolder\$topfolder\$subfolder","*", 'AllDirectories').GetEnumerator().MoveNext())
        {
            # create archive if none exists
            if ( ![System.IO.File]::Exists("$destination\$rootfolder\$topfolder\$subfolder.zip") )
            {
                textout new green
                $new++
                loopthrough
                turboarchiveimg $source\$rootfolder\$topfolder\$subfolder
            }
            else
            {
                # update existing archive or skip if unchanged
                if ( [System.IO.Directory]::GetLastWriteTime("$source\$rootfolder\$topfolder\$subfolder") -gt [System.IO.File]::GetCreationTime("$destination\$rootfolder\$topfolder\$subfolder.zip") )
                {
                    textout updated yellow
                    $updated++
                    loopthrough
                    turboarchiveimg $source\$rootfolder\$topfolder\$subfolder
                }
                else
                {
                    textout exists darkgreen
                    $exists++
                }
            }
        }
    }
}

# wait until all 7zip instances are finished
while ([System.Diagnostics.Process]::GetProcessesByName('7z').Count -gt $limit) { Start-Sleep -Milliseconds 500 }

# write start and end time to log
Write-Log "`nSTARTED: $startdate"
Write-Log "FINISHED: $(Get-Date)"

# count number of files in each subfolder and add to total
foreach ($folder in [System.IO.Directory]::EnumerateDirectories("$destination\$rootfolder"))
{
    $total += [System.IO.Directory]::GetFiles($folder).Length
}

# display data and write to log
write-host "`nTotal number of archives: $total"
Write-Log "Total number of archives: $total"
write-host "New archives: $new"
Write-Log "New archives: $new"
write-host "Updated archives: $updated"
Write-Log "Updated archives: $updated"
write-host "Existing archives: $exists"
Write-Log "Existing archives: $exists"
write-host "Number of converted images: $($converted.Value)"
Write-Log "Number of converted images: $($converted.Value)"

# parse log for errors
$errors = (select-string $destination\$rootfolder\$logname -pattern "error:")
if ( $errors.count -ge 1 )
{ write-host $errors.count "Error(s) found in log!" -foregroundcolor "red" }
else
{ write-host "No errors in log!" -foregroundcolor "green" }

# parse log for issues
$issues = (select-string $destination\$rootfolder\$logname -pattern "issues")
if ( $issues.count -ge 1 )
{ write-host $issues.count "Issue(s) found in log!" -foregroundcolor "yellow" }
else
{ write-host "No issues in log!" -foregroundcolor "green" }

# parse log for corrupt files
$corrupt = (select-string $destination\$rootfolder\$logname -pattern "corrupt")
if ( $corrupt.count -ge 1 )
{ write-host $corrupt.count "Corrpt file(s) found in log!" -foregroundcolor "red" }
else
{ write-host "No issues in log!" -foregroundcolor "green" }

# parse log for deleted empty folders
$empty = (select-string $destination\$rootfolder\$logname -pattern "empty")
if ( $empty.count -ge 1 )
{ write-host $empty.count "empty folders deleted" -foregroundcolor "yellow" }

# append current date and size to folder name
$newname = "$rootfolder ({0:N2}GB, $total Files)" -f ((([System.IO.DirectoryInfo]"$destination\$rootfolder").GetFiles("*", "AllDirectories") | Measure-Object -Property Length -Sum).Sum / 1GB)

# Force release of lazy file handles from Select-String
[System.GC]::Collect()
[System.GC]::WaitForPendingFinalizers()
Rename-Item -literalpath "$destination\$rootfolder" "$destination\$newname"
