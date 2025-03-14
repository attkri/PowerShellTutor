Describe "Module PowerShellTutor" -Tag 'Compliance' {

    Context 'Basis Modul Testing' {

        $testCases = Get-ChildItem "$PSScriptRoot\Public\*.ps1" -File -Force | ForEach-Object -Process { return @{ Path=$_.FullName } }

        It "Skript '<Path>' enthält keine Fehler." -TestCases $testCases  {
            $contents = Get-Content -Path $Path -ErrorAction Stop
            $errors = $null
            $null = [System.Management.Automation.PSParser]::Tokenize($contents, [ref]$errors)
            $errors.Count | Should -Be 0
        }

        It "Das Modul PowerShellTutor kann ohne Probleme importiert werden." {
            Remove-Module -Name 'PowerShellTutor' -Force -ErrorAction Ignore -WarningAction Ignore
            { Import-Module -Name "$PSScriptRoot\PowerShellTutor.psd1" -Force } | Should -Not -Throw
        }

        It "Das Module PowerShellTutor kann ohne Probleme  entladen werden." {
            Import-Module -Name "$PSScriptRoot\PowerShellTutor.psd1" -Force
            { Remove-Module -Name 'PowerShellTutor' -Force } | Should -Not -Throw
        }
    }

    Context 'Modul-Manifest Tests' {

        It 'Module Manifest ist erfolgreich validiert.' {
            { Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" -ErrorAction Stop -WarningAction SilentlyContinue } | Should -Not -Throw
        }
        It 'Modul-Name ist PowerShellTutor.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty Name | Should -Be 'PowerShellTutor'
        }
        It 'Modul-Version ist Neu' {
            Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty Version | Should -BeExactly '1.1'
        }
        It 'Modul-Description ist vorhanden.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty Description | Should -Not -BeNullOrEmpty
        }
        It 'Module-Root steht auf PowerShellTutor.psm1.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty RootModule | Should -Be 'PowerShellTutor.psm1'
        }
        It 'Modul GUID ist 7e9d3043-93b2-481f-a8ce-2f906d0ced6a.' {
            Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty Guid | Should -Be '7e9d3043-93b2-481f-a8ce-2f906d0ced6a'
        }
    }

    Context 'Exported Functions' {

        BeforeAll {
            Import-Module -Name $PSScriptRoot
            $Script:Manifest = Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1"
        }

        AfterAll {
            Remove-Module -Name 'PowerShellTutor' -Force -ErrorAction Ignore
        }

        It "Function Public\<FunctionName>.ps1 als ExportedFunction <FunctionName> im Manifest hinterlegt." -TestCases (
            Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -Exclude '*.Tests.ps1' | Select-Object -ExpandProperty Name | Foreach-Object -Process {
            @{ FunctionName = $_.Replace('.ps1', ''
            ) }
        }) {
            $ManifestFunctions = Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty ExportedFunctions | Select-Object -ExpandProperty Keys
            $FunctionName -in $ManifestFunctions | Should -Be $true
        }

        It "Ist die <FunctionName> im function:\-Laufwerk enthalten?" -TestCases (Get-Command -Module 'PowerShellTutor' -CommandType Function | ForEach-Object -Process {
            @{ FunctionName = $_.Name }
        }) {
            param(
                $FunctionName
            )

            Get-Item -Path "function:\$FunctionName" | Select-Object -ExpandProperty Name | Should -BeExactly $FunctionName
        }

        It "Ist die Manifest-Funktion <FunctionName> als Public\<FunctionName>.ps1 enthalten?" -TestCases (
            Test-ModuleManifest -Path "$PSScriptRoot\PowerShellTutor.psd1" | Select-Object -ExpandProperty ExportedFunctions | Select-Object -ExpandProperty Keys | ForEach-Object -Process { @{ FunctionName = $_ } }
            ) {
            param(
                $FunctionName
            )
            Test-Path -Path "$PSScriptRoot\Public\$FunctionName.ps1" | Should -BeTrue
        }
    }
}
