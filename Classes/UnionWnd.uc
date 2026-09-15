class UnionWnd extends UICommonAPI;

var bool m_bChOpened;

//Handle List
var WindowHandle	Me;
var WindowHandle	PartyMemberWnd;

var TextBoxHandle	txtOwner;
var TextBoxHandle	txtRoutingType;
var TextBoxHandle	txtCountInfo;
var ButtonHandle 	banBtn;
var ButtonHandle		quitBtn;
var ListCtrlHandle	lstParty;

var string	m_UserName;
var int		m_PartyNum;
var int		m_PartyMemberNum;
var int		m_SearchedMasterID;

function OnLoad()
{
	RegisterEvent( EV_CommandChannelStart );
	RegisterEvent( EV_CommandChannelEnd );
	RegisterEvent( EV_CommandChannelInfo );
	RegisterEvent( EV_CommandChannelPartyList );
	RegisterEvent( EV_CommandChannelPartyUpdate );
	RegisterEvent( EV_CommandChannelRoutingType );
	
	m_bChOpened = false;
	m_PartyNum = 0;
	m_PartyMemberNum = 0;
	m_SearchedMasterID = 0;
	
	Me = GetHandle( "UnionWnd" );
	PartyMemberWnd = GetHandle( "UnionDetailWnd" );
	
	txtOwner = TextBoxHandle( GetHandle( "UnionWnd.txtOwner" ) );
	txtRoutingType = TextBoxHandle( GetHandle( "UnionWnd.txtRoutingType" ) );
	txtCountInfo = TextBoxHandle( GetHandle( "UnionWnd.txtCountInfo" ) );
	lstParty = ListCtrlHandle( GetHandle( "UnionWnd.lstParty" ) );
	banBtn = ButtonHandle( GetHandle("UnionWnd.btnBan"));
	quitBtn = ButtonHandle( GetHandle("UnionWnd.btnOut"));
}

function OnShow()
{
	local UserInfo a_UserInfo;
	GetPlayerInfo( a_UserInfo );
	m_UserName = a_UserInfo.Name;
	PartyMemberWnd.HideWindow();
	SetFocus();
}
	
function OnEnterState( name a_PreStateName )
{
	if (m_bChOpened)
	{
		Me.ShowWindow();
	}
	else
	{
		Me.HideWindow();
	}
}

function OnEvent(int Event_ID, string param)
{
	if (Event_ID == EV_CommandChannelStart)
	{
		HandleCommandChannelStart();
	}
	else if (Event_ID == EV_CommandChannelEnd)
	{
		HandleCommandChannelEnd();
	}
	else if (Event_ID == EV_CommandChannelInfo)
	{
		HandleCommandChannelInfo(param);
	}
	else if (Event_ID == EV_CommandChannelPartyList)
	{
		HandleCommandChannelPartyList(param);
	}
	else if (Event_ID == EV_CommandChannelPartyUpdate)
	{
		HandleCommandChannelPartyUpdate(param);
	}
	else if (Event_ID == EV_CommandChannelRoutingType)
	{
		HandleCommandChannelRoutingType(param);
	}
}

//?????? ????????
function OnDBClickListCtrlRecord( String strID )
{
	if (strID == "lstParty")
		RequestPartyMember(true);
}

//??????
function Clear()
{
	MemberClear();
	txtOwner.SetText("");
	txtRoutingType.SetText(GetSystemString(1383));
	txtCountInfo.SetText("");
}

//???????? ??????
function MemberClear()
{
	lstParty.DeleteAllItem();
}

function OnClickButton( string strID )
{
	switch( strID )
	{
	case "btnRefresh":
		OnRefreshClick();
		break;
	case "btnBan":
		OnBanClick();
		break;
	case "btnOut":
		OnOutClick();
		break;
	case "btnMemberInfo":
		OnMemberInfoClick();
		break;
	}
}

//[????????]
function OnRefreshClick()
{
	RequestNewInfo();
}

function RequestNewInfo()
{
	class'CommandChannelAPI'.static.RequestCommandChannelInfo();
}

