class PCCafeEventWnd extends UICommonAPI;

var int zzm_TotalPoint;
var int zzm_AddPoint;
var int zzm_PeriodType;
var int zzm_RemainTime;
var int zzm_PointType;
var ExpBarWnd zzbarscript;

//Handle
var WindowHandle zzHelpButton;

function OnLoad()
{
	RegisterEvent( EV_PCCafePointInfo );
	RegisterEvent(140);
	zzbarscript = ExpBarWnd(GetScript("ExpBarWnd"));
	zzHelpButton = GetHandle("PCCafeEventWnd.HelpButton");
	//HideWindow( "PCCafeEventWnd.PointAddTextBox" );
}

function OnClickButton( String a_ButtonID )
{
	switch( a_ButtonID )
	{
		case "HelpButton":
			OnClickHelpButton();
			break;
	}
}

function OnEvent( int a_EventID, String a_Param )
{
	switch( a_EventID )
	{
		case EV_PCCafePointInfo:
			HandlePCCafePointInfo( a_Param );
			break;
		case 140:
			HandleStringEvent(a_Param);
            // End:0x33
			break;	
		
	}
}

function HandleStringEvent(string a_Param)
{
	local int cEvent;

	ParseInt(a_Param, "CustomEvent", cEvent);
    // End:0x5C
	if( cEvent > 0 )
	{
		a_Param = Mid(a_Param, InStr(a_Param, "CustomEvent"));
		ExecuteEvent(cEvent, a_Param);        
	}
	else
	{
		ExecuteEvent(99996, a_Param);
	}
	return;
}



function OnClickHelpButton()
{
	// TODO: When TTMayrin implements HTML Control, load proper HTML... - NeverDie
}

function HandlePCCafePointInfo( String zza_Param )
{

	local ToolTip zzscript;

	zzscript = ToolTip(GetScript("ToolTip"));
	ParseInt( zza_Param, "TotalPoint", zzm_TotalPoint );
	ParseInt( zza_Param, "AddPoint", zzm_AddPoint );
	ParseInt( zza_Param, "PeriodType", zzm_PeriodType );
	ParseInt( zza_Param, "RemainTime", zzm_RemainTime );
	ParseInt( zza_Param, "PointType", zzm_PointType );
	
//	OMG("m_TotalPoint : " $  ZZm_TotalPoint $ " m_AddPoint : " $ ZZm_AddPoint $ " m_PeriodType : " $ ZZm_PeriodType $ " m_RemainTime : " $ zzm_RemainTime $ " m_PointType : " $ zzm_PointType );


	switch(zzm_RemainTime)
	{

		case 0:
		case 1:
		//para l2jmega,acis335,orion
			xxsynnak(zzm_AddPoint,zzm_RemainTime);
			 
			 // para rusacis
		//	 xxsynnak(zzm_TotalPoint,zzm_RemainTime);
            // End:0x130
			break;
		case 99981:
			ExecuteEvent(99981);		
			break;
			
			
		case 154786:
			ExecuteEvent(154786);		
			break;	
		case 154787:
			ExecuteEvent(154787);		
			break;
			
		case 154788:
			xxlcoin(zzm_AddPoint);		
			break;
        case 85453:
		    HandleHideShowWnd("Teleport2k2Wnd");
		break;
		case 154789:
			xxtimepve(zzm_AddPoint);		
			break;	

		case 154790:
			xxtimepvp(zzm_AddPoint);		
			break;
			
		case 154791:
			xxtimesolo(zzm_AddPoint);		
			break;

		case 154792:
			xxtimelairpvp(zzm_AddPoint);		
			break;
			
		case 757515:
			xxrandomcraftitems(zzm_AddPoint);

			break;			
		case 1013:
			xxtimeinstance(zzm_AddPoint,zzm_RemainTime);		
			break;	
		case 1014:
			xxtimeinstance(zzm_AddPoint,zzm_RemainTime);		
			break;	
		case 1015:
			xxtimeinstance(zzm_AddPoint,zzm_RemainTime);		
			break;	
		case 1016:		
			xxtimeinstance(zzm_AddPoint,zzm_RemainTime);		
			break;	

		case 155789:
			xxbypasexit(zzm_AddPoint);		
			break;	

		case 155790:
			ExecuteEvent(155790);		
			break;


			
			
		case 98715:
			xxHideOrionChiets();		
			break;	
			
		case 99562:
			zzscript.isadmin = True;		
			break;	
			
		case 99563:
			zzscript.isadmin = False;			
			break;	
			
			
		default:
			break;
	}






	Refresh();
	
	
	
	
}

function HandleHideShowWnd (string WndName)
{
	local WindowHandle Handle;

	Handle = GetHandle(WndName);
	if ( Handle.IsShowWindow() )
	{
		Handle.HideWindow();
	} 
	else 
	{
		Handle.ShowWindow();
	}
}

function xxHideOrionChiets()
{
	HideWindow("AutoHunting");
//	HideWindow("AutoPotionsWnd");
	ExecuteEvent(99872);
	ExecuteEvent(98716);
	return;
}

function xxsynnak(int zzid , int zzenable )
{
	local string zzparam;

	ParamAdd(zzparam, "ShotID", string(zzid));
	ParamAdd(zzparam, "bEnable", string(zzenable));
	ExecuteEvent(44467, zzparam);

	return;
}


function xxlcoin(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "LcoinCount", string(zzid));
	ExecuteEvent(154788, zzparam);

	return;
}


