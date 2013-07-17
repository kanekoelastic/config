; �T���v���X�N���v�g�W
; http://autohotkey.blog.fc2.com/

; �L�[���X�g
; https://sites.google.com/site/autohotkeyjp/reference/KeyList

; ��肽��
; �f�B�X�v���C�Ԃ��L�[�{�[�h�ňړ�
; http://neue.cc/2009/11/17_219.html
;
; �����̃f�B�X�v���C�ɂ܂������ĉ�ʂ�\��
; http://neue.cc/2009/06/20_168.html
;
; ����
; http://hail2u.net/blog/coding/autohotkey-accelerate-wheel-scroll.html
;
; Ctrl j k �� chrome �̏ꍇ ctrl tab ctrl shift tab
; alt tab ��ׂ��B chorome �� ctrl tab ���ׂ�



;-----------------------------------------------------------
; emacs���L�[�o�C���h
; see https://github.com/usi3/emacs.ahk

; 2013/01/13 �s�v�ȃo�C���h���R�����g�A�E�g Shift �t���œ��삷��悤�C��

; C-d delete-char
; C-h delete-backward-char
; C-k kill-line

; C-a move-beginning-of-line
; C-e move-end-of-line

; C-p previous-line
; C-n next-line
; C-f forward-char
; C-b backward-char
;-----------------------------------------------------------


;#include C:\Users\IL-KANEKO\Documents\emacs.ahk


;-----------------------------------------------------------
; IME�̏�Ԃ��Z�b�g
; see http://www6.atwiki.jp/eamat/pages/17.html
;-----------------------------------------------------------
IME_SET(SetSts, WinTitle="A")    {
	ControlGet,hwnd,HWND,,,%WinTitle%
		if	(WinActive(WinTitle))	{
ptrSize := !A_PtrSize ? 4 : A_PtrSize
			 VarSetCapacity(stGTI, cbSize:=4+4+(PtrSize*6)+16, 0)
			 NumPut(cbSize, stGTI,  0, "UInt")   ;	DWORD   cbSize;
hwnd := DllCall("GetGUIThreadInfo", Uint,0, Uint,&stGTI)
		  ? NumGet(stGTI,8+PtrSize,"UInt") : hwnd
		}

	return DllCall("SendMessage"
			, UInt, DllCall("imm32\ImmGetDefaultIMEWnd", Uint,hwnd)
			, UInt, 0x0283  ;Message : WM_IME_CONTROL
			,  Int, 0x006   ;wParam  : IMC_SETOPENSTATUS
			,  Int, SetSts) ;lParam  : 0 or 1
}


; ���ϊ� �� IME OFF  /   �ϊ� �� IME ON
vk1Dsc07B :: IME_SET(0)
vk1Csc079 :: IME_SET(1)
; ���ȃL�[�ƕϊ��������ԈႦ�邱�Ƃ��悭����̂�
vkF2sc070 :: IME_SET(1)


vk1Dsc07B & h::Send,{Blind}{Left}
vk1Dsc07B & j::Send,{Blind}{Down}
vk1Dsc07B & k::Send,{Blind}{Up}
vk1Dsc07B & l::Send,{Blind}{Right}
vk1Dsc07B & Space::Send,{Blind}{Enter}

; �t�@�C�������w�肵�Ď��s�A��Esc�A�łŊJ��
;Esc::
;KeyWait, Esc
;if(A_PriorHotkey == A_ThisHotkey)&&(A_TimeSincePriorHotkey < 600){
;	Send,#{r}
;}
;Return

; �f�B�X�v���C�̈ړ� -------------
;���L�[(�}���`�f�B�X�v���C�ł̃E�B���h�E�ړ�)
vk1Dsc07B & Left::SendToTargetMonitor(2) ;�� ���f�B�X�v���C
vk1Dsc07B & Up::SendToTargetMonitor(3) ;�� �����f�B�X�v���C
vk1Dsc07B & Right::SendToTargetMonitor(1) ;�� �E�f�B�X�v���C

;�Ώۃ��j�^�ɃA�N�e�B�u�E�B���h�E���ړ�����(�������T�C�Y)
SendToTargetMonitor(monitorNo)
{
	WinGetPos, x, y, w, h, A
	GetMonitor(monitorNo, mX, mY, mW, mH)
	WinMove, A,, mX, mY, mW, mH
	DllCall("SetCursorPos", int, (mX+200), int, (mY+400))  ; The first number is the X-coordinate and the second is the Y (relative to the screen).
}

; �w��ԍ��̃��j�^�T�C�Y���擾����
GetMonitor(monitorNo, ByRef mX, ByRef mY, ByRef mW, ByRef mH)
{
    SysGet, m, MonitorWorkArea, %monitorNo%
    mX := mLeft
    mY := mTop
    mW := mRight - mLeft
    mH := mBottom - mTop
}


; 4���ڂ̃f�B�X�v���C�͖��g�p�Ȃ̂ŁA���L�[�́A2��ʂ̊g��Ƃ���
vk1Dsc07B & Down::ViewInTwoDisplay()

;�Ώۃ��j�^�ɃA�N�e�B�u�E�B���h�E���ړ�����(�������T�C�Y)
ViewInTwoDisplay()
{
	WinGetPos, x, y, w, h, A
	;GetTwoDisplayMonitor(mX, mY, mW, mH)
	WinMove, A,, -2160, 0, 2160, 1919
}

; �}�E�X�̈ړ� -------------
vk1Dsc07B & 7::MoveMouseToTargetMonitor(2) ;�� ���f�B�X�v���C
vk1Dsc07B & 9::MoveMouseToTargetMonitor(1) ;�� �E�f�B�X�v���C
vk1Dsc07B & 8::MoveMouseToTargetMonitor(3) ;�� �����f�B�X�v���C

MoveMouseToTargetMonitor(monitorNo)
{
    WinGetPos, x, y, w, h, A
    GetMonitor(monitorNo, mX, mY, mW, mH)
	DllCall("SetCursorPos", int, (mX+200), int, (mY+400))  ; The first number is the X-coordinate and the second is the Y (relative to the screen).
}


; ��������E�B�[������
WheelUp::
WheelDown::
  wheeltype := A_ThisHotkey

  if (wheeltype <> A_PriorHotkey || A_TimeSincePriorHotkey > 250) {
    wheelcount = 1
  } else if (wheelcount < 8 * 5) {
    wheelcount++
  }

  count := (wheelcount // 8 * 3) + 1
  ; ToolTip, %count%`, %wheelcount%
  MouseClick, %wheeltype%, , , %count%
return


; ************
; �悭�g��URL
; ************
#F1::Run http://www.google.co.jp/
#F2::Run http://translate.google.co.jp/

^!s::
Send ���{��̓��͂��ł��܂�{Enter}
return
