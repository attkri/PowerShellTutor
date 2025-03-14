#region Public Cmdlets-Code ausführen 

Get-ChildItem "$PSScriptRoot\Public\*.ps1" -PipelineVariable cmdlet -Exclude '*.Tests.ps1' |  ForEach-Object -Process {
    . $cmdlet.FullName
}

#endregion

#region Aufräumarbeiten bei Remove-Module -Name AKPT

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {}

#endregion