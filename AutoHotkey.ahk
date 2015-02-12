;;; CapsLock
; CapsLock + r = Remote Desktop Connection
CapsLock & r::
  Run, mstsc
Return

; CapsLock + T = putty ("Terminal")
CapsLock & t::
  Run, C:\Data\Software\SSH\Putty\Putty.exe
Return

; CapsLock + v = VMware vSphere client
CapsLock & v::
  Run, "C:\Program Files (x86)\VMware\Infrastructure\Virtual Infrastructure Client\Launcher\VpxClient.exe"
Return

; CapsLock + g = search for selected text in google
CapsLock & g::
  Send, ^c
  Sleep 50
  Run, http://www.google.com/search?q=%clipboard%
Return

; CapsLock without other key = Esc key (useful for vim)
*CapsLock::
  Send {Blind}{Esc}
Return


;; Clipboard
; hold down left mouse button an press right mouse buttion = search for selected text in google
~LButton & RButton::
  Send, ^c
  Sleep 50
  Run, http://www.google.com/search?q=%clipboard%
Return

; WindowsKey + v = paste plain text
#v::
  ClipSaved := ClipboardAll
  Clipboard = %Clipboard%
  SendInput ^v
  Sleep 250
  Clipboard := ClipSaved
return

; WindowsKey + c = opens Notepad and paste selected text
#c::
  Send, {CTRLDOWN}c{CTRLUP}
  Run Notepad
  sleep, 300
  Send,{CTRLDOWN}v{CTRLUP}{ENTER}
return

; copy text where paste is not allowed
^!v::
  clipboard=%clipboard%
  sendraw %clipboard%
return

;; Mouse Buttons
; middle mouse button in Windows Explorer = goto parent folder
#IfWinActive, ahk_class CabinetWClass
  ~MButton::Send !{Up}
#IfWinActive

; Alt + left mouse button = Double click
!Lbutton:: sendplay {click 2}

;; Window Management
; Strg + Space = keep window in front of other windows
^SPACE:: Winset, Alwaysontop, , A

;; Apple Keyboard
F13::
  send, {PrintScreen}
Return
