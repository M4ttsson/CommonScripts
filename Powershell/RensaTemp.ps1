Param
(
# ändra till true
	[parameter(Mandatory=$false, Position=0,
	HelpMessage="Path to clean")]
	[string]
	$Path="C:\Temp",

	[parameter(Mandatory=$false, Position=1,
	HelpMessage="File age before delete")]
	[int]
	$AgeUntilDelete=7
)

# skapa arraylists
$Script:FilesToDelete = {@()}.Invoke()

function F_GetFilesToDelete()
{
    $dateLimit = (Get-Date).AddDays(-$AgeUntilDelete)

    Get-ChildItem -Path $Path -Recurse | % {
        if ($_.LastAccessTime -lt $dateLimit)
        {
            if ($_.FullName -notlike "exclude*")
            {
                if ($_ -isnot [System.IO.DirectoryInfo])
                {
                    [void] $Script:FilesToDelete.Add($_.FullName)
                }
            }
        }
    }
    
}

function F_Delete([string]$path, [bool]$whatif)
{
    Write-Host "Deleting $path"
    if ($whatif)
    {
        Remove-Item -Path $path -WhatIf
    }
    else
    {
        Remove-Item -Path $path
    }
}

function F_DeleteFiles([switch]$whatif)
{
    $total = $Script:FilesToDelete.Count
    $counter = 0

    Write-Host "$total files to delete"
    $Script:FilesToDelete | % {
        F_Delete -path $_ $whatif
        $counter = $counter + 1
        Write-Host "Done $counter of $total"
    }
}

function F_DeleteFolders()
{
    $counter = 0
    Write-Host "Deleting empty folders"
    do {
    $dir = Get-ChildItem $Path -Directory -Recurse -Force
    $dirEmpty = $dir | Where-Object { (Get-ChildItem $_.FullName).Length -eq 0} | Select-Object -ExpandProperty FullName
    $dirEmpty | % {
        Write-Host "Delete $_" 
        Remove-Item $_ -Recurse -Force
    }
    } while ($dirEmpty.length -gt 0)
}


F_GetFilesToDelete 
F_DeleteFiles
F_DeleteFolders

#$Script:FoldersToDelete