//[????]
function OnBanClick()
{
	local int idx;
	local LVDataRecord record;
	local string PartyMasterName;
	
	idx = lstParty.GetSelectedIndex();
	if (idx>-1)
	{
		record = lstParty.GetRecord(idx);
		PartyMasterName = record.LVDataList[0].szData;
		if (Len(PartyMasterName)>0)
		{
			class'CommandChannelAPI'.static.RequestCommandChannelBanParty(PartyMasterName);
		}
	}
}

//[????]
function OnOutClick()
{
	class'CommandChannelAPI'.static.RequestCommandChannelWithdraw();
}

//[????????]
function OnMemberInfoClick()
{
	if (PartyMemberWnd.IsShowWindow())
		PartyMemberWnd.HideWindow();
	else
		RequestPartyMember(true);
}

function RequestPartyMember(bool bShowWindow)
{
	
	local LVDataRecord Record;
	local string PartyMasterName;
	local int MasterID;
	
	local UnionDetailWnd Script;
	Script = UnionDetailWnd(GetScript("UnionDetailWnd"));
	
	m_SearchedMasterID = 0;
	Record = lstParty.GetSelectedRecord();
	PartyMasterName = Record.LVDataList[0].szData;
	MasterID = Record.nReserved1;
	
	if (Len(PartyMasterName)>0 && MasterID>0)
	{
		if (bShowWindow)
		{
			if (!PartyMemberWnd.IsShowWindow())
				PartyMemberWnd.ShowWindow();
		}
		
		m_SearchedMasterID = MasterID;
		Script.SetMasterInfo(PartyMasterName, MasterID);
		class'CommandChannelAPI'.static.RequestCommandChannelPartyMembersInfo(MasterID);
	}
}

//???????? ????
function HandleCommandChannelStart()
{
	Me.ShowWindow();
	Me.SetFocus();
	m_bChOpened = true;
	
	RequestNewInfo();
	class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnBan");
	class'UIAPI_WINDOW'.static.DisableWindow("UnionWnd.btnOut");
}

//???????? ????
function HandleCommandChannelEnd()
{
	Me.HideWindow();
	Clear();
	m_bChOpened = false;
}

//???????? ????
function HandleCommandChannelInfo(string param)
{
	local string	OwnerName;
	local int		RoutingType;
	local int		PartyNum;
	local int		PartyMemberNum;
	
	MemberClear();
	
	ParseString(param, "OwnerName" ,OwnerName);
	ParseInt(param, "RoutingType" ,RoutingType);
	ParseInt(param, "PartyNum" ,PartyNum);
	ParseInt(param, "PartyMemberNum" ,PartyMemberNum);
	
	m_PartyNum = PartyNum;
	m_PartyMemberNum = PartyMemberNum;
	
	txtOwner.SetText(OwnerName);
	UpdateRoutingType(RoutingType);
	UpdateCountInfo();
	
	if (OwnerName == m_UserName)
	{
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnBan");
	}
	
}

//???????? ??????
function HandleCommandChannelPartyList(string param)
{
	local LVDataRecord	record;
	
	local string MasterName;
	local int MasterID;
	local int PartyNum;
	local int TotalCount;
	
	ParseString(param, "MasterName", MasterName);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "PartyNum", PartyNum);
	
	record.LVDataList.length = 2;
	record.nReserved1 = MasterID;
	record.LVDataList[0].szData = MasterName;
	record.LVDataList[1].szData = string(PartyNum);
	lstParty.InsertRecord(record);
	
	//???? ?????? ??????ID?? ???????? ?????????????? ???????? ??????
	//?????? ???????? ??????????, ?????? ??????????.
	if (m_SearchedMasterID>0 && m_SearchedMasterID==MasterID)
	{
		if (PartyMemberWnd.IsShowWindow())
		{
			TotalCount = lstParty.GetRecordCount();
			if (TotalCount>0)
				lstParty.SetSelectedIndex(TotalCount-1, false);	
			RequestPartyMember(false);
		}
	}
	
	if (MasterName == m_UserName)
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
}

//???????? ????
function HandleCommandChannelPartyUpdate(string param)
{
	local LVDataRecord	record;
	local int SearchIdx;
	
	local string MasterName;
	local int MasterID;
	local int MemberCount;
	local int Type;
	
	local UnionDetailWnd Script;
	
	ParseString(param, "MasterName", MasterName);
	ParseInt(param, "MasterID", MasterID);
	ParseInt(param, "MemberCount", MemberCount);
	ParseInt(param, "Type", Type);
	
	if (MasterID<1)
		return;
	
	switch (Type)
	{
	case 0:	//leave
		SearchIdx = FindMasterID(MasterID);
		if (SearchIdx>-1)
		{
			record = lstParty.GetRecord(SearchIdx);
			MemberCount = int(record.LVDataList[1].szData);
			lstParty.DeleteRecord(SearchIdx);
			
			m_PartyNum--;
			m_PartyMemberNum = m_PartyMemberNum - MemberCount;
			
			if (PartyMemberWnd.IsShowWindow())
			{
				Script = UnionDetailWnd(GetScript("UnionDetailWnd"));
				if (MasterID == Script.GetMasterID())
				{
					Script.Clear();
					PartyMemberWnd.HideWindow();
				}
			}	
		}
		break;
	case 1: //join
		record.LVDataList.length = 2;
		record.nReserved1 = MasterID;
		record.LVDataList[0].szData = MasterName;
		record.LVDataList[1].szData = string(MemberCount);
		lstParty.InsertRecord(record);
		m_PartyNum++;
		m_PartyMemberNum = m_PartyMemberNum + MemberCount;
		break;
	}
	
	UpdateCountInfo();

	if (MasterName == m_UserName)
		class'UIAPI_WINDOW'.static.EnableWindow("UnionWnd.btnOut");
}

function HandleCommandChannelRoutingType(string param)
{
	local int RoutingType;
	
	ParseInt(param, "RoutingType" ,RoutingType);
	UpdateRoutingType(RoutingType);
}

//???????? ????
function UpdateRoutingType(int Type)
{
	if (Type==0)
	{
		txtRoutingType.SetText(GetSystemString(1383));
	}
	else if (Type==1)
	{
		txtRoutingType.SetText(GetSystemString(1384));
	}
}

function int FindMasterID(int MasterID)
{
	local int idx;
	local LVDataRecord	record;
	local int SearchIdx;
	
	SearchIdx = -1;
	for (idx=0; idx<lstParty.GetRecordCount(); idx++)
	{
		record = lstParty.GetRecord(idx);
		if (record.nReserved1 == MasterID)
		{
			SearchIdx = idx;
			break;
		}
	}
	return SearchIdx;
}

//???????? ????
function UpdateCountInfo()
{
	txtCountInfo.SetText(String(m_PartyNum) $ GetSystemString(440) $ " / " $ m_PartyMemberNum $ GetSystemString(1013));
}

//?????? ?? ????
function UpdatePartyMemberCount(int MasterID, int MemberCount)
{
	local int idx;
	local LVDataRecord record;
	
	idx = FindMasterID(MasterID);
	if (idx>-1)
	{
		record = lstParty.GetRecord(idx);
		m_PartyMemberNum = m_PartyMemberNum - int(record.LVDataList[1].szData);
		m_PartyMemberNum = m_PartyMemberNum + MemberCount;
		record.LVDataList[1].szData = string(MemberCount);
		lstParty.ModifyRecord(idx, record);
	}
	UpdateCountInfo();
}

//???????? ???? ????
function OnExitState( name a_NextStateName )
{
	if( a_NextStateName == 'LoadingState' )
		HandleCommandChannelEnd();
}

function SetFocus ()
{
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.lstParty");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.txtOwnerHead");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.txtOwner");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.txtRoutingTypeHead");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.txtRoutingType");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.txtCountInfo");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.btnRefresh");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.btnBan");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.btnOut");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.btnMemberInfo");
  Class'UIAPI_WINDOW'.static.SetFocus("UnionWnd.BtnMin");
}
defaultproperties
{
}
