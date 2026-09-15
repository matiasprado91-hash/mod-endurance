class OlympiadBuffWnd extends UIScript;

const NSTATUSICON_FRAMESIZE = 12;
const NSTATUSICON_MAXCOL = 12;

var int		m_PlayerNum;
var int		m_PlayerID;
var string		m_WindowName;

function SetPlayerNum(int PlayerNum)
{
	m_PlayerNum = PlayerNum;
	m_WindowName = "OlympiadBuff" $ PlayerNum $ "Wnd";
}

function OnLoad()
{
	RegisterEvent( EV_OlympiadBuffShow );
	RegisterEvent( EV_OlympiadBuffInfo );
	RegisterEvent( EV_OlympiadMatchEnd );
}

function OnEnterState( name a_PreStateName )
{
	Clear();
	m_PlayerID = 0;
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_OlympiadBuffShow)
	{
		HandleBuffShow(param);
	}
	else if (Event_ID == EV_OlympiadBuffInfo)
	{
		HandleBuffInfo(param);
	}
	else if (Event_ID == EV_OlympiadMatchEnd)
	{
		Clear();
		m_PlayerID = 0;
	}
}

//??????
function Clear()
{
	class'UIAPI_STATUSICONCTRL'.static.Clear(m_WindowName $ ".StatusIcon");
	class'UIAPI_WINDOW'.static.HideWindow(m_WindowName);
}

//BuffWnd ??????
function HandleBuffShow(string param)
{
	local int PlayerNum;
	
	//???? ????????(1 or 2)?? ?????? ????
	ParseInt(param, "PlayerNum", PlayerNum);
	if (m_PlayerNum != PlayerNum || PlayerNum<1)
	{
		return;
	}
	ParseInt(param, "PlayerID", m_PlayerID);
}

//BuffInfo????
function HandleBuffInfo(string param)
{
	local int PlayerID;
	
	local int i;
	local int Max;
	local int CurRow;
	local StatusIconInfo info;
	
	local Rect rectWnd;
	
	//???? ????????ID?? ?????? ????
	ParseInt(param, "PlayerID", PlayerID);
	if (m_PlayerID != PlayerID || PlayerID<1)
	{
		return;
	}
	
	//??????
	Clear();
	CurRow = -1;
	
	ParseInt(param, "Max", Max);
	for (i=0; i<Max; i++)
	{
		//?????? NSTATUSICON_MAXCOL???? ????????.
		if (i%NSTATUSICON_MAXCOL == 0)
		{
			class'UIAPI_STATUSICONCTRL'.static.AddRow(m_WindowName $ ".StatusIcon");
			CurRow++;
		}
		
		ParseInt(param, "SkillID_" $ i, info.ClassID);
		ParseInt(param, "SkillLevel_" $ i, info.Level);
		ParseInt(param, "RemainTime_" $ i, info.RemainTime);
		ParseString(param, "Name_" $ i, info.Name);
		ParseString(param, "IconName_" $ i, info.IconName);
		ParseString(param, "Description_" $ i, info.Description);
		info.Size = 24;
		info.BackTex = "L2UI.EtcWndBack.AbnormalBack";
		info.bShow = true;
		
		class'UIAPI_STATUSICONCTRL'.static.AddCol(m_WindowName $ ".StatusIcon", CurRow, info);
	}
	
	if (Max>0)
	{
		class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName);
		
		//?????? ?????? ????
		rectWnd = class'UIAPI_WINDOW'.static.GetRect(m_WindowName $ ".StatusIcon");
		class'UIAPI_WINDOW'.static.SetWindowSize(m_WindowName, rectWnd.nWidth + NSTATUSICON_FRAMESIZE, rectWnd.nHeight);
		
		//???? ?????? ?????? ????
		class'UIAPI_WINDOW'.static.SetFrameSize(m_WindowName, NSTATUSICON_FRAMESIZE, rectWnd.nHeight);	
	}
}
defaultproperties
{
}
