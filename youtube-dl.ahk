ytdl = %A_ScriptDir%\Files\youtube-dl.exe
DLtype = Audio
DLdir = %USERPROFILE%\Videos\`%(title)s
Menu, Tray, Icon, %A_ScriptDir%\Files\yt-dl.ico
return

CreateGUI:
{
	;set font size
	Gui, Font, s9

	;format
	Gui, Add, Tab3, ggDLtype vDLtype w300, Video|Audio
		Gui, Tab, 1	;video
		Gui, Add, Text,, Video Format
		Gui, Add, DropDownList, choose1 w250 vFormatVideo, mp4|flv|ogg|webm|mkv|avi|3gp
		Gui, Add, CheckBox, vEmbedSubs, Embed Subtitles

		Gui, Tab, 2	;audio
		Gui, Add, Text,, Audio Format
		Gui, Add, DropDownList, choose1 w250 vFormatAudio, mp3|aac|flac|m4a|opus|vorbis|wav
		Gui, Add, CheckBox, vEmbedArt, Embed Album Art
	Gui, Tab

	;link
	Gui, Add, Text,, Video/Playlist Link
	Gui, Add, Edit, -Multi r1 w300 vurl, %vLink%

	;file name
	Gui, Add, Text,, File path
	Gui, Add, Edit, -Multi r1 w280 vfilePath, %DLdir%
	Gui, Add, Button, gBrowse x+1 y+-22 w19, ...
	Gui, Font, s7
	Gui, Add, Link,xm, `%(title)s    `%(uploader)s    `%(playlist_index)s   <a href="https://github.com/ytdl-org/youtube-dl/blob/master/README.md#output-template">more</a>
	Gui, Font, s9

	;Gui end
	Gui, Add, Button, gDownloadVideo default w300, Download Video
	return
}
!x::
{
	;Set the link edit box to the newest clipboard text
	vLink = %Clipboard%
	
	;Show GUI to select format
	Gui, Destroy
	gosub, CreateGUI
	Gui, Show
	return
	
	;Submit GUI
	DownloadVideo:
	Gui, Submit

	;Set up config file
	configPath = %Appdata%\youtube-dl\config.txt
	FileCreateDir, %Appdata%\youtube-dl		;create config dir if it doesn't already exist
	FileDelete, %configPath%
	FileAppend, #This config file was created with AutoHotkey on %A_MM%/%A_DD%/%A_YYYY% `n`n, %configPath%
	
	;Setup format of downloaded file in config file
	If DLtype = Video
	{
	;Change config file
	FileAppend, -f %FormatVideo%`n, %configPath%
	FileFormat = %FormatVideo% 
	if EmbedSubs = 1
	{
		FileAppend, --embed-subs`n, %configPath%
	}
	}
	Else
	{
	;Change config file
	FileAppend, -x --audio_format %FormatAudio%`n, %configPath%
	FileFormat = %FormatAudio%
	if EmbedArt = 1
	{
		FileAppend, --embed-thumbnail`n, %configPath%
	}
	}

	;Name video
	FileAppend, -o '%filePath%.%FileFormat%'`n, %configPath%
	
	;Download video
	Run, %ytdl% %url%
return
}

gDLtype:
Return

Browse:
	FileSelectFile, DLdir,, %USERPROFILE%\Videos, Select download location
	Gui, Destroy
	gosub CreateGUI
	Gui, Show
Return