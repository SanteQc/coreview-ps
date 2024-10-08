﻿#-------------------------------------------------------------------------
Set-Location -Path $PSScriptRoot
#-------------------------------------------------------------------------
$ModuleName = 'coreview-ps'
$PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
#-------------------------------------------------------------------------
if (Get-Module -Name $ModuleName -ErrorAction 'SilentlyContinue') {
	#if the module is already in memory, remove it
	Remove-Module -Name $ModuleName -Force
}
Import-Module $PathToManifest -Force
#-------------------------------------------------------------------------

InModuleScope 'coreview-ps' {
	#-------------------------------------------------------------------------
	$WarningPreference = "SilentlyContinue"
	#-------------------------------------------------------------------------
	Describe 'Get-CvEnvironment Private Function Tests' -Tag Unit {
		BeforeAll {
			$WarningPreference = 'SilentlyContinue'
			$ErrorActionPreference = 'SilentlyContinue'
			$HttpClient = New-CvHttpClient
		}
		Context 'Error' {
			It 'should return an error message on 404' {
				$CV_ENVIRONMENT_JSON = 'http://127.0.0.1:404'
				{ Get-CvEnvironment -HttpClient $HttpClient } | Should -Throw
				$CV_ENVIRONMENT_JSON = 'https://app.coreview.com/assets/configuration/environment.json'
			}
		}
		Context 'Success' {
			It 'should return a hashtable' {
				Should -ActualValue (Get-CvEnvironment -HttpClient $HttpClient) -BeOfType System.Collections.Hashtable
			}

			It 'should have the property baseAuthUrl of type Uri' {
				$env = Get-CvEnvironment -HttpClient $HttpClient
				$env.baseAuthUrl | Should -BeOfType System.Uri
			}
		}
	}
}
