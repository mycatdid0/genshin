#Persistent ;변수를 활성화하여 스크립트가 계속 실행되도록 설정
#InstallKeybdHook  ; 키보드 훅을 설치하여 키 입력 감지
#UseHook            ; 키보드 훅을 사용하여 키 입력 감지

fToggle := false
fTimer := 300  ; 0.3초 간격

SetTimer, StopRepeat, Off  ; 초기화 시 모든 반복 중지

; F키 핸들러
F::
fToggle := true
SetTimer, RepeatF, Off
Send, f

SetTimer, RepeatF, %fTimer%
RecheckTinerEvent()
return

RecheckTinerEvent() {
	WinGet, hWnd, ID, A
	WinGet, ProcessName, ProcessName, ahk_id %hWnd%
	if (ProcessName != "GenshinImpact.exe")
	{
		SetTimer, RepeatF, Off
	}
	return
}

RepeatF:
Send, f
RecheckTinerEvent()
return

; 특정 키가 눌리면 반복 해제
#If (fToggle)
~*a::
~*s::
~*d::
~*w::
~*f::
~*e::
~*q::
return

~*MButton::
~*Enter::
~*Tab::
~*Shift::
~*Ctrl::
~*Alt::
~*m::
~*l::
~*z::
~*1::
~*2::
~*3::
~*4::
StopRepeat:
fToggle := false
SetTimer, RepeatF, Off
return
