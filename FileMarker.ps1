# SQL File Marker - Quick file prefix management
# Usage: Load this script, then use the functions below

# Helper function to remove existing prefixes
function Remove-Prefix {
    param([string]$Name)
    $prefixes = @('TODO_', 'REVIEW_', 'FIX_', 'DRAFT_', 'PRIORITY_', '⚠️_', '⭐_', '✅_')
    foreach ($prefix in $prefixes) {
        if ($Name.StartsWith($prefix)) {
            return $Name.Substring($prefix.Length)
        }
    }
    return $Name
}

# Mark file as PRIORITY
function Mark-Priority {
    param([string]$FileName)
    if (Test-Path $FileName) {
        $baseName = Remove-Prefix (Get-Item $FileName).Name
        $newName = "PRIORITY_$baseName"
        Rename-Item -LiteralPath $FileName -NewName $newName
        Write-Host "✓ Marked as PRIORITY: $newName" -ForegroundColor Green
    }
}

# Mark file as TODO
function Mark-Todo {
    param([string]$FileName)
    if (Test-Path $FileName) {
        $baseName = Remove-Prefix (Get-Item $FileName).Name
        $newName = "TODO_$baseName"
        Rename-Item -LiteralPath $FileName -NewName $newName
        Write-Host "✓ Marked as TODO: $newName" -ForegroundColor Yellow
    }
}

# Mark file as REVIEW
function Mark-Review {
    param([string]$FileName)
    if (Test-Path $FileName) {
        $baseName = Remove-Prefix (Get-Item $FileName).Name
        $newName = "REVIEW_$baseName"
        Rename-Item -LiteralPath $FileName -NewName $newName
        Write-Host "✓ Marked as REVIEW: $newName" -ForegroundColor Cyan
    }
}

# Mark file as FIX
function Mark-Fix {
    param([string]$FileName)
    if (Test-Path $FileName) {
        $baseName = Remove-Prefix (Get-Item $FileName).Name
        $newName = "FIX_$baseName"
        Rename-Item -LiteralPath $FileName -NewName $newName
        Write-Host "✓ Marked as FIX: $newName" -ForegroundColor Red
    }
}

# Mark file as DRAFT
function Mark-Draft {
    param([string]$FileName)
    if (Test-Path $FileName) {
        $baseName = Remove-Prefix (Get-Item $FileName).Name
        $newName = "DRAFT_$baseName"
        Rename-Item -LiteralPath $FileName -NewName $newName
        Write-Host "✓ Marked as DRAFT: $newName" -ForegroundColor Gray
    }
}

# Remove all prefixes
function Clear-Mark {
    param([string]$FileName)
    if (Test-Path $FileName) {
        $item = Get-Item $FileName
        $newName = Remove-Prefix $item.Name
        if ($newName -ne $item.Name) {
            Rename-Item -LiteralPath $FileName -NewName $newName
            Write-Host "✓ Cleared prefix: $newName" -ForegroundColor White
        } else {
            Write-Host "No prefix to remove" -ForegroundColor Gray
        }
    }
}

# Show all marked files in current directory
function Show-Marked {
    Write-Host "`nMarked Files (current folder):" -ForegroundColor Cyan
    Get-ChildItem -File -Filter "PRIORITY_*.sql" | ForEach-Object { Write-Host "  [PRIORITY] $($_.Name)" -ForegroundColor Green }
    Get-ChildItem -File -Filter "TODO_*.sql" | ForEach-Object { Write-Host "  [TODO]     $($_.Name)" -ForegroundColor Yellow }
    Get-ChildItem -File -Filter "REVIEW_*.sql" | ForEach-Object { Write-Host "  [REVIEW]   $($_.Name)" -ForegroundColor Cyan }
    Get-ChildItem -File -Filter "FIX_*.sql" | ForEach-Object { Write-Host "  [FIX]      $($_.Name)" -ForegroundColor Red }
    Get-ChildItem -File -Filter "DRAFT_*.sql" | ForEach-Object { Write-Host "  [DRAFT]    $($_.Name)" -ForegroundColor Gray }
}

# Show all marked files recursively (all subfolders)
function Show-AllMarked {
    Write-Host "`nAll Marked Files (recursive):" -ForegroundColor Cyan
    
    $priority = Get-ChildItem -File -Filter "PRIORITY_*.sql" -Recurse
    $todo = Get-ChildItem -File -Filter "TODO_*.sql" -Recurse
    $review = Get-ChildItem -File -Filter "REVIEW_*.sql" -Recurse
    $fix = Get-ChildItem -File -Filter "FIX_*.sql" -Recurse
    $draft = Get-ChildItem -File -Filter "DRAFT_*.sql" -Recurse
    
    if ($priority) {
        Write-Host "`n  PRIORITY:" -ForegroundColor Green
        $priority | ForEach-Object { Write-Host "    $($_.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Green }
    }
    if ($todo) {
        Write-Host "`n  TODO:" -ForegroundColor Yellow
        $todo | ForEach-Object { Write-Host "    $($_.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Yellow }
    }
    if ($review) {
        Write-Host "`n  REVIEW:" -ForegroundColor Cyan
        $review | ForEach-Object { Write-Host "    $($_.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Cyan }
    }
    if ($fix) {
        Write-Host "`n  FIX:" -ForegroundColor Red
        $fix | ForEach-Object { Write-Host "    $($_.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Red }
    }
    if ($draft) {
        Write-Host "`n  DRAFT:" -ForegroundColor Gray
        $draft | ForEach-Object { Write-Host "    $($_.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Gray }
    }
    
    $total = ($priority.Count + $todo.Count + $review.Count + $fix.Count + $draft.Count)
    Write-Host "`n  Total: $total marked files" -ForegroundColor White
}

# Help
function Show-MarkHelp {
    Write-Host @"

SQL File Marker Commands:
--------------------------
Mark-Priority "file.sql"   - Mark as high priority
Mark-Todo "file.sql"       - Mark as needs work
Mark-Review "file.sql"     - Mark as needs review
Mark-Fix "file.sql"        - Mark as has issues
Mark-Draft "file.sql"      - Mark as work in progress
Clear-Mark "file.sql"      - Remove all prefixes
Show-Marked                - List marked files in current folder
Show-AllMarked             - List ALL marked files (recursive)
Show-MarkHelp              - Show this help

Example: Mark-Priority "NoOwnerGroup.sql"

"@ -ForegroundColor White
}

Write-Host "`n✓ File Marker loaded! Type 'Show-MarkHelp' for commands.`n" -ForegroundColor Green
