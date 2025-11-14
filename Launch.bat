Echo off
Rem By Timothé AOUN
Rem Le Coffre Fort n'est pas réellement sécurisé et il reste des failles que je n'ai pas réussit à régler
Rem Par exemple rien n'empêche un attaquant malveillant de réinstaller sur mon dépôt l'installer.bat, il recréra alors un dossier coffre fort, et écrasera l'autre lors de son cryptage (je pourrais envisager une inscription dans le registre via 'reg' mais il suffirait de supprimer la clé... 
Echo Hello and welcome to CoffreFORT
Echo We are getting everything ready...
set __Compat_Layer=runasinvoker
set "scriptdir=%~dp0"
set "lettre=%scriptdir:~0,2%"
%lettre% & cd %scriptdir%
if exist "%scriptdir%admincheck___importantfile_do_not_delete_during_process.tmp" (goto :adminok) else (goto :elevate)
:elevate
Echo Warning, you are using the beta version of the vault. It contains several flaws: 1) Reinstalling the vault will overwrite the old one during encryption 2) An administrator with my open-source code in hand can easily use it to unlock the vault These two flaws should not be taken lightly! Vault is an educational application, you are free to modify its code, improve it, and share it!
Echo By Timothe AOUN (https://github.com/timotheaoun/Coffre_fort)
Echo _________________________________________________________
Echo.
More %~dp0consent.log
Set /p "Accept=J'accepte d'utiliser coffre fort, j'ai lu les conditions d'utilisation (Y/N)"
If /I "%Accept%"=="Y" (cls) else (exit)
echo %userprofile%>%scriptdir%admincheck___importantfile_do_not_delete_during_process.tmp
Nircmd elevate "%scriptdir%%~nx0" & exit
:adminok
set /p REAL_USERPROFILE=<"%scriptdir%admincheck___importantfile_do_not_delete_during_process.tmp"
Del /q "%scriptdir%admincheck___importantfile_do_not_delete_during_process.tmp"
Echo We'll create a dir in (%REAL_USERPROFILE%\desktop\) named 'Coffre_Fort'
:CheckCoffrefortexists
if exist %REAL_USERPROFILE%\desktop\Coffre_Fort (goto :error01) else (goto :ok01)
:error01
Echo Error 01, %REAL_USERPROFILE%\desktop\Coffre_Fort already exists ! rename this dir and press a key
pause
goto :CheckCoffrefortexists

:ok01
Cd %REAL_USERPROFILE%\desktop\
Md Coffre_Fort
MD %REAL_USERPROFILE%\desktop\Coffre_Fort\Systemfiles
Echo The dir 'Coffre_Fort' was created with success!!!
Echo Now, you'll created a password. You will need it to unlock the safe
:CreatePassword
cls
set /p "Password=Create your password: "
cls
set /p "CPassword=Confirm the password: "
cls
if "%CPassword%"=="%Password%" goto :ok02
echo The confirmation password is incorrect !
goto :CreatePassword

:ok02
echo Okay, now, we'll transform your password to a key 
echo Loading [...]
powershell -NoProfile -Command  "$p=[Text.Encoding]::UTF8.GetBytes($env:Password); $h=[Security.Cryptography.SHA512]::Create().ComputeHash($p);([BitConverter]::ToString($h) -replace '-','').ToLower()" > "%REAL_USERPROFILE%\Desktop\Coffre_Fort\Systemfiles\hash.ky"
if %errorlevel% neq "1" (goto :Ok03) else (goto :Error02)
:Error02
echo Error 02! Motif: Error in hash conversion, in shell invocation, or in key file creation
:Input02
set /p "Errortwo=Retry ? (Y/N)"
set "ErrChar=%Errortwo:~0,1%"
if /I "%ErrChar%"=="Y" (goto :ok02)
if /I "%ErrChar%"=="N" (exit)
echo Please answer with Y for yes and N for no
goto :Input02

:ok03
echo Hashing completed, key exported in '%REAL_USERPROFILE%\Desktop\Coffre_Fort\Systemfiles\'
echo We are making some adjustments...
Cd %REAL_USERPROFILE%\Desktop\Coffre_Fort\
 copy /Y "%scriptdir%Coffre.ico" "%REAL_USERPROFILE%\Desktop\Coffre_Fort\Systemfiles\Coffre.ico" >nul
 copy /Y "%~dp0consent.log" "%REAL_USERPROFILE%\Desktop\Coffre_Fort\Systemfiles\consent.log"
(
Echo [.ShellClassInfo]
Echo IconIndex=1
Echo InfoTip=Secure area
Echo LocalizedResourceName=Secure Safe
Echo IconResource=%REAL_USERPROFILE%\Desktop\Coffre_Fort\Systemfiles\Coffre.ico
) > %REAL_USERPROFILE%\Desktop\Coffre_Fort\desktop.ini
attrib +s +h +r %REAL_USERPROFILE%\Desktop\Coffre_Fort\desktop.ini
attrib +s +h +r /s /l /d "%REAL_USERPROFILE%\Desktop\Coffre_Fort\Systemfiles"
rundll32 shell32.dll,SHChangeNotify 1009,0x8000,"%REAL_USERPROFILE%\Desktop\Coffre_Fort\"
rundll32 shell32.dll,SHChangeNotify 0x8000000,0,0,0
Attrib +s +h %REAL_USERPROFILE%\Desktop\Coffre_Fort
Attrib -s -h %REAL_USERPROFILE%\Desktop\Coffre_Fort
Attrib +s %REAL_USERPROFILE%\Desktop\Coffre_Fort
rundll32 shell32.dll,SHChangeNotify 1009,0x8000,"%REAL_USERPROFILE%\Desktop\Coffre_Fort\"
rundll32 shell32.dll,SHChangeNotify 0x8000000,0,0,0
powershell -NoProfile -Command "$s=New-Object -ComObject Shell.Application; $d=$s.Namespace([Environment]::GetFolderPath('Desktop')); $d.Self.InvokeVerb('Refresh')"
cls
echo Currently, the safe is unlocked, you can place your important documents in it !!!
echo Press any key to lock the safe
Rem Supprimer Launch.bat (echo Timeout /t 1 >autodel.bat & del /q %scriptdir%Lanch.bat >>autodel.bat & start autodel.bat & exit
Rem Créer Coffre.bat --> détecter si coffre existe: déverrouiller ! Sinon, demander si veur verrouiller (le tout avec mot de passe)
Rem Pour verrouiller, appli en boucle et capte quand existe a.txt ! Crée dans coffre un petit ink vers cmd/c"Créer a.txt"
pause