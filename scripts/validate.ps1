$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
$files = @(Get-ChildItem (Join-Path $root 'workflows') -Filter '*.json')
if ($files.Count -ne 2) { throw 'Expected two workflow variants.' }
foreach ($file in $files) {
 $w = Get-Content -Raw $file.FullName | ConvertFrom-Json -AsHashtable
 if ($w.active -ne $false -or $w.pinData.Count -ne 0) { throw 'Workflow must be inactive with no pinned data.' }
 foreach ($key in @('id','versionId','meta')) { if ($w.ContainsKey($key)) { throw "Deployment metadata remains: $key" } }
 $names=@($w.nodes.name)
 if (@($names | Select-Object -Unique).Count -ne $names.Count) { throw 'Duplicate node names.' }
 foreach ($node in $w.nodes) {
  if ($node.ContainsKey('credentials') -or $node.ContainsKey('webhookId')) { throw 'Private node metadata remains.' }
  if ($node.parameters.documentId -and $node.parameters.documentId.value -ne 'YOUR_GOOGLE_SHEET_ID') { throw 'Unexpected spreadsheet reference.' }
  if ($node.type -eq 'n8n-nodes-base.telegram' -and $node.parameters.chatId -ne 'YOUR_TELEGRAM_CHAT_ID') { throw 'Unexpected recipient.' }
  if ($node.type -eq 'n8n-nodes-base.slack' -and $node.parameters.channelId.value -ne '#YOUR_SLACK_CHANNEL') { throw 'Unexpected channel.' }
 }
 foreach ($entry in $w.connections.GetEnumerator()) {
  if ($entry.Key -notin $names) { throw 'Missing source node.' }
  foreach ($ports in $entry.Value.Values) { foreach ($port in $ports) { foreach ($edge in $port) { if ($edge.node -notin $names) { throw 'Missing destination node.' } } } }
 }
 $withSlack=$file.Name -like '*.with-slack.json'
 if ($w.nodes.Count -ne $(if($withSlack){11}else{10})) { throw 'Unexpected node count.' }
 $next=if($withSlack){'Send a message'}else{'If'}
 if ($w.connections['Create a draft'].main[0][0].node -ne $next) { throw 'Wrong Gmail routing.' }
 if (-not $withSlack -and @($w.nodes | Where-Object type -eq 'n8n-nodes-base.slack').Count) { throw 'Slack remains in default.' }
 Write-Output "PASS: $($file.Name)"
}
$patterns=@('sk-[A-Za-z0-9_-]{20,}','gh[pousr]_[A-Za-z0-9]{20,}','github_pat_[A-Za-z0-9_]{20,}','xox[baprs]-[A-Za-z0-9-]{15,}','-----BEGIN .*PRIVATE KEY-----','https://docs\.google\.com/spreadsheets/d/[A-Za-z0-9_-]{20,}','\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b')
foreach($file in Get-ChildItem $root -Recurse -File -Force | Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' -and $_.FullName -ne $PSCommandPath }) {
 $text=Get-Content -Raw $file.FullName
 foreach($pattern in $patterns) { if ($text -match $pattern) { throw "Potential sensitive content in $($file.Name); inspect privately." } }
}
Write-Output 'PASS: publication pattern scan (heuristic, not exhaustive).'
