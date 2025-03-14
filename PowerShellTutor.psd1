@{
      #
      # MODUL-INFORMATION
      #

      GUID                  = '7e9d3043-93b2-481f-a8ce-2f906d0ced6a'
      Description           = 'A PowerShell module supports the trainer in creating and carrying out PowerShell training, workshops and training.'
      ModuleVersion         = '1.1'
      RootModule            = 'PowerShellTutor.psm1'

      #
      # AUTHOR
      #

      Author                = 'Attila Krick'
      CompanyName           = 'ATTILAKRCK.COM'
      Copyright             = '(c) 2024 Attila Krick. All rights reserved.'

      #
      # REQUIREMENTS
      #

      PowerShellVersion     = '7.4'
      ProcessorArchitecture = 'None'
      CompatiblePSEditions  = @('Desktop', 'Core')

      #
      # PREPARATION
      #

      FormatsToProcess      = @()
      FunctionsToExport     = @(
            'Start-Countdown'
      )
      CmdletsToExport       = @()
      AliasesToExport       = @()
      VariablesToExport     = @()
      FileList              = @(
            'Public\Start-Countdown.ps1',
            'Attila_Krick_Software_Developer.cer'
            'PowerShellTutor.psd1',
            'PowerShellTutor.psm1',
            'PowerShellTutor.Tests.ps1'
      )

      #
      # POWERSHELL GALLERY DATA
      #

      PrivateData           = @{
            PSData = @{
                  LicenseUri   = 'https://attilakrick.com/datenschutzerklaerung'
                  ProjectUri   = 'https://attilakrick.com/powershell/'
                  IconUri      = 'https://attilakrick.com/media/AKPT-Logo.png'
                  Tags         = @('Attila', 'Krick', 'Trainer', 'Dozent', 'Training', 'Schulung', 'WorkShop')
                  ReleaseNotes = @'
Version 1.1:
- The comfort was increased in start countdown.
'@
            }
      }
}
