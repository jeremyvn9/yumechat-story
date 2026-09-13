Get-ChildItem .\src\*.twee | ForEach-Object {
    "`n`n<!-- SOURCE FILE: $($_.Name) -->`n"
    Get-Content $_.FullName
} | Set-Content .\full-story.twee