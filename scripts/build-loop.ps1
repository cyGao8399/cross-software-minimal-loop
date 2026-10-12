param(
    [string]$InputCsv = (Join-Path $PSScriptRoot '..\data\customer_intake.csv'),
    [string]$ProjectRoot = (Join-Path $PSScriptRoot '..')
)

$ErrorActionPreference = 'Stop'
$rows = @(Import-Csv -LiteralPath $InputCsv)
if ($rows.Count -eq 0) {
    throw "输入 CSV 没有记录：$InputCsv"
}

$knowledgePath = Join-Path $ProjectRoot 'knowledge\客户需求知识卡片-自动生成.md'
$taskPath = Join-Path $ProjectRoot 'tasks\task_ledger.csv'
$evidencePath = Join-Path $ProjectRoot 'evidence\build-run.txt'

$lines = [System.Collections.Generic.List[string]]::new()
$lines.Add('# 客户需求知识卡片（自动生成）')
$lines.Add('')
$lines.Add('> 来源：飞书 Base 导出的脱敏 CSV；客户与人员均为虚构。')
$lines.Add('')
$lines.Add('- 输入文件：`data/customer_intake.csv`')
$lines.Add(('- 记录数量：' + $rows.Count))
$lines.Add('- 生成规则：每条客户需求生成一张可追溯卡片。')
$lines.Add('')

foreach ($row in $rows) {
    $lines.Add(('## ' + $row.record_id + ' · ' + $row.customer))
    $lines.Add('')
    $lines.Add(('- 需求：' + $row.requirement))
    $lines.Add(('- 来源：' + $row.source))
    $lines.Add(('- 负责人：' + $row.owner))
    $lines.Add(('- 状态：' + $row.status))
    $lines.Add(('- 优先级：' + $row.priority))
    $lines.Add(('- 截止日期：' + $row.due_date))
    $lines.Add(('- 验收标准：' + $row.acceptance_criteria))
    $lines.Add(('- 数据范围：' + $row.scope))
    $lines.Add('')
}

if ($lines.Count -gt 0 -and $lines[$lines.Count - 1] -eq '') {
    $lines.RemoveAt($lines.Count - 1)
}

Set-Content -LiteralPath $knowledgePath -Value $lines -Encoding utf8

$tasks = foreach ($row in $rows) {
    [pscustomobject]@{
        task_id = "TASK-$($row.record_id)"
        record_id = $row.record_id
        task = ('推进：' + $row.requirement)
        owner = $row.owner
        due_date = $row.due_date
        status = $row.status
        done_definition = $row.acceptance_criteria
    }
}
$tasks | Export-Csv -LiteralPath $taskPath -NoTypeInformation -Encoding utf8

@(
    "run_at=$([DateTime]::Now.ToString('s'))"
    "input=$InputCsv"
    "records=$($rows.Count)"
    "knowledge_output=$knowledgePath"
    "task_output=$taskPath"
    'result=success'
) | Set-Content -LiteralPath $evidencePath -Encoding utf8

Write-Output "success: processed $($rows.Count) records"
Write-Output "knowledge: $knowledgePath"
Write-Output "tasks: $taskPath"
