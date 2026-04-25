;@Ahk2Exe-SetMainIcon temp_260416_222240_2.ico
;language: EUC-KR
#Persistent ;변수를 활성화하여 스크립트가 계속 실행되도록 설정
#InstallKeybdHook  ; 키보드 훅을 설치하여 키 입력 감지
#UseHook            ; 키보드 훅을 사용하여 키 입력 감지


fToggle := false ; True이면 f키가 반복된다.
fTimer := 300  ; 0.3초 간격

qeToggle := false  ; True이면 qe키가 반복된다.
qeTimer := 300  ; 0.3초 간격
qeCallCnt := 0 ; e를 누를지 q를 누를지 구분. 교대로 한번씩 눌린다.


ttimer := 1000 ; 1초 간격으로 원신 실행중인지 확인
tSecLimit := 60 ; 60초 동안 원신이 아닐 경우에 종료한다.
tSecCnt := 0 ; 종료까지 카운트

SetTimer, RepeatT, 1000 ; 원신 실행 체크는 1초마다

;----------------------------------------
; 원신 실행중인지 체크 카운트
RepeatT:
	WinGet, hWnd, ID, A
	WinGet, ProcessName, ProcessName, ahk_id %hWnd%
	if (ProcessName != "GenshinImpact.exe")
	{
		; 원신이 동작중이 아니면 카운트를 세서, 종료한다.
		tSecCnt := tSecCnt +1
		if(tSecCnt >= tSecLimit ) 
		{
			RemoveAllTimer()
			tSecCnt := 0
			exit
		}
	}
    else
	{
		; 원신시 동작중이면 타이머 초기화
		tSecCnt := 0
	}
return

;----------------------------------------
; E가 눌렸을재 Q가 이미 눌려있으면 E와 Q반복
E::
Send, e

if (GetKeyState("q", "P"))
{
	SetTimer, RepeatQE, Off

	qeToggle := true
	SetTimer, RepeatQE, %qeTimer%
}
return

;----------------------------------------
; F키가 눌리면 f반복
F::
SetTimer, RepeatF, Off
Send, f

fToggle := true
SetTimer, RepeatF, %fTimer%
RecheckTimerEvent()
return

;----------------------------------------
; 원신 실행중이 아니면 모든 반복 취소
RecheckTimerEvent() {
	WinGet, hWnd, ID, A
	WinGet, ProcessName, ProcessName, ahk_id %hWnd%
	if (ProcessName != "GenshinImpact.exe")
	{
		RemoveAllTimer()
	}
	return
}

;----------------------------------------
; 모든 반복 취소
RemoveAllTimer()
{
	fToggle := false
	SetTimer, RepeatF, Off
	
	qeToggle := false
	SetTimer, RepeatQE, Off
}

;----------------------------------------
; F 반복 누름
RepeatF:
RecheckTimerEvent()

if( fToggle) {
	Send, f
}
return


;----------------------------------------
; Q E 교대로 반복 누름
RepeatQE:
RecheckTimerEvent()

if( qeToggle) {
	qeCallCnt++
	if( mod(qeCallCnt, 2 ) == 0 ) {
		Send, e
	} else {
		Send, q
	}
}
return


; 캐릭터 전환시엔 eq 가 동작해야 한다.
;#If (fToggle)
;~*1::
;~*2::
;~*3::
;~*4::
;RemoveAllTimer()
;return

;----------------------------------------
; 특정 키가 눌리면 반복 해제
#If (fToggle || qeToggle)
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
~*1::
~*2::
~*3::
~*4::
RemoveAllTimer()
return
