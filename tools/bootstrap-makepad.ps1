# Fetch the separately licensed public SDK; never overwrite an existing checkout.
$ErrorActionPreference = 'Stop'
$projectRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$sdkRoot = Join-Path $projectRoot '.deps/makepad'
$revision = '105158e08c89d47f57af4621420ed68eb3a147ce'

if (-not (Test-Path -LiteralPath $sdkRoot)) {
    New-Item -ItemType Directory -Force -Path (Split-Path $sdkRoot -Parent) | Out-Null
    & git clone --depth 1 --no-checkout https://github.com/makepad/makepad.git $sdkRoot
    if ($LASTEXITCODE -ne 0) { throw 'Public Makepad clone failed; existing files were retained.' }
    & git -C $sdkRoot fetch --depth 1 origin $revision
    if ($LASTEXITCODE -ne 0) { throw 'Public Makepad revision fetch failed.' }
    & git -C $sdkRoot checkout --detach $revision
    if ($LASTEXITCODE -ne 0) { throw 'Public Makepad revision checkout failed.' }
}

$item = Get-Item -LiteralPath $sdkRoot
if ($item.Attributes -band [IO.FileAttributes]::ReparsePoint) {
    throw 'A real SDK checkout is required; an existing link was left unchanged.'
}
$actualRoot = & git -C $sdkRoot rev-parse --show-toplevel
if ($LASTEXITCODE -ne 0 -or [IO.Path]::GetFullPath($actualRoot) -ne [IO.Path]::GetFullPath($sdkRoot)) {
    throw 'SDK Git root differs from the intended checkout.'
}
$actualRevision = & git -C $sdkRoot rev-parse HEAD
if ($LASTEXITCODE -ne 0 -or $actualRevision -ne $revision) {
    throw 'Existing SDK is not the reviewed public revision; it was left unchanged.'
}
$dirty = & git -C $sdkRoot status --porcelain --untracked-files=no
if ($LASTEXITCODE -ne 0 -or $dirty) { throw 'Existing SDK has tracked changes; it was left unchanged.' }
if (-not (Test-Path -LiteralPath (Join-Path $sdkRoot 'widgets/Cargo.toml') -PathType Leaf)) {
    throw 'SDK widgets manifest is missing.'
}
Write-Output "Public Makepad SDK verified at $actualRevision"
