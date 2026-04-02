# Sync-Ch26ToTYOVA.ps1
# Reads TY_BOOK_CHAPTER_26 and outputs TypeScript-ready term entries
# for bookChapterContent.ts in TYOVA.
# Usage: Run from any directory.
# Output: tools\Ch26_sync_output.txt

$ch26Path = "E:\TY-Ecosystem\ty-ai-governance\book\TY_BOOK_CHAPTER_26_THE_TY_AI_OS_VOCABULARY.md"
$outputPath = "E:\TY-Ecosystem\ty-ai-governance\tools\Ch26_sync_output.txt"

function Format-Term {
    param([string]$term, [string[]]$contentLines)
    if ($contentLines.Count -eq 0) { return @() }

    $coinedLine = ""
    $definition = ""

    $combined = ($contentLines -join " ").Trim()

    # Extract inline *First coined: DATE* pattern
    if ($combined -match "^\*First coined:\s*(.+?)\*\s*(.*)$") {
        $coinedLine = "First coined: " + $Matches[1].Trim()
        $definition = $Matches[2].Trim()
    } elseif ($combined -match "^First coined:\s*(.+)") {
        $coinedLine = "First coined: " + $Matches[1].Trim()
        $definition = ""
    } else {
        $definition = $combined
    }

    $escapedTerm = $term -replace "'", "\'"
    $escapedCoined = $coinedLine -replace "'", "\'"
    $escapedDef = $definition -replace "'", "\'"

    $result = @()
    $result += "      {"
    $result += "        heading: '$escapedTerm',"
    $result += "        content: ["
    if ($coinedLine -ne "") {
        $result += "          '$escapedCoined',"
    }
    if ($definition -ne "") {
        $result += "          '$escapedDef',"
    }
    $result += "        ],"
    $result += "      },"
    return $result
}

$lines = Get-Content $ch26Path -Encoding UTF8
$inSection = $false
$currentSection = ""
$currentTerm = ""
$contentLines = @()
$allOutput = @()
$termCount = 0
$sectionCount = 0

foreach ($line in $lines) {
    $trimmed = $line.Trim()

    if ($trimmed -match "^## Update Log") {
        if ($currentTerm -ne "" -and $contentLines.Count -gt 0) {
            $allOutput += Format-Term $currentTerm $contentLines
            $termCount++
            $currentTerm = ""
            $contentLines = @()
        }
        break
    }

    if ($trimmed -match "^## Section \d+") {
        if ($currentTerm -ne "" -and $contentLines.Count -gt 0) {
            $allOutput += Format-Term $currentTerm $contentLines
            $termCount++
            $currentTerm = ""
            $contentLines = @()
        }
        $currentSection = $trimmed -replace "^## ", ""
        $inSection = $true
        $sectionCount++
        $allOutput += ""
        $allOutput += "      // --- $currentSection ---"
        $allOutput += "      {"
        $allOutput += "        heading: '',"
        $allOutput += "        partHeading: '$($currentSection -replace `"'`", `"\'")`',"
        $allOutput += "        content: [],"
        $allOutput += "      },"
        continue
    }

    if (-not $inSection) { continue }

    if ($trimmed -match "^\*\*(.+?)\*\*(.*)$") {
        if ($currentTerm -ne "" -and $contentLines.Count -gt 0) {
            $allOutput += Format-Term $currentTerm $contentLines
            $termCount++
        }
        $termCore = $Matches[1].Trim()
        $termExtra = $Matches[2].Trim()
        if ($termExtra -ne "") {
            $currentTerm = "$termCore $termExtra"
        } else {
            $currentTerm = $termCore
        }
        $contentLines = @()
        continue
    }

    if ($currentTerm -ne "" -and $trimmed -ne "") {
        if ($trimmed -notmatch "^\|") {
            $contentLines += $trimmed
        }
    }
}

if ($currentTerm -ne "" -and $contentLines.Count -gt 0) {
    $allOutput += Format-Term $currentTerm $contentLines
    $termCount++
}

$allOutput += ""
$allOutput += "// Total terms exported: $termCount"
$allOutput += "// Sections: $sectionCount"
$allOutput += "// Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm') San Diego"

[System.IO.File]::WriteAllLines($outputPath, $allOutput, [System.Text.Encoding]::UTF8)

Write-Host "Done."
Write-Host "Terms exported: $termCount"
Write-Host "Sections: $sectionCount"
Write-Host "Output: $outputPath"