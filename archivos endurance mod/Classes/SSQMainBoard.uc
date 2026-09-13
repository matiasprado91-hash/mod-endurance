class SSQMainBoard extends UIScript;

//////////////////////////////////////////////////////////////////////////////
// SSQ CONST
//////////////////////////////////////////////////////////////////////////////
const NC_PARTYMEMBER_MAX = 9;

//Server Request Type
const SSQR_STATUS = 1;
const SSQR_MAINEVENT = 2;
const SSQR_SEALSTATUS = 3;
const SSQR_PREINFO = 4;

//Team Name
const SSQT_NONE = 0;
const SSQT_DUSK = 1;	//??????
const SSQT_DAWN = 2;	//??????

//Main Event ID
const SSQE_TIMEATTACK = 0;	//??????????????(??????????)

//Seal Name List
const SSQS_NONE = 0;	
const SSQS_GREED = 1;	//?????? ????
const SSQS_REVEAL = 2;	//?????? ????
const SSQS_STRIFE = 3;	//?????? ????

//////////////////////////////////////////////////////////////////////////////
// SSQ Structure
//////////////////////////////////////////////////////////////////////////////
//SSQ Status
struct SSQStatusInfo
{
	var int m_nSSQStatus;
	var int m_nSSQTeam;
	var int m_nSelectedSeal;
	var int m_nContribution;
    
	var int m_nTeam1HuntingMark;
	var int m_nTeam2HuntingMark;
	var int m_nTeam1MainEventMark;
	var int m_nTeam2MainEventMark;

	var int m_nTeam1Per;
	var int m_nTeam2Per;

	var int m_nTeam1TotalMark;
	var int m_nTeam2TotalMark;

	var int m_nPeriod;
	var int m_nMsgNum1;
	var int m_nMsgNum2;
	var int m_nSealStoneAdena;
};
var SSQStatusInfo g_sinfo;

//SSQ Status
struct SSQPreStatusInfo
{
	var int		m_nWinner;
	var int		m_nRoomNum;
	var array<int>	m_nSealNumArray;
	var array<int>	m_nWinnerArray;
	var array<int>	m_nMsgArray;
};
var SSQPreStatusInfo g_sinfopre;

//SSQ Main Event
struct SSQMainEventInfo
{
	var int m_nSSQStatus;
	var int m_nEventType;
	var int m_nEventNo;
	var int m_nWinPoint;
	var int m_nTeam1Score;
	var int m_nTeam2Score;
	var string m_Team1MemberName[NC_PARTYMEMBER_MAX];
	var string m_Team2MemberName[NC_PARTYMEMBER_MAX];
};

//////////////////////////////////////////////////////////////////////////////
// SSQ ???? Flag
//////////////////////////////////////////////////////////////////////////////

//Status Preview
var bool		m_bShowPreInfo;		//????????

//???? ?????? ?????? ???????? ???? Flag
var bool		m_bRequest_SealStatus;	//????????
var bool		m_bRequest_MainEvent;	//??????????

function OnLoad()
{
	RegisterEvent( EV_SSQStatus );
	RegisterEvent( EV_SSQPreInfo);
	RegisterEvent( EV_SSQMainEvent);
	RegisterEvent( EV_SSQSealStatus );
	
	m_bRequest_SealStatus = false;
	m_bRequest_MainEvent = false;
	
	//?????????? ????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtSS", GetSystemString(833) $ " - ");
	
	//?????????? ??????
	m_bShowPreInfo = false;
	SetSSQStatus();
}

function OnShow()
{
	//0?? Tab?? ??????
	class'UIAPI_TABCTRL'.static.SetTopOrder("SSQMainBoard.TabCtrl", 0, true);
	
	//????
	PlayConsoleSound(IFST_WINDOW_OPEN);
	
	//???? ???????? Child?? ???? Show????????, ???? ????!
	SetSSQStatus();
}

function OnHide()
{
	m_bRequest_SealStatus = false;
	m_bRequest_MainEvent = false;
	
	m_bShowPreInfo = false;	// ???????????? ???? ?????? ???? ?????? ???????? ????????.
	
	//?? Tab?? ??????
	class'UIAPI_TREECTRL'.static.Clear("SSQMainBoard.me_MainTree");
	class'UIAPI_TREECTRL'.static.Clear("SSQMainBoard.ss_MainTree");
}

function OnEvent(int Event_ID, string param)
{
	local int i;
	local int j;
	local int k;
	local int l;
	
	local string strTmp;
	local int m_nSSQStatus;
	
	//SSQ Seal Status
	local int m_nNeedPoint1;
	local int m_nNeedPoint2;
	local int sealnum;
	local int m_nSealID;
	local int m_nOwnerTeamID;
	local int m_nTeam1Mark;
	local int m_nTeam2Mark;
	
	//SSQ Main Event
	local SSQMainEventInfo info;
	local int eventnum;
	local int nEventType;
	local int roomnum;
	local int team1num;
	local int team2num;
	
	//????????
	if (Event_ID == EV_SSQStatus)
	{
		ParseInt( param, "SuccessRate", g_sinfo.m_nSSQStatus );
		ParseInt( param, "Period", g_sinfo.m_nPeriod );	
		ParseInt( param, "MsgNum1", g_sinfo.m_nMsgNum1 );	
		ParseInt( param, "MsgNum2", g_sinfo.m_nMsgNum2 );	
		ParseInt( param, "SSQTeam", g_sinfo.m_nSSQTeam );
		ParseInt( param, "SelectedSeal", g_sinfo.m_nSelectedSeal);
		ParseInt( param, "Contribution", g_sinfo.m_nContribution);
		ParseInt( param, "SealStoneAdena", g_sinfo.m_nSealStoneAdena);	
		ParseInt( param, "Team1HuntingMark", g_sinfo.m_nTeam1HuntingMark);	//????
		ParseInt( param, "Team1MainEventMark", g_sinfo.m_nTeam1MainEventMark );
		ParseInt( param, "Team2HuntingMark", g_sinfo.m_nTeam2HuntingMark);	//????
		ParseInt( param, "Team2MainEventMark", g_sinfo.m_nTeam2MainEventMark);
		ParseInt( param, "Team1Per", g_sinfo.m_nTeam1Per);			//???? ??????
		ParseInt( param, "Team2Per", g_sinfo.m_nTeam2Per);			//???? ??????
		ParseInt( param, "Team1TotalMark", g_sinfo.m_nTeam1TotalMark);	//???? ??????
		ParseInt( param, "Team2TotalMark", g_sinfo.m_nTeam2TotalMark);	//???? ??????
		
		SetSSQStatusInfo();
		
		//???????? ????????, ?????????? ??????(?)?? ??????????????.
		SetSSQPreInfo();
		
		//Show Window
		class'UIAPI_WINDOW'.static.ShowWindow("SSQMainBoard");
		class'UIAPI_WINDOW'.static.SetFocus("SSQMainBoard");
	}
	//????????
	else if (Event_ID == EV_SSQPreInfo)
	{
		//???? ??????
		ClearSSQPreInfo();
		
		ParseInt(param, "Winner", g_sinfopre.m_nWinner);
		ParseInt(param, "RoomNum", g_sinfopre.m_nRoomNum);
		for (i=0; i<g_sinfopre.m_nRoomNum; i++)
		{
			g_sinfopre.m_nSealNumArray.Insert(g_sinfopre.m_nSealNumArray.Length, 1);
			ParseInt( param, "SealNum_" $ i, g_sinfopre.m_nSealNumArray[g_sinfopre.m_nSealNumArray.Length-1] );
			g_sinfopre.m_nWinnerArray.Insert(g_sinfopre.m_nWinnerArray.Length, 1);
			ParseInt( param, "Winner_" $ i, g_sinfopre.m_nWinnerArray[g_sinfopre.m_nWinnerArray.Length-1] );
			g_sinfopre.m_nMsgArray.Insert(g_sinfopre.m_nMsgArray.Length, 1);
			ParseInt( param, "Msg_" $ i, g_sinfopre.m_nMsgArray[g_sinfopre.m_nMsgArray.Length-1] );
		}
		
		SetSSQPreInfo();
	}
	//?????? ????
	else if (Event_ID == EV_SSQMainEvent)
	{
		ParseInt( param, "SSQStatus", m_nSSQStatus);
		info.m_nSSQStatus = m_nSSQStatus;
		ParseInt(param, "EventNum", eventnum);
		for (i=0; i<eventnum; i++)
		{
			ParseInt( param, "EventType_" $ i, nEventType);
			info.m_nEventType = nEventType;
			ParseInt( param, "RoomNum_" $ i, roomnum );
			for (j=0; j<roomnum; j++)
			{
				ParseInt( param, "EventNo_" $ i $ "_" $ j, info.m_nEventNo );
				ParseInt( param, "WinPoint_" $ i $ "_" $ j, info.m_nWinPoint );
				ParseInt( param, "Team2Score_" $ i $ "_" $ j, info.m_nTeam2Score );
				ParseInt( param, "Team2Num_" $ i $ "_" $ j, team2num);
				for (k=0; k<team2num; k++)
				{
					ParseString(param, "Team2MemberName_" $ i $ "_" $ j $ "_" $ k, strTmp);
					if (Len(strTmp)>0) info.m_Team2MemberName[k] = strTmp;
				}
				
				ParseInt( param, "Team1Score_" $ i $ "_" $ j, info.m_nTeam1Score);
				ParseInt( param, "Team1Num_" $ i $ "_" $ j, team1num );
		 		for (l=0; l<team1num; l++)
				{
					ParseString(param, "Team1MemberName_" $ i $ "_" $ j $ "_" $ l, strTmp);
					if (Len(strTmp)>0) info.m_Team1MemberName[l] = strTmp;
				}
				
				AddSSQMainEvent(info);
				
				//Clear
				ClearSSQMainEventInfo(info);
				info.m_nSSQStatus = m_nSSQStatus;
				info.m_nEventType = nEventType;
			}
		}
	}
	//????????
	else if (Event_ID == EV_SSQSealStatus)
	{	
		ParseInt( param, "SSQStatus", m_nSSQStatus);
		ParseInt( param, "NeedPoint1", m_nNeedPoint1);
		ParseInt( param, "NeedPoint2", m_nNeedPoint2);
		ParseInt( param, "SealNum", sealnum);
		for(i=0; i<sealnum; i++)
		{
		 	 ParseInt( param, "SealID_" $ i, m_nSealID);
			 ParseInt( param, "OwnerTeamID_" $ i, m_nOwnerTeamID);
			 ParseInt( param, "Team2Mark_" $ i, m_nTeam2Mark);
			 ParseInt( param, "Team1Mark_" $ i, m_nTeam1Mark);
			
			AddSSQSealStatus(m_nSSQStatus, m_nNeedPoint1, m_nNeedPoint2, m_nSealID,  m_nOwnerTeamID, m_nTeam1Mark, m_nTeam2Mark);
			//debug (" aha / " $ m_nSSQStatus $" aha / " $ m_nNeedPoint1 $" aha / " $ m_nNeedPoint2 $" aha / " $ m_nSealID $" aha / " $ m_nOwnerTeamID $" aha / " $ m_nTeam1Mark $ "aha / " $ m_nTeam2Mark );
		}
	}
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "s_btnRenew":
		if (m_bShowPreInfo)
		{
			class'SSQAPI'.static.RequestSSQStatus(SSQR_PREINFO);	//EV_SSQPreInfo ?? ???????? ??????
		}
		else
		{
			class'SSQAPI'.static.RequestSSQStatus(SSQR_STATUS);	//EV_SSQStatus ?? ???????? ??????
		}
		break;
	case "s_btnPreview":
		m_bShowPreInfo = !m_bShowPreInfo;
		if (m_bShowPreInfo)
		{
			class'SSQAPI'.static.RequestSSQStatus(SSQR_PREINFO);	//EV_SSQPreInfo ?? ???????? ??????
		}
		SetSSQStatus();
		break;
	case "ss_btnRenew":
		ShowSSQSealStatus();
		break;
	case "me_btnRenew":
		ShowSSQMainEvent();
		break;
	case "TabCtrl0":
		SetSSQStatus();	//???? ???????? Child?? ???? Show?? ?????????? ???? ??????????.
		break;
	case "TabCtrl1":
		//?????? ???? ???? ???? - ???? ?????? ????????
		if (!m_bRequest_MainEvent)
		{
			ShowSSQMainEvent();
			m_bRequest_MainEvent = true;
		}
		break;
	case "TabCtrl2":
		//???? ???? ???? - ???? ?????? ????????
		if (!m_bRequest_SealStatus)
		{
			ShowSSQSealStatus();
			m_bRequest_SealStatus = true;
		}
		break;
	}
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	SSQ Status
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////
//???? ???? ?????? ???? ???? ????
function SetSSQStatus()
{
	if(m_bShowPreInfo)
	{
		class'UIAPI_BUTTON'.static.SetButtonName("SSQMainBoard.s_btnPreview", 939);
		class'UIAPI_WINDOW'.static.ShowWindow("SSQMainBoard.SSQStatusWnd_Preview");
		class'UIAPI_WINDOW'.static.HideWindow("SSQMainBoard.SSQStatusWnd_Status");
	}
	else
	{
		class'UIAPI_BUTTON'.static.SetButtonName("SSQMainBoard.s_btnPreview", 937);
		class'UIAPI_WINDOW'.static.ShowWindow("SSQMainBoard.SSQStatusWnd_Status");
		class'UIAPI_WINDOW'.static.HideWindow("SSQMainBoard.SSQStatusWnd_Preview");
	}
}

//////////////////////
//Set SSQ Status Info
function SetSSQStatusInfo()
{
	//????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtTime", g_sinfo.m_nPeriod $ " " $ GetSystemString(934));
	//??????????????
	//(?????? ?????? 6??????)
	if (g_sinfo.m_nMsgNum1>0)
	{
		//debug("sidhd : " $ g_sinfo.m_nMsgNum1);
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtSta1", GetSystemMessage(g_sinfo.m_nMsgNum1));
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtSta1", "");
	}
	if (g_sinfo.m_nMsgNum2 >0)
	{
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtSta2", GetSystemMessage(g_sinfo.m_nMsgNum2));
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtSta2", "");
	}
	//???? ?????? ????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtMyTeamName", GetSSQTeamName(g_sinfo.m_nSSQTeam));
	//???? ???? ????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtMySealName", GetSSQSealName(g_sinfo.m_nSelectedSeal));
	//?????? ?????? ????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtMySealStoneCount", g_sinfo.m_nContribution $ GetSystemString(932));
	//?????? ?????? ????(to ????????)
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtMySealStoneCountAdena", "(" $ g_sinfo.m_nSealStoneAdena $ GetSystemString(933) $ ")");
	//?????????
	if (g_sinfo.m_nSSQStatus==3)
	{
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtAllStaCur", " - " $ GetSystemString(838));
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtAllStaCur", " - " $ GetSystemString(837));
	}
	//?????? ??????/?????? ??????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtAllDawn", GetSSQTeamName(SSQT_DAWN));
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtAllDusk", GetSSQTeamName(SSQT_DUSK));
	//?????? ??????/?????? ??????(??????)
	class'UIAPI_WINDOW'.static.SetWindowSize("SSQMainBoard.texDawnValue", int(g_sinfo.m_nTeam2Per * 150.0f / 100.0f), 11);
	class'UIAPI_WINDOW'.static.SetWindowSize("SSQMainBoard.texDuskValue", int(g_sinfo.m_nTeam1Per * 150.0f / 100.0f), 11);
	
	//????????
	
	//?????? ??????/?????? ??????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDawn", GetSSQTeamName(SSQT_DAWN));
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDusk", GetSSQTeamName(SSQT_DUSK));
	//???? ????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDawn1", "" $ g_sinfo.m_nTeam2HuntingMark);
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDawn2", "" $ g_sinfo.m_nTeam2MainEventMark);
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDawn3", "" $ g_sinfo.m_nTeam2TotalMark);
	//???? ????
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDusk1", "" $ g_sinfo.m_nTeam1HuntingMark);
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDusk2", "" $ g_sinfo.m_nTeam1MainEventMark);
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.txtPointDusk3", "" $ g_sinfo.m_nTeam1TotalMark);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	SSQ PreInfo
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////
//Clear SSQ Pre Info
function ClearSSQPreInfo()
{
	g_sinfopre.m_nWinner = 0;
	g_sinfopre.m_nRoomNum = 0;
	g_sinfopre.m_nSealNumArray.Remove(0, g_sinfopre.m_nSealNumArray.Length);
	g_sinfopre.m_nWinnerArray.Remove(0, g_sinfopre.m_nWinnerArray.Length);
	g_sinfopre.m_nMsgArray.Remove(0, g_sinfopre.m_nMsgArray.Length);
}

////////////////////
//Set SSQ Pre Info
function SetSSQPreInfo()
{
	local string strTmp;
	
	//ex) ?????? ?????? ????
	if (g_sinfopre.m_nWinner == 1)
	{
		strTmp = GetSSQTeamName(SSQT_DUSK);
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.pre_txtWinTeam", strTmp $ " " $ GetSystemString(828));
	}
	else if (g_sinfopre.m_nWinner == 2)
	{
		strTmp = GetSSQTeamName(SSQT_DAWN);
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.pre_txtWinTeam", strTmp $ " " $ GetSystemString(828));
	}
	else
	{
		class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.pre_txtWinTeam", "");
	}
	//????
	if (g_sinfopre.m_nWinner != 0)
	{
		strTmp = MakeFullSystemMsg(GetSystemMessage(1288), strTmp, "");
	}
	else
	{
		strTmp = GetSystemMessage(1293);
	}
	class'UIAPI_TEXTBOX'.static.SetText("SSQMainBoard.pre_txtWinText", strTmp);
	//???? ???? ???? ????
	AddSSQPreInfoSealStatus();
}

//////////////////////////////////////
//Add SSQ Pre Seal Status TreeItem
function AddSSQPreInfoSealStatus()
{
	local int			i;
	
	local int			nSealNum;
	local int			nWinner;
	local int			nMsgNum;
	
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string		strRetName;
	
	// 0. ??????
	class'UIAPI_TREECTRL'.static.Clear("SSQMainBoard.pre_MainTree");
	
	// 1. ???????? ?????? Hide?????? ????
	if (g_sinfopre.m_nSealNumArray.Length<1)
	{
		class'UIAPI_WINDOW'.static.HideWindow("SSQMainBoard.pre_MainTree");
		return;
	}
	else
	{
		class'UIAPI_WINDOW'.static.ShowWindow("SSQMainBoard.pre_MainTree");
	}
	
	// 2. Add Root Item
	infNode.strName = "root";
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.pre_MainTree", "", infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	// 3 . Insert Root Node - with no Button
	infNode = infNodeClear;
	infNode.strName = "node";
	infNode.nOffSetX = 2;
	infNode.nOffSetY = 3;
	infNode.bShowButton = 0;
	infNode.bDrawBackground = 1;
	infNode.bTexBackHighlight = 1;
	infNode.nTexBackHighlightHeight = 17;
	infNode.nTexBackWidth = 240;
	infNode.nTexBackUWidth = 211;
	infNode.nTexBackOffSetX = -3;
	infNode.nTexBackOffSetY = -4;
	infNode.nTexBackOffSetBottom = 2;
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.pre_MainTree", "root", infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	for(i=0; i<g_sinfopre.m_nSealNumArray.Length; i++)
	{
		nSealNum = g_sinfopre.m_nSealNumArray[i];
		nWinner = g_sinfopre.m_nWinnerArray[i];
		nMsgNum = g_sinfopre.m_nMsgArray[i];
		
		//Insert Node Item - Seal Name	
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSSQSealName(nSealNum) $ " : ";
		infNodeItem.nOffSetX = 4;
		infNodeItem.nOffSetY = 0;
		infNodeItem.t_color.R = 128;
		infNodeItem.t_color.G = 128;
		infNodeItem.t_color.B = 128;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.pre_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ??????
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		if (nWinner == 1)
		{
			infNodeItem.t_strText = GetSSQTeamName(SSQT_DUSK);
		}
		else if (nWinner == 2)
		{
			infNodeItem.t_strText = GetSSQTeamName(SSQT_DAWN);
		}
		else
		{
			infNodeItem.t_strText = GetSystemString(936);
		}
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 0;
		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.pre_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ????
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSystemMessage(nMsgNum);
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetX = 8;
		infNodeItem.nOffSetY = 6;
		infNodeItem.t_color.R = 128;
		infNodeItem.t_color.G = 128;
		infNodeItem.t_color.B = 128;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.pre_MainTree", strRetName, infNodeItem);
		
		if (i != g_sinfopre.m_nSealNumArray.Length-1)
		{
			//Insert Node Item - Blank
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_BLANK;
			infNodeItem.b_nHeight = 20;
			class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.pre_MainTree", strRetName, infNodeItem);
		}
	}
}
	

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	SSQ Main Event
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////
//Clear SSQ Main Event Info
function ClearSSQMainEventInfo(out SSQMainEventInfo info)
{
	local int i;
	for (i=0; i<NC_PARTYMEMBER_MAX; i++)
	{
		info.m_Team1MemberName[i] = "";
		info.m_Team2MemberName[i] = "";
	}
}

/////////////////////////////
//Request SSQ Main Event
function ShowSSQMainEvent()
{
	local XMLTreeNodeInfo	infNode;
	local string		strRetName;
	
	// 0. ??????
	class'UIAPI_TREECTRL'.static.Clear("SSQMainBoard.me_MainTree");
		
	// 1. Add Root Item
	infNode.strName = "root";
	infNode.nOffSetX = 3;
	infNode.nOffSetY = 5;
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.me_MainTree", "", infNode);
	
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	// 2. Request SSQ Main Event
	class'SSQAPI'.static.RequestSSQStatus(SSQR_MAINEVENT);		//EV_SSQMainEvent ???????? ??????
}

//////////////////////////////
//Add MainEvent to TreeItem
function AddSSQMainEvent(SSQMainEventInfo info)
{
	local int			i;
	
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string		strRetName;
	local string		strNodeName;
	local string		strTmp;
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Event Type Node
	
	//* ???? ???? ???????? ???? Event Type???? ????????.
	// (?????? "??????????"???? ????)
	strNodeName = "root." $ info.m_nEventType;
	if (class'UIAPI_TREECTRL'.static.IsNodeNameExist("SSQMainBoard.me_MainTree", strNodeName))
	{
		strRetName = strNodeName;
	}
	else
	{
		//////////////////////////////////////////////////////////////////////////////////////////////////////
		//Insert Node - with Button
		infNode = infNodeClear;
		infNode.strName = "" $ info.m_nEventType;
		infNode.bShowButton = 1;
		infNode.nTexBtnWidth = 14;
		infNode.nTexBtnHeight = 14;
		infNode.strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
		infNode.strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
		infNode.strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
		infNode.strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";
		
		//Expand?????????? BackTexture????
		//?????????? ?????? ?????? ExpandedWidth?? ????. ?????? -2???? ?????? ??????.
		infNode.nTexExpandedOffSetY = 1;		//OffSet
		infNode.nTexExpandedHeight = 13;		//Height
		infNode.nTexExpandedRightWidth = 32;		//?????? ???????????????? ????
		infNode.nTexExpandedLeftUWidth = 16; 		//?????????? ???? ???? ???????? UV????
		infNode.nTexExpandedLeftUHeight = 13;
		infNode.nTexExpandedRightUWidth = 32; 	//?????????? ???? ?????? ???????? UV????
		infNode.nTexExpandedRightUHeight = 13;
		infNode.strTexExpandedLeft = "L2UI_CH3.ListCtrl.TextSelect";
		infNode.strTexExpandedRight = "L2UI_CH3.ListCtrl.TextSelect2";
		
		strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.me_MainTree", "root", infNode);
		if (Len(strRetName) < 1)
		{
			debug("ERROR: Can't insert node. Name: " $ infNode.strName);
			return;
		}
		
		//Insert Node Item - Event Name
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		if (info.m_nEventType == SSQE_TIMEATTACK)
		{
			infNodeItem.t_strText = GetSystemString(845);
		}
		else
		{
			infNodeItem.t_strText = GetSystemString(27);	//????
		}
		infNodeItem.nOffSetX = 4;
		infNodeItem.nOffSetY = 2;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - Blank
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_BLANK;
		infNodeItem.b_nHeight = 8;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	}
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Event Room Node
	infNode = infNodeClear;
	infNode.strName = "" $ info.m_nEventNo;
	infNode.nOffSetX = 7;
	infNode.nOffSetY = 0;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = 14;
	infNode.nTexBtnHeight = 14;
	infNode.strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndDownBtn";
	infNode.strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndUpBtn";
	infNode.strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndDownBtn_over";
	infNode.strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndUpBtn_over";
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.me_MainTree", strRetName, infNode);
	if (Len(strRetName) < 1)
	{
		Log("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//Insert Node Item - Room Name
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQTimeAttackEventRoomName(info.m_nEventNo);
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 2;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "??????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	if (info.m_nSSQStatus == 1)
	{
		//??????
		infNodeItem.t_strText = GetSystemString(829);
	}
	else
	{
		//????
		if (info.m_nTeam1Score > info.m_nTeam2Score)
		{
			infNodeItem.t_strText = "(" $ GetSystemString(923) $ " " $ GetSystemString(828) $ ")";
		}
		else if (info.m_nTeam1Score < info.m_nTeam2Score)
		{
			infNodeItem.t_strText = "(" $ GetSystemString(924) $ " " $ GetSystemString(828) $ ")";
		}
		else
		{
			infNodeItem.t_strText = "(" $ GetSystemString(846) $ ")";
		}
	}
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 2;
	infNodeItem.t_color.R = 176;
	infNodeItem.t_color.G = 155;
	infNodeItem.t_color.B = 121;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "????: "
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(831) $ " : ";
	infNodeItem.bLineBreak = true;
	infNodeItem.nOffSetX = 19;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - xx
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = "" $ info.m_nWinPoint;
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 176;
	infNodeItem.t_color.G = 155;
	infNodeItem.t_color.B = 121;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 8;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Member Name List Node
	infNode = infNodeClear;
	infNode.strName = "member";
	infNode.nOffSetX = 2;
	infNode.nOffSetY = 0;
	infNode.bShowButton = 0;
	infNode.bDrawBackground = 1;
	infNode.bTexBackHighlight = 1;
	infNode.nTexBackHighlightHeight = 16;
	infNode.nTexBackWidth = 218;
	infNode.nTexBackUWidth = 211;
	infNode.nTexBackOffSetX = 0;
	infNode.nTexBackOffSetY = -3;
	infNode.nTexBackOffSetBottom = -2;
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.me_MainTree", strRetName, infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//Insert Node Item - Team1 Name
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQTeamName(SSQT_DAWN);
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 0;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "???? ????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(830);
	infNodeItem.bLineBreak = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Team1 ????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = "" $ info.m_nTeam1Score;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 176;
	infNodeItem.t_color.G = 155;
	infNodeItem.t_color.B = 121;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "??????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(832);
	infNodeItem.bLineBreak = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - ?????? ??????
	for (i=0; i<NC_PARTYMEMBER_MAX; i++)
	{
		strTmp = info.m_Team1MemberName[i];
		if (Len(strTmp)>0)
		{
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			infNodeItem.t_strText = strTmp;
			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 5;
			infNodeItem.nOffSetY = 4;
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);		
		}
	}
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 20;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Team2 Name
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQTeamName(SSQT_DUSK);
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 0;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "???? ????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(830);
	infNodeItem.bLineBreak = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Team2 ????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = "" $ info.m_nTeam2Score;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 176;
	infNodeItem.t_color.G = 155;
	infNodeItem.t_color.B = 121;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "??????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(832);
	infNodeItem.bLineBreak = true;
	infNodeItem.nOffSetX = 5;
	infNodeItem.nOffSetY = 4;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - ?????? ??????
	for (i=0; i<NC_PARTYMEMBER_MAX; i++)
	{
		strTmp = info.m_Team2MemberName[i];
		if (Len(strTmp)>0)
		{
			infNodeItem = infNodeItemClear;
			infNodeItem.eType = XTNITEM_TEXT;
			infNodeItem.t_strText = strTmp;
			infNodeItem.bLineBreak = true;
			infNodeItem.nOffSetX = 5;
			infNodeItem.nOffSetY = 4;
			infNodeItem.t_color.R = 176;
			infNodeItem.t_color.G = 155;
			infNodeItem.t_color.B = 121;
			infNodeItem.t_color.A = 255;
			class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);		
		}
	}
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 4;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.me_MainTree", strRetName, infNodeItem);
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	SSQ Seal Status Wnd 
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////
//Request Seal Status
function ShowSSQSealStatus()
{
	local XMLTreeNodeInfo	infNode;
	local string		strRetName;
	
	// 0. ??????
	class'UIAPI_TREECTRL'.static.Clear("SSQMainBoard.ss_MainTree");
		
	// 1. Add Root Item
	infNode.strName = "root";
	infNode.nOffSetX = 3;
	infNode.nOffSetY = 5;
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.ss_MainTree", "", infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
		return;
	}
	
	// 2. Request Seal Status
	if (g_sinfo.m_nMsgNum1 == 1183)	// ?????????? ???????? ?????????? ??????????????. (????????)
	{
		AddSSQSealStatus(1,10,35,1,0,0,0);
		AddSSQSealStatus(1,10,35,2,0,0,0);
		AddSSQSealStatus(1,10,35,3,0,0,0);
	}
	else
	{	
		class'SSQAPI'.static.RequestSSQStatus(SSQR_SEALSTATUS);		//EV_SSQSealStatus?? ???????? ??????
	}
}

////////////////////////////////////
//Add SSQ SealStatus to TreeItem
function AddSSQSealStatus(int m_nSSQStatus, int m_nNeedPoint1, int m_nNeedPoint2, int m_nSealID,  int m_nOwnerTeamID, int m_nTeam1Mark, int m_nTeam2Mark)
{
	local int			i;
	local int			nMax;
	local int			nStrID;
	local int			nNeedPoint;
	local int			nTmp;
	
	local float			fBarX;
	local float			fBarWidth;
	local int			nWidth;
	local int			nHeight;
	
	local XMLTreeNodeInfo	infNode;
	local XMLTreeNodeItemInfo	infNodeItem;
	local XMLTreeNodeInfo	infNodeClear;
	local XMLTreeNodeItemInfo	infNodeItemClear;
	local string		strRetName;
	local string		strTmp;
	
	//Get Seal Name
	strTmp = GetSSQSealName(m_nSealID);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - with Button
	infNode = infNodeClear;
	infNode.strName = "" $ m_nSealID;
	infNode.bShowButton = 1;
	infNode.nTexBtnWidth = 14;
	infNode.nTexBtnHeight = 14;
	infNode.strTexBtnExpand = "L2UI_CH3.QUESTWND.QuestWndPlusBtn";
	infNode.strTexBtnCollapse = "L2UI_CH3.QUESTWND.QuestWndMinusBtn";
	infNode.strTexBtnExpand_Over = "L2UI_CH3.QUESTWND.QuestWndPlusBtn_over";
	infNode.strTexBtnCollapse_Over = "L2UI_CH3.QUESTWND.QuestWndMinusBtn_over";
	
	//Expand?????????? BackTexture????
	//?????????? ?????? ?????? ExpandedWidth?? ????. ?????? -2???? ?????? ??????.
	infNode.nTexExpandedOffSetY = 1;		//OffSet
	infNode.nTexExpandedHeight = 13;		//Height
	infNode.nTexExpandedRightWidth = 32;		//?????? ???????????????? ????
	infNode.nTexExpandedLeftUWidth = 16; 		//?????????? ???? ???? ???????? UV????
	infNode.nTexExpandedLeftUHeight = 13;
	infNode.nTexExpandedRightUWidth = 32; 	//?????????? ???? ?????? ???????? UV????
	infNode.nTexExpandedRightUHeight = 13;
	infNode.strTexExpandedLeft = "L2UI_CH3.ListCtrl.TextSelect";
	infNode.strTexExpandedRight = "L2UI_CH3.ListCtrl.TextSelect2";
	
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.ss_MainTree", "root", infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//Insert Node Item - Seal Name
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = strTmp;
	infNodeItem.nOffSetX = 4;
	infNodeItem.nOffSetY = 2;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "???? ????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSystemString(823);
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = 5;
	infNodeItem.bLineBreak = true;
	infNodeItem.bStopMouseFocus = true;	//???? ?????? ?????????????? ????.
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Team Name
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQTeamName(m_nOwnerTeamID);
	infNodeItem.nOffSetX = 4;
	infNodeItem.nOffSetY = 5;
	infNodeItem.t_color.R = 176;
	infNodeItem.t_color.G = 155;
	infNodeItem.t_color.B = 121;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "?????? ??????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQTeamName(2);
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = 7;
	infNodeItem.bLineBreak = true;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//???? ??????
	
	fBarX = 80.0f;
	fBarWidth = 140.0f;
	
	//Insert Node Item - ????BAR
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = 2;
	infNodeItem.nOffSetY = 7;
	infNodeItem.u_nTextureWidth = fBarWidth;
	infNodeItem.u_nTextureHeight = 11;
	infNodeItem.u_nTextureUWidth = 8;
	infNodeItem.u_nTextureUHeight = 11;
	infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar2back";
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	if (m_nOwnerTeamID == SSQT_DAWN)
	{
		nNeedPoint = m_nNeedPoint1;
	}
	else
	{
		nNeedPoint = m_nNeedPoint2;
	}
	
	if (m_nTeam1Mark > nNeedPoint)
	{
		//Insert Node Item - ????BAR
		//CDC->DrawTexture(BarX,iOffsetY,BarW*(float)(NeedPoint/100.f),11,0,0,8,11,m_pBar11);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -fBarWidth;
		infNodeItem.nOffSetY = 7;
		infNodeItem.u_nTextureWidth = fBarWidth * (nNeedPoint/100.0f);
		nTmp = infNodeItem.u_nTextureWidth;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_nTextureUWidth = 8;
		infNodeItem.u_nTextureUHeight = 11;
		infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar21";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ????BAR(????????)
		//CDC->DrawTexture(BarX+BarW*(float)(NeedPoint/100.f),iOffsetY,BarW*(float)((Team1Mark-NeedPoint)/100.f),11,0,0,8,11,m_pBar12);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 7;
		infNodeItem.u_nTextureWidth = fBarWidth * ((m_nTeam1Mark-nNeedPoint)/100.0f);
		nTmp = nTmp + infNodeItem.u_nTextureWidth;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_nTextureUWidth = 8;
		infNodeItem.u_nTextureUHeight = 11;
		infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar22";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	}
	else
	{
		//Insert Node Item - ????BAR
		//CDC->DrawTexture(BarX,iOffsetY,BarW*(float)(Team1Mark/100.f),11,0,0,8,11,m_pBar11);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -fBarWidth;
		infNodeItem.nOffSetY = 7;
		infNodeItem.u_nTextureWidth = fBarWidth * (m_nTeam1Mark/100.0f);
		nTmp = infNodeItem.u_nTextureWidth;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_nTextureUWidth = 8;
		infNodeItem.u_nTextureUHeight = 11;
		infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar21";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	}
	
	//Insert Node Item - ????BARLINE
	//CDC->DrawTexture(BarX+BarW*(float)(NeedPoint/100.f),iOffsetY,1,11,0,0,1,11,m_pBarLine);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -nTmp + fBarWidth * (nNeedPoint/100.0f);
	infNodeItem.nOffSetY = 7;
	infNodeItem.u_nTextureWidth = 1;
	nTmp = fBarWidth * (nNeedPoint/100.0f) + 1;
	infNodeItem.u_nTextureHeight = 11;
	infNodeItem.u_nTextureUWidth = 1;
	infNodeItem.u_nTextureUHeight = 11;
	infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_barline";
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - ??%
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = m_nTeam1Mark $ "%";
	
	GetTextSize(infNodeItem.t_strText, nWidth, nHeight);
	
	infNodeItem.nOffSetX = -nTmp + (fBarWidth/2) - (nWidth/2);	
	infNodeItem.nOffSetY = 8;
	infNodeItem.t_color.R = 255;
	infNodeItem.t_color.G = 255;
	infNodeItem.t_color.B = 255;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - "?????? ??????"
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQTeamName(1);
	infNodeItem.nOffSetX = 0;
	infNodeItem.nOffSetY = 6;
	infNodeItem.bLineBreak = true;
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//???? ??????
	
	//Insert Node Item - ????BAR
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = 2;
	infNodeItem.nOffSetY = 6;
	infNodeItem.u_nTextureWidth = fBarWidth;
	infNodeItem.u_nTextureHeight = 11;
	infNodeItem.u_nTextureUWidth = 8;
	infNodeItem.u_nTextureUHeight = 11;
	infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar1back";
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	if (m_nOwnerTeamID == SSQT_DUSK)
	{
		nNeedPoint = m_nNeedPoint1;
	}
	else
	{
		nNeedPoint = m_nNeedPoint2;
	}
	
	if (m_nTeam2Mark > nNeedPoint)
	{
		//Insert Node Item - ????BAR
		//CDC->DrawTexture(BarX,iOffsetY,BarW*(float)(NeedPoint/100.f),11,0,0,8,11,m_pBar11);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -fBarWidth;
		infNodeItem.nOffSetY = 6;
		infNodeItem.u_nTextureWidth = fBarWidth * (nNeedPoint/100.0f);
		nTmp = infNodeItem.u_nTextureWidth;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_nTextureUWidth = 8;
		infNodeItem.u_nTextureUHeight = 11;
		infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar11";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ????BAR(????????)
		//CDC->DrawTexture(BarX+BarW*(float)(NeedPoint/100.f),iOffsetY,BarW*(float)((Team1Mark-NeedPoint)/100.f),11,0,0,8,11,m_pBar12);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = 0;
		infNodeItem.nOffSetY = 6;
		infNodeItem.u_nTextureWidth = fBarWidth * ((m_nTeam2Mark-nNeedPoint)/100.0f);
		nTmp = nTmp + infNodeItem.u_nTextureWidth;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_nTextureUWidth = 8;
		infNodeItem.u_nTextureUHeight = 11;
		infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar12";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	}
	else
	{
		//Insert Node Item - ????BAR
		//CDC->DrawTexture(BarX,iOffsetY,BarW*(float)(Team1Mark/100.f),11,0,0,8,11,m_pBar11);
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXTURE;
		infNodeItem.nOffSetX = -fBarWidth;
		infNodeItem.nOffSetY = 6;
		infNodeItem.u_nTextureWidth = fBarWidth * (m_nTeam2Mark/100.0f);
		nTmp = infNodeItem.u_nTextureWidth;
		infNodeItem.u_nTextureHeight = 11;
		infNodeItem.u_nTextureUWidth = 8;
		infNodeItem.u_nTextureUHeight = 11;
		infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_bar11";
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	}
	
	//Insert Node Item - ????BARLINE
	//CDC->DrawTexture(BarX+BarW*(float)(NeedPoint/100.f),iOffsetY,1,11,0,0,1,11,m_pBarLine);
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXTURE;
	infNodeItem.nOffSetX = -nTmp + fBarWidth * (nNeedPoint/100.0f);
	infNodeItem.nOffSetY = 6;
	infNodeItem.u_nTextureWidth = 1;
	nTmp = fBarWidth * (nNeedPoint/100.0f) + 1;
	infNodeItem.u_nTextureHeight = 11;
	infNodeItem.u_nTextureUWidth = 1;
	infNodeItem.u_nTextureUHeight = 11;
	infNodeItem.u_strTexture = "L2UI_CH3.SSQWnd.ssq_barline";
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - ??%
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = m_nTeam2Mark $ "%";
	
	GetTextSize(infNodeItem.t_strText, nWidth, nHeight);
	
	infNodeItem.nOffSetX = -nTmp + (fBarWidth/2) - (nWidth/2);
	infNodeItem.nOffSetY = 6;
	infNodeItem.t_color.R = 255;
	infNodeItem.t_color.G = 255;
	infNodeItem.t_color.B = 255;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 12;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//////////////////////////////////////////////////////////////////////////////////////////////////////
	//Insert Node - Seal Description	
	infNode = infNodeClear;
	infNode.strName = "desc";
	infNode.bShowButton = 0;
	infNode.bDrawBackground = 1;
	infNode.bTexBackHighlight = 1;
	infNode.nTexBackHighlightHeight = 18;
	infNode.nTexBackWidth = 218;
	infNode.nTexBackUWidth = 211;
	infNode.nTexBackOffSetX = -4;
	infNode.nTexBackOffSetY = -3;
	infNode.nTexBackOffSetBottom = -3;
	strRetName = class'UIAPI_TREECTRL'.static.InsertNode("SSQMainBoard.ss_MainTree", strRetName, infNode);
	if (Len(strRetName) < 1)
	{
		debug("ERROR: Can't insert node. Name: " $ infNode.strName);
		return;
	}
	
	//Insert Node Item - ????
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_TEXT;
	infNodeItem.t_strText = GetSSQSealDesc(m_nSealID);
	infNodeItem.t_color.R = 128;
	infNodeItem.t_color.G = 128;
	infNodeItem.t_color.B = 128;
	infNodeItem.t_color.A = 255;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 18;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	
	if(m_nSealID == SSQS_GREED)
	{
		nMax = 16;
		nStrID = 941;
	}
	else if (m_nSealID == SSQS_REVEAL)
	{
		nMax = 12;
		nStrID = 957;
	}
	else
	{
		nMax = 0;
	}
	
	for(i=0; i<nMax; i+=2)
	{
		//Insert Node Item - ??????
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSystemString(nStrID+i);
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetY = 6;
		infNodeItem.t_color.R = 128;
		infNodeItem.t_color.G = 128;
		infNodeItem.t_color.B = 128;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ":"
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = ":";
		infNodeItem.bLineBreak = true;
		infNodeItem.nOffSetY = 6;
		infNodeItem.t_color.R = 128;
		infNodeItem.t_color.G = 128;
		infNodeItem.t_color.B = 128;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
		
		//Insert Node Item - ":"
		infNodeItem = infNodeItemClear;
		infNodeItem.eType = XTNITEM_TEXT;
		infNodeItem.t_strText = GetSystemString(nStrID+i+1);
		infNodeItem.nOffSetY = 6;
		infNodeItem.t_color.R = 176;
		infNodeItem.t_color.G = 155;
		infNodeItem.t_color.B = 121;
		infNodeItem.t_color.A = 255;
		class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
	}
	
	//Insert Node Item - Blank
	infNodeItem = infNodeItemClear;
	infNodeItem.eType = XTNITEM_BLANK;
	infNodeItem.b_nHeight = 6;
	class'UIAPI_TREECTRL'.static.InsertNodeItem("SSQMainBoard.ss_MainTree", strRetName, infNodeItem);
}

function string GetSSQSealName(int nID)
{
	local int nStrID;

	if(nID == SSQS_GREED)
	{
		nStrID = 816;	//?????? ????
	}
	else if (nID == SSQS_REVEAL)
	{
		nStrID = 817;	//?????? ????
	}
	else if (nID == SSQS_STRIFE)
	{
		nStrID = 818;	//?????? ????
	}
	else
	{
		nStrID = 27;	//????
	}
	return GetSystemString(nStrID);
}

function string GetSSQTeamName(int nID)
{
	local int nStrID;

	if(nID == SSQT_DUSK)
	{
		nStrID = 815;	//????
	}
	else if (nID == SSQT_DAWN)
	{
		nStrID = 814;	//????
	}
	else
	{
		nStrID = 27;	//????
	}
	return GetSystemString(nStrID);
}

function string GetSSQSealDesc(int nID)
{
	local int nStrID;

	if(nID == SSQS_GREED)
	{
		nStrID = 1178;	//????
	}
	else if (nID == SSQS_REVEAL)
	{
		nStrID = 1179;	//????
	}
	else if (nID == SSQS_STRIFE)
	{
		nStrID = 1180;	//????
	}
	else
	{
		nStrID = 27;	//????
	}
	return GetSystemMessage(nStrID);
}

function string GetSSQTimeAttackEventRoomName(int nID)
{
	local int nStrID;

	if(nID == 1)
	{
		nStrID = 819;	//???? ?????? ??????
	}
	else if (nID == 2)
	{
		nStrID = 820;	//64???? ???? ??????
	}
	else if (nID == 3)
	{
		nStrID = 821;	//53???? ???? ??????
	}
	else if (nID == 4)
	{
		nStrID = 844;	//43???? ???? ??????
	}
	else if (nID == 5)
	{
		nStrID = 822;	//31???? ???? ??????
	}
	else
	{
		nStrID = 27;	//????
	}
	return GetSystemString(nStrID);
}
defaultproperties
{
}
