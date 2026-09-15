//================================================================================
// NPHRN_KeyWnd.
//================================================================================

class NPHRN_KeyWnd extends UICommonAPI;

var WindowHandle Deobfuscated4450;
var Shortcut script;
var CheckBoxHandle Cb_UseNumpad;
var CheckBoxHandle Cb_UseFPad;
var CheckBoxHandle Cb_UseQwerty;
var CheckBoxHandle Cb_ChatEnter;
var ComboBoxHandle ComboPanel1;
var ComboBoxHandle ComboPanel2;
var ComboBoxHandle ComboPanel3;
var TextBoxHandle Tooltip_ChatEnter;
var TextBoxHandle Tooltip_UseNumpad;
var TextBoxHandle Deobfuscated3081;
var TextBoxHandle Deobfuscated3082;

function OnLoad ()
{
	Deobfuscated120();
	Deobfuscated1210();
}

function Deobfuscated120 ()
{
	Deobfuscated4450 = GetHandle("NPHRN_KeyWnd");
	script = Shortcut(GetScript("Shortcut"));
	Cb_UseNumpad = CheckBoxHandle(GetHandle("NPHRN_KeyWnd.Cb_UseNumpad"));
	Cb_UseFPad = CheckBoxHandle(GetHandle("NPHRN_KeyWnd.Cb_UseFPad"));
	Cb_UseQwerty = CheckBoxHandle(GetHandle("NPHRN_KeyWnd.Cb_UseQwerty"));
	Cb_ChatEnter = CheckBoxHandle(GetHandle("NPHRN_KeyWnd.Cb_ChatEnter"));
	ComboPanel1 = ComboBoxHandle(GetHandle("NPHRN_KeyWnd.ComboPanel1"));
	ComboPanel2 = ComboBoxHandle(GetHandle("NPHRN_KeyWnd.ComboPanel2"));
	ComboPanel3 = ComboBoxHandle(GetHandle("NPHRN_KeyWnd.ComboPanel3"));
	Tooltip_ChatEnter = TextBoxHandle(GetHandle("NPHRN_BeltWnd.Tooltip_ChatEnter"));
	Tooltip_UseNumpad = TextBoxHandle(GetHandle("NPHRN_BeltWnd.Tooltip_UseNumpad"));
	Deobfuscated3081 = TextBoxHandle(GetHandle("NPHRN_BeltWnd.Tooltip_UseFPad"));
	Deobfuscated3082 = TextBoxHandle(GetHandle("NPHRN_BeltWnd.Tooltip_UseQwerty"));
}

function Deobfuscated1210 ()
{
	if ( GetOptionInt("Key","Panel1") <= 0 )
	{
		SetOptionInt("Key","Panel1",1);
	}
	if ( GetOptionInt("Key","Panel2") <= 0 )
	{
		SetOptionInt("Key","Panel2",1);
	}
	if ( GetOptionInt("Key","Panel3") <= 0 )
	{
		SetOptionInt("Key","Panel3",1);
	}
	Cb_ChatEnter.SetTitle("Chat with Enter");
	Cb_UseNumpad.SetTitle("Pad-Num.");
	Cb_UseQwerty.SetTitle("Qwerty");
	Cb_UseFPad.SetTitle("Pad-F");
	Tooltip_ChatEnter.SetTooltipString("Enable Enter Chat to use shortcuts.");
	Tooltip_UseNumpad.SetTooltipString("Keys: 1, 2, 3 Etc");
	Deobfuscated3081.SetTooltipString("Keys: F1, F2, F3 Etc");
	Deobfuscated3082.SetTooltipString("Keys: Q, W, E, Etc");
	Cb_ChatEnter.SetCheck(GetOptionBool("Game","EnterChatting"));
	Cb_UseNumpad.SetCheck(GetOptionBool("Key","UseNumpad"));
	Cb_UseFPad.SetCheck(GetOptionBool("Key","UseFPad"));
	Cb_UseQwerty.SetCheck(GetOptionBool("Key","UseQwerty"));
	ComboPanel1.SetSelectedNum(GetOptionInt("Key","Panel1") - 1);
	ComboPanel2.SetSelectedNum(GetOptionInt("Key","Panel2") - 1);
	ComboPanel3.SetSelectedNum(GetOptionInt("Key","Panel3") - 1);
}

function OnClickButton (string strID)
{
	switch (strID)
	{
		case "BtnApply":
			OnClickApply();
			break;
		case "BtnClose":
			Deobfuscated4450.HideWindow();
			break;
		default:
	}
}

function OnClickApply ()
{
	SetOptionInt("Key","Panel1",ComboPanel1.GetSelectedNum() + 1);
	SetOptionInt("Key","Panel2",ComboPanel2.GetSelectedNum() + 1);
	SetOptionInt("Key","Panel3",ComboPanel3.GetSelectedNum() + 1);
	script.Deobfuscated527();
}

function OnClickCheckBox (string strID)
{
	switch (strID)
	{
		case "Cb_ChatEnter":
			if ( Cb_ChatEnter.IsChecked() )
			{
				SetOptionBool("Game","EnterChatting",True);
			} 
else 
{
				SetOptionBool("Game","EnterChatting",False);
			}
			break;
		case "Cb_UseNumpad":
			if ( Cb_UseNumpad.IsChecked() )
			{
				SetOptionBool("Key","UseNumpad",True);
			} 
else 
{
				SetOptionBool("Key","UseNumpad",False);
			}
			break;
		case "Cb_UseFPad":
			if ( Cb_UseFPad.IsChecked() )
			{
				SetOptionBool("Key","UseFPad",True);
			} 
else 
{
				SetOptionBool("Key","UseFPad",False);
			}
			break;
		case "Cb_UseQwerty":
			if ( Cb_UseQwerty.IsChecked() )
			{
				SetOptionBool("Key","UseQwerty",True);
			} 
else 
{
				SetOptionBool("Key","UseQwerty",False);
			}
			break;
		default:
	}
}
defaultproperties
{
}
