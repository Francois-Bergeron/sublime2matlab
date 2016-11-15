;Script to run the m-file edited in sublime in MATLAB.

SetTitleMatchMode, 2								; search mode set to 2 (find the phrase anywhere in string)
ifWinNotActive, Sublime
{
	MsgBox Sublime text editor is not the current active window.
}
ifWinActive, Sublime 								; if active window is Sublime Text
{
	WinGetTitle, windowTitle, Sublime 				; get whole window name
	StringGetPos, pos, windowTitle, .m 				; determine where the path is ending and if the file is m-file
	if pos=-1 										; -1 will is returned by StringGetPos if .m is not part of the file name
	{
		MsgBox The current Sublime file is not a m-file.		
	}
	
	else
	{	
		Send ^s 		 							; Save m-file
		StringLeft, mFileName, windowTitle, pos+2 	; create string containing whole path of the file (+2 to include .m)

		;MsgBox, %windowTitle%
		;MsgBox, Position is %pos%
		;MsgBox, file name is %mFileName%

		Run, %mFileName% 							; open the file in MATLAB (way how to get always script window active - m-file MUST be assign to MATLAB)
		
		loop 										; Loop to until the MATLAB editor is opened (will start MATLAB if not open)
		{
			ifWinActive, Editor
			{
				Sleep, 100
				Send {F5}							; "press" F5 to run the m-file
				break								; terminate loop (Loop length depend on MATLAB opening speed)
			}
			Sleep, 100								; wait 100ms to make sure F5 is not "pressed" too early
			if a_index = 50							; Special case if you close MATLAB and run this script right after. Run command is then sent to a closing process. Calling run again to start a new process.
			{
				Process, Exist, MATLAB.exe 			; check to see if MATLAB.exe is running
				if (ErrorLevel = 0) 				; If it is not running
				{
					Run, %mFileName%				; Start MATLAB and run script
				}
			}
			if a_index > 100						; If not started after 10 sec, display error msg.
			{
				Process, Exist, MATLAB.exe 			; check to see if MATLAB.exe is running
				if (ErrorLevel = 0) 				; If it is not running
				{
					MsgBox MATLAB did not open or is taking too long. Check if MATLAB is opening.`nIf:`nYES: Please wait for the program to open then rebuild.`nNO: Simply rebuild, MATLAB will launch.
					break
				}
			}
		}
	}
}