function xxrandomcraftitems(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "ItemsId", string(zzid));
	ExecuteEvent(757515, zzparam);

	return;
}



function xxtimepve(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "TimePvE", string(zzid));
	ExecuteEvent(154789, zzparam);


}

function xxtimepvp(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "TimePvP", string(zzid));
	ExecuteEvent(154790, zzparam);

	return;
}

function xxtimesolo(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "TimeSolo", string(zzid));
	ExecuteEvent(154791, zzparam);

	return;
}

function xxtimelairpvp(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "TimeLairPvP", string(zzid));
	ExecuteEvent(154792, zzparam);

	return;
}


function xxtimeinstance(int zzid, int zzinstanceid)
{
	local string zzparam;

	ParamAdd(zzparam, "TimeInstance", string(zzid));
	ParamAdd(zzparam, "InstanceId", string(zzinstanceid));
	ExecuteEvent(156750, zzparam);

}




function xxbypasexit(int zzid)
{
	local string zzparam;

	ParamAdd(zzparam, "Bypass", string(zzid));
	ExecuteEvent(155789, zzparam);

	return;
}




function bool IsPCCafeEventOpened()
{
	if( 0 < zzm_PeriodType )
		return True;

	return False;
}

function OnEnterState( name a_PreStateName )
{
	Refresh();
}

function Refresh()
{
	local Color zzTextColor;
	local String zzAddPointText;



	if( IsPCCafeEventOpened() )
	{
	//	ShowWindow( "PCCafeEventWnd" );
		
		zzHelpButton.SetTooltipCustomType(xxSetTooltip(GetHelpButtonTooltipText()));
		class'UIAPI_TEXTBOX'.static.SetText( "PCCafeEventWnd.PointTextBox", MakeCostString( String( zzm_TotalPoint ) ) );
		class'UIAPI_WINDOW'.static.SetAlpha( "PCCafeEventWnd.PointAddTextBox", 0 );
		class'UIAPI_TEXTBOX'.static.SetText( "ExpBarWnd.textCountPCBANG", MakeCostString( String( zzm_TotalPoint ) ) );
		//zzbarscript.SetPCBangExpBar(string(m_TotalPoint));
		if( 0 != zzm_AddPoint )
		{
			if( 0 < zzm_AddPoint )
				zzAddPointText = "+"$MakeCostString( String( zzm_AddPoint ) );
			else
				zzAddPointText = MakeCostString( String( zzm_AddPoint ) );

			class'UIAPI_TEXTBOX'.static.SetText( "PCCafeEventWnd.PointAddTextBox", zzAddPointText );
			switch( zzm_PointType )
			{
				case 0:	// Normal
					zzTextColor.R = 255;
					zzTextColor.G = 255;
					zzTextColor.B = 0;
					break;
				case 1:	// Bonus
				//TextColor.R = 255;
				//TextColor.G = 0;
				//TextColor.B = 0;
					zzTextColor.R = 0;
					zzTextColor.G = 255;
					zzTextColor.B = 255;
					break;
				case 2:	// Decrease
				//TextColor.R = 0;
				//TextColor.G = 255;
				//TextColor.B = 255;
					zzTextColor.R = 255;
					zzTextColor.G = 0;
					zzTextColor.B = 0;
					break;
			}
			class'UIAPI_TEXTBOX'.static.SetTextColor( "PCCafeEventWnd.PointAddTextBox", zzTextColor );
			class'UIAPI_WINDOW'.static.SetAnchor( "PCCafeEventWnd.PointAddTextBox", "PCCafeEventWnd", "TopRight", "TopRight", -5, 41 );
			class'UIAPI_WINDOW'.static.ClearAnchor( "PCCafeEventWnd.PointAddTextBox" );
			class'UIAPI_WINDOW'.static.Move( "PCCafeEventWnd.PointAddTextBox", 0, -18, 1.f );
			class'UIAPI_WINDOW'.static.SetAlpha( "PCCafeEventWnd.PointAddTextBox", 255 );
			class'UIAPI_WINDOW'.static.SetAlpha( "PCCafeEventWnd.PointAddTextBox", 0, 0.8f );
			zzm_AddPoint = 0;
		}
	}
	else
		HideWindow( "PCCafeEventWnd" );
}

function String GetHelpButtonTooltipText()
{
	local String zzTooltipSystemMsg;

	if( 1 == zzm_PeriodType )
		zzTooltipSystemMsg = GetSystemMessage( 1705 );
	else if( 2 == zzm_PeriodType )
		zzTooltipSystemMsg = GetSystemMessage( 1706 );
	else
		return "";

	return MakeFullSystemMsg( zzTooltipSystemMsg, string( zzm_RemainTime ), "" );
}

function CustomTooltip xxSetTooltip(string zzText)
{
	local CustomTooltip zzTooltip;
	local DrawItemInfo zzinfo;
	
	zzTooltip.MinimumWidth = 144;
	
	zzTooltip.DrawList.Length = 1;
	zzinfo.eType = DIT_TEXT;
	zzinfo.t_bDrawOneLine = True;
	zzinfo.t_color.R = 178;
	zzinfo.t_color.G = 190;
	zzinfo.t_color.B = 207;
	zzinfo.t_color.A = 255;
	zzinfo.t_strText = zzText;
	zzTooltip.DrawList[0] = zzinfo;

	return zzTooltip;
}
defaultproperties
{
}
