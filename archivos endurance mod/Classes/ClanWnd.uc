class ClanWnd extends UICommonAPI;

var string m_WindowName;
var int m_clanID;
var string m_clanName;
var int m_clanRank;
var int m_clanLevel;
var int m_clanNameValue;
var int m_bMoreInfo;
var int m_currentShowIndex;
var int G_CurrentRecord;
var string G_CurrentSzData;
var bool G_CurrentAlias;
var bool G_IamNobless;
var bool G_IamHero;
var int G_ClanMember;
var int m_myClanType;
var string m_myName;
var string m_myClanName;
var int m_indexNum;
var bool m_currentactivestatus1;
var bool m_currentactivestatus2;
var bool m_currentactivestatus3;
var bool m_currentactivestatus4;
var bool m_currentactivestatus5;
var bool m_currentactivestatus6;
var bool m_currentactivestatus7;
var bool m_currentactivestatus8;
var int m_bClanMaster;
var int m_bJoin;
var int m_bNickName;
var int m_bCrest;
var int m_bWar;
var int OnLineNum;
var int m_bGrade;
var int m_bManageMaster;
var int m_bOustMember;
var string m_CurrentclanMasterName;
var string m_CurrentclanMasterReal;
var int zzm_CurrentNHType;
var array<ClanInfo> zzm_memberList;
var private string zzComboBoxMainClanWnd;
var private TextBoxHandle zzClanNameText;
var private TextBoxHandle zzClanMasterNameText;
var private TextBoxHandle zzClanLevelText;
var private TextBoxHandle zzClanPointsText;
var private WindowHandle zzRoyalIcon[8];
var int m_clanWarListPage;
var private ClanDrawerWnd zzdrawer_Script;
var WindowHandle Me;
var Texture Tex_ClanCrest;
var Texture Tex_AllyCrest;
var TextureHandle allycrest;
var TextureHandle clancrest;

function Init()
{
	local int i;

	Me = GetHandle(m_WindowName);
	zzComboBoxMainClanWnd = m_WindowName$".ComboBoxMainClanWnd";
	zzClanNameText = xxGetTextBoxHandle(m_WindowName$".ClanNameText");
	zzClanMasterNameText = xxGetTextBoxHandle(m_WindowName$".ClanMasterNameText");
	zzClanLevelText = xxGetTextBoxHandle(m_WindowName$".ClanLevelText");
	zzClanPointsText = xxGetTextBoxHandle(m_WindowName$".ClanPointsText");
	zzdrawer_Script = ClanDrawerWnd(GetScript("ClanDrawerWnd"));
	allycrest = xxGetTextureHandle(m_WindowName$".allyCrest");
	clancrest = xxGetTextureHandle(m_WindowName$".clanCrest");
	i = 0;
J0xDB:
	if( i < 8 )
	{
		zzRoyalIcon[i] = GetHandle((m_WindowName$".RoyalIcon")$string(i + 1));
		++i;
		goto J0xDB;
	}
}

function getmyClanInfo()
{
	local UserInfo UserInfo;

	if( GetPlayerInfo(UserInfo) )
	{
		m_myName = UserInfo.Name;
		m_myClanType = findmyClanData(m_myName);
		G_IamNobless = UserInfo.bNobless;
		G_IamHero = UserInfo.bHero;
		G_ClanMember = UserInfo.nClanID;
	}
}

function int findmyClanData(string C_Name)
{
	local int i, j, clannum;

	i = 0;
J0x07:
	if( i < zzm_memberList.Length )
	{
		j = 0;
	J0x1E:
		if( j < zzm_memberList[i].m_array.Length )
		{
			if( zzm_memberList[i].m_array[j].sName == C_Name )
			{
				clannum = zzm_memberList[i].m_array[j].clanType;
			}
			++j;
			goto J0x1E;
		}
		++i;
		goto J0x07;
	}
	return clannum;
}

function OnLoad()
{
	RegisterEvents();
	Init();
	zzm_memberList.Length = 8;
	m_currentShowIndex = 0;
	m_bMoreInfo = 0;
	G_CurrentAlias = False;
	Clear();
	m_currentactivestatus1 = False;
	m_currentactivestatus2 = False;
	m_currentactivestatus3 = False;
	m_currentactivestatus4 = False;
	m_currentactivestatus5 = False;
	m_currentactivestatus6 = False;
	m_currentactivestatus7 = False;
	m_clanWarListPage = -1;
}

function RegisterEvents()
{
	RegisterEvent(320);
	RegisterEvent(330);
	RegisterEvent(420);
	RegisterEvent(400);
	RegisterEvent(440);
	RegisterEvent(410);
	RegisterEvent(450);
	RegisterEvent(150);
	RegisterEvent(160);
	RegisterEvent(340);
	RegisterEvent(480);
	RegisterEvent(490);
	RegisterEvent(460);
	RegisterEvent(470);
	RegisterEvent(500);
	RegisterEvent(360);
	RegisterEvent(580);
	RegisterEvent(EV_GamingStateEnter);
}

function OnEvent(int a_EventID, string a_Param)
{
	switch(a_EventID)
	{
		case EV_GamingStateEnter:
			Clear();
			break;
		case 420:
			Clear();
			break;
            
		case 320:
			HandleClanInfo(a_Param);
			break;
            
		case 410:
			HandleAddClanMemberMultiple(a_Param);
			break;
            
		case 440:
			HandleMemberInfoUpdate(a_Param);
			break;
            
		case 400:
			HandleAddClanMember(a_Param);
			break;
            
		case 450:
			HandleDeleteMember(a_Param);
			break;
            
		case 330:
			HandleClanInfoUpdate(a_Param);
			break;
            
		case 480:
			HandleSubClanUpdated(a_Param);
			break;
            
		case 340:
			HandleClanMyAuth(a_Param);
			break;
            
		case 490:
			HandleSkillList(a_Param);
			break;
            
		case 460:
			HandleClanWarList(a_Param);
			break;
            
		case 470:
			HandleClearWarList(a_Param);
			break;
            
		case 500:
			HandleSkillListAdd(a_Param);
			break;        

		case 360:
			HandleCrestChange();
			break;

		case 580:
			HandleSystemMessage(a_Param);
			break;
            
		default:
			break;
	}
}

function HandleSystemMessage(string a_Param)
{
	local int index;

	ParseInt(a_Param, "Index", index);
	switch(index)
	{
		case 1861:
			HandleCrestChange();
			break;

		case 1663:
			Me.KillTimer(10900);
			Me.SetTimer(10900, 500);
			break;

		default:
			break;
	}
}

function OnTimer(int TimerID)
{
	switch(TimerID)
	{
		case 10900:
			Me.KillTimer(10900);
			HandleCrestChange();
			break;

		default:
			break;
	}
}

function string GetWarStateString(int State)
{
	if( State == 0 )
	{
		return GetSystemString(1429);        
	}
	else
	{
		if( State == 1 )
		{
			return GetSystemString(1430);            
		}
		else
		{
			if( State == 2 )
			{
				return GetSystemString(1367);
			}
		}
	}
	return "Error";
}

function HandleClanWarList (string param)
{
	local string ClanName;
	local int Type;
	local int Period;
	local LVDataRecord Record;
	local int Page;

	ParseInt(param,"Page",Page);
	ParseString(param,"ClanName",ClanName);
	ParseInt(param,"Type",Type);
	ParseInt(param,"Period",Period);
	Record.LVDataList.Length = 3;
	Record.LVDataList[0].szData = ClanName;
	Record.LVDataList[1].szData = GetWarStateString(Type);
	Record.LVDataList[2].szData = string(Period);
	if ( (Type == 0) || (Type == 2) )
	{
		Class'UIAPI_TABCTRL'.static.SetTopOrder(m_WindowName$".ClanWarTab",0,True);
		Class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".DeclaredListCtrl",Record);
	}
	else
	{
		Class'UIAPI_TABCTRL'.static.SetTopOrder(m_WindowName$".ClanWarTab",1,True);
		m_clanWarListPage = Page;
		Class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".GotDeclaredListCtrl",Record);
	}
}


function HandleCancelWar1()
{
	local LVDataRecord Record;
	local int Index;

	Index = Class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".DeclaredListCtrl");
	if( Index >= 0 )
	{
		Record = Class'UIAPI_LISTCTRL'.static.GetRecord(m_WindowName$".DeclaredListCtrl", Index);
		RequestClanWithdrawWarWithClanName(Record.LVDataList[0].szData);
		RequestClanWarList(0, 0);
	}
}

function HandleDeclareWar()
{
	local LVDataRecord Record;
	local int Index;

	Index = Class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".GotDeclaredListCtrl");
	if( Index >= 0 )
	{
		Record = Class'UIAPI_LISTCTRL'.static.GetRecord(m_WindowName$".GotDeclaredListCtrl", Index);
		RequestClanDeclareWarWidhClanName(Record.LVDataList[0].szData);
		RequestClanWarList(m_clanWarListPage, 1);
	}
}

function HandleCancelWar2()
{
	local LVDataRecord Record;
	local int Index;

	Index = Class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".GotDeclaredListCtrl");
	if( Index >= 0 )
	{
		Record = Class'UIAPI_LISTCTRL'.static.GetRecord(m_WindowName$".GotDeclaredListCtrl", Index);
		RequestClanWithdrawWarWithClanName(Record.LVDataList[0].szData);
		RequestClanWarList(m_clanWarListPage, 1);
		Class'UIAPI_TABCTRL'.static.SetTopOrder(m_WindowName$".ClanWarTabCtrl", 1, True);
		Class'UIAPI_WINDOW'.static.ShowWindow(m_WindowName$".ClanWarManagementWnd");
	}
}

function HandleClearWarList(string a_Param)
{
	local int Condition;

	if( ParseInt(a_Param, "Condition", Condition) )
	{
		if( Condition == 0 )
		{
			Class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".DeclaredListCtrl");            
		}
		else
		{
			Class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".GotDeclaredListCtrl");
		}
	}
}

function OnShow()
{
	local int i;

	getmyClanInfo();
	HandleCrestChange();
	RefreshCombobox();
	resetBtnShowHide();
	NoblessMenuValidate();
	i = 10;
J0x20:
	if( i >= 0 )
	{
		if( Class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName$".ComboBoxMainClanWnd", i) == m_myClanType )
		{
			Class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName$".ComboBoxMainClanWnd", i);
		}
		--i;
		goto J0x20;
	}
	ShowList(m_myClanType);
	Class'UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName$".ClanMemberList", m_indexNum, True);
	if( m_myClanType == -1 )
	{
		Class'UIAPI_LISTCTRL'.static.SetSelectedIndex(m_WindowName$".ClanMemberList", m_indexNum - 1, True);
	}
	InitializeClanInfoWnd();
}

function NoblessMenuValidate()
{
	if( G_ClanMember == 0 )
	{
		if( (G_IamHero == True) || G_IamNobless == True )
		{
			ShowWindow(m_WindowName$".ClanTittleBtn");
            //HideWindow(m_WindowName $ ".ClanMemInfoBtn");            
		}
		else
		{
			HideWindow(m_WindowName$".ClanTittleBtn");
            //ShowWindow(m_WindowName $ ".ClanMemInfoBtn");
		}        
	}
	else
	{
		HideWindow(m_WindowName$".ClanTittleBtn");
        //ShowWindow(m_WindowName $ ".ClanMemInfoBtn");
	}
}

function OnHide()
{
	HideWindow("ClanDrawerWnd");
}

function OnEnterState(name a_PreStateName)
{
	getmyClanInfo();
	NoblessMenuValidate();
	if( a_PreStateName == 'LoadingState' )
	{
		Clear();
	}
}

function OnClickButton(string strID)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 10;
	switch(strID)
	{
		case "ClanPenaltyBtn":
			ExecuteCommandFromAction("pledgepenalty");
			break;
            
		case "ClanAskJoinBtn":
			AskJoin();
			break;
            
		case "ClanQuitBtn":
			RequestClanLeave(m_clanName, m_myClanType);
			break;
            
		case "ClanMemAuthBtn":
			if( m_currentactivestatus2 == False )
			{
				ResetOpeningVariables();
				m_currentactivestatus2 = True;
				if( GetSelectedListCtrlItem(Record) )
				{
					RequestClanMemberAuth(Record.nReserved1, Record.LVDataList[0].szData);
					zzdrawer_Script.SetStateAndShow("ClanMemberAuthState");
				}                
			}
			else
			{
				m_currentactivestatus2 = False;
				zzdrawer_Script.HideWindow();
			}
			break;
            
                                             // End:0x4D4
		case "ClanTittleBtn":
			
												 // End:0x4BA
			if( m_currentactivestatus7 == False )
			{
				ResetOpeningVariables();
				m_currentactivestatus7 = True;
				zzdrawer_Script.SetStateAndShow("ClanHeroWndState");                                                        
			}
			else
			{
				m_currentactivestatus7 = False;
				zzdrawer_Script.HideWindow();
			}                                                    
			

			break;

		case "ClanAuthEditBtn":
			if( m_currentactivestatus6 == False )
			{
				ResetOpeningVariables();
				m_currentactivestatus6 = True;
				RequestClanGradeList();
				zzdrawer_Script.SetStateAndShow("ClanAuthManageWndState");                
			}
			else
			{
				m_currentactivestatus6 = False;
				zzdrawer_Script.HideWindow();
			}
			break;
            
		case "EditCrestBtn":
			if( m_currentactivestatus7 == False )
			{
				ResetOpeningVariables();
				m_currentactivestatus7 = True;
				zzdrawer_Script.SetStateAndShow("ClanEmblemManageWndState");                
			}
			else
			{
				m_currentactivestatus7 = False;
				zzdrawer_Script.HideWindow();
			}
			break;
            
		case "ClanWarDeclareBtn":
			RequestClanDeclareWar();
			break;
            
        // case "ClanWarCancleBtn":
        //     RequestClanWithdrawWar();
        // break;
            
		case "CancelWarBtn":
			HandleCancelWar1();
			break;
            
		case "CancelWar2Btn":
			HandleCancelWar2();
			break;
            
		case "DeclareWarBtn":
			HandleDeclareWar();
			break;
            
		case "MoreWarBtn":
			RequestClanWarList(++m_clanWarListPage, 1);
			break;

		default:
			break;
	}
}

function OnComboBoxItemSelected(string sName, int Index)
{
	ClearList();
	ShowList(Class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName$".ComboBoxMainClanWnd", Class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".ComboBoxMainClanWnd")));
}

function OnClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 10;
	if( ListCtrlID == "ClanMemberList" )
	{
		if( m_currentactivestatus1 == True )
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = True;
			if( GetSelectedListCtrlItem(Record) )
			{
				RequestClanMemberInfo(Record.nReserved1, Record.LVDataList[0].szData);
				G_CurrentRecord = Record.nReserved1;
				G_CurrentSzData = Record.LVDataList[0].szData;
				if( Record.LVDataList[3].szData == "0" )
				{
					G_CurrentAlias = True;                    
				}
				else
				{
					G_CurrentAlias = False;
				}
				zzdrawer_Script.SetStateAndShow("ClanMemberInfoState");
			}
		}
		if( m_currentactivestatus2 == True )
		{
			ResetOpeningVariables();
			m_currentactivestatus2 = True;
			if( GetSelectedListCtrlItem(Record) )
			{
				RequestClanMemberAuth(Record.nReserved1, Record.LVDataList[0].szData);
				zzdrawer_Script.SetStateAndShow("ClanMemberAuthState");
			}
		}
	}
}

function OnDBClickListCtrlRecord(string ListCtrlID)
{
	local LVDataRecord Record;

	Record.LVDataList.Length = 10;
	if( ListCtrlID == "ClanMemberList" )
	{
		if( m_currentactivestatus1 == False )
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = True;
			if( GetSelectedListCtrlItem(Record) )
			{
				RequestClanMemberInfo(Record.nReserved1, Record.LVDataList[0].szData);
				G_CurrentRecord = Record.nReserved1;
				G_CurrentSzData = Record.LVDataList[0].szData;
				if( Record.LVDataList[3].szData == "0" )
				{
					G_CurrentAlias = True;                    
				}
				else
				{
					G_CurrentAlias = False;
				}
				zzdrawer_Script.SetStateAndShow("ClanMemberInfoState");
			}            
		}
		else
		{
			ResetOpeningVariables();
			m_currentactivestatus1 = True;
			if( GetSelectedListCtrlItem(Record) )
			{
				RequestClanMemberInfo(Record.nReserved1, Record.LVDataList[0].szData);
				G_CurrentRecord = Record.nReserved1;
				G_CurrentSzData = Record.LVDataList[0].szData;
				zzdrawer_Script.SetStateAndShow("ClanMemberInfoState");
			}
		}
	}
}

function resetBtnShowHide()
{
	NoblessMenuValidate();
	if( m_clanID == 0 )
	{
        //DisableWindow(m_WindowName $ ".ClanMemInfoBtn");
		DisableWindow(m_WindowName$".ClanMemAuthBtn");
        //DisableWindow(m_WindowName $ ".ClanBoardBtn");
        //DisableWindow(m_WindowName $ ".ClanInfoBtn");
		DisableWindow(m_WindowName$".ClanQuitBtn");
        //DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
		DisableWindow(m_WindowName$".ClanWarDeclareBtn");
        //DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
		DisableWindow(m_WindowName$".ClanAskJoinBtn");
		DisableWindow(m_WindowName$".ClanAuthEditBtn");
		DisableWindow(m_WindowName$".EditCrestBtn");        
	}
	else
	{
		if( m_clanLevel > 5 )
		{
            //EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
			EnableWindow(m_WindowName$".ClanMemAuthBtn");
            //EnableWindow(m_WindowName $ ".ClanBoardBtn");
            //EnableWindow(m_WindowName $ ".ClanInfoBtn");
			EnableWindow(m_WindowName$".ClanPenaltyBtn");
			EnableWindow(m_WindowName$".ClanQuitBtn");
            //EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
			EnableWindow(m_WindowName$".ClanWarDeclareBtn");
            //EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
			EnableWindow(m_WindowName$".ClanAskJoinBtn");
			DisableWindow(m_WindowName$".ClanAuthEditBtn");
			DisableWindow(m_WindowName$".EditCrestBtn");
			EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
			DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
			EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
			EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
			EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");            
		}
		else
		{
			switch(m_clanLevel)
			{
				case 0:
                    //EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					EnableWindow(m_WindowName$".ClanMemAuthBtn");
                    //DisableWindow(m_WindowName $ ".ClanBoardBtn");
                    //EnableWindow(m_WindowName $ ".ClanInfoBtn");
					EnableWindow(m_WindowName$".ClanPenaltyBtn");
					EnableWindow(m_WindowName$".ClanQuitBtn");
                    //DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
					DisableWindow(m_WindowName$".ClanWarDeclareBtn");
                    //DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
					EnableWindow(m_WindowName$".ClanAskJoinBtn");
					DisableWindow(m_WindowName$".ClanAuthEditBtn");
					DisableWindow(m_WindowName$".EditCrestBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
                    
				case 1:
                   // EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					EnableWindow(m_WindowName$".ClanMemAuthBtn");
                   //DisableWindow(m_WindowName $ ".ClanBoardBtn");
                    //EnableWindow(m_WindowName $ ".ClanInfoBtn");
					EnableWindow(m_WindowName$".ClanPenaltyBtn");
					EnableWindow(m_WindowName$".ClanQuitBtn");
                    //DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
					DisableWindow(m_WindowName$".ClanWarDeclareBtn");
                   // DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
					EnableWindow(m_WindowName$".ClanAskJoinBtn");
					DisableWindow(m_WindowName$".ClanAuthEditBtn");
					DisableWindow(m_WindowName$".EditCrestBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
                    
				case 2:
                    //EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					EnableWindow(m_WindowName$".ClanMemAuthBtn");
                   // EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    //EnableWindow(m_WindowName $ ".ClanInfoBtn");
					EnableWindow(m_WindowName$".ClanPenaltyBtn");
					EnableWindow(m_WindowName$".ClanQuitBtn");
                   // DisableWindow(m_WindowName $ ".ClanWarInfoBtn");
					DisableWindow(m_WindowName$".ClanWarDeclareBtn");
                    //DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
					EnableWindow(m_WindowName$".ClanAskJoinBtn");
					DisableWindow(m_WindowName$".ClanAuthEditBtn");
					DisableWindow(m_WindowName$".EditCrestBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
                    
				case 3:
                    //EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					EnableWindow(m_WindowName$".ClanMemAuthBtn");
                    //EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    //EnableWindow(m_WindowName $ ".ClanInfoBtn");
					EnableWindow(m_WindowName$".ClanPenaltyBtn");
					EnableWindow(m_WindowName$".ClanQuitBtn");
                    //EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
					EnableWindow(m_WindowName$".ClanWarDeclareBtn");
                    //EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
					EnableWindow(m_WindowName$".ClanAskJoinBtn");
					DisableWindow(m_WindowName$".ClanAuthEditBtn");
					DisableWindow(m_WindowName$".EditCrestBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
                    
				case 4:
                    //EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					EnableWindow(m_WindowName$".ClanMemAuthBtn");
                    //EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    //EnableWindow(m_WindowName $ ".ClanInfoBtn");
					EnableWindow(m_WindowName$".ClanPenaltyBtn");
					EnableWindow(m_WindowName$".ClanQuitBtn");
                   // EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
					EnableWindow(m_WindowName$".ClanWarDeclareBtn");
                    //EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
					EnableWindow(m_WindowName$".ClanAskJoinBtn");
					DisableWindow(m_WindowName$".ClanAuthEditBtn");
					DisableWindow(m_WindowName$".EditCrestBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
                    
				case 5:
                    //EnableWindow(m_WindowName $ ".ClanMemInfoBtn");
					EnableWindow(m_WindowName$".ClanMemAuthBtn");
                   // EnableWindow(m_WindowName $ ".ClanBoardBtn");
                    //EnableWindow(m_WindowName $ ".ClanInfoBtn");
					EnableWindow(m_WindowName$".ClanPenaltyBtn");
					EnableWindow(m_WindowName$".ClanQuitBtn");
                    //EnableWindow(m_WindowName $ ".ClanWarInfoBtn");
					EnableWindow(m_WindowName$".ClanWarDeclareBtn");
                    //EnableWindow(m_WindowName $ ".ClanWarCancleBtn");
					EnableWindow(m_WindowName$".ClanAskJoinBtn");
					DisableWindow(m_WindowName$".ClanAuthEditBtn");
					DisableWindow(m_WindowName$".EditCrestBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
					DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
					EnableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
					EnableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
					EnableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
					break;
                    
				default:
					break;
			}
		}
		if( m_bClanMaster > 0 )
		{
			DisableWindow(m_WindowName$".ClanQuitBtn");
			if( m_clanLevel > 2 )
			{
				EnableWindow(m_WindowName$".EditCrestBtn");
			}
			EnableWindow(m_WindowName$".ClanAuthEditBtn");            
		}
		else
		{
			DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberNameBtn");
			DisableWindow("ClanDrawerWnd.Clan1_ChangeBanishBtn");
			DisableWindow("ClanDrawerWnd.Clan1_ChangeMemberGradeBtn");
			DisableWindow("ClanDrawerWnd.Clan1_AssignApprenticeBtn");
			DisableWindow("ClanDrawerWnd.Clan1_DeleteApprenticeBtn");
			if( m_bJoin == 0 )
			{
				DisableWindow(m_WindowName$".ClanAskJoinBtn");
			}
			if( m_bCrest == 0 )
			{
				DisableWindow(m_WindowName$".EditCrestBtn");                
			}
			else
			{
				if( m_clanLevel > 2 )
				{
					EnableWindow(m_WindowName$".EditCrestBtn");
				}
			}
			if( m_bWar == 0 )
			{
				DisableWindow(m_WindowName$".ClanWarDeclareBtn");
                // DisableWindow(m_WindowName $ ".ClanWarCancleBtn");
			}
		}
		zzdrawer_Script.CheckandCompareMyNameandDisableThings();
	}
	NoblessMenuValidate();
}

function Clear()
{
	local int i;

	ClearList();
	zzdrawer_Script.Clear();
	HideWindow("ClanDrawerWnd");
	HideWindow("InviteClanPopWnd");
	zzClanNameText.SetText("");
	zzClanMasterNameText.SetText("");
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanAgitText", GetSystemString(27));
	Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", "");
	zzClanLevelText.SetInt(0);
	zzClanPointsText.SetInt(0);
	allycrest.SetTexture("L2UI_CH3.null");
	clancrest.SetTexture("L2UI_CH3.null");
	Class'UIAPI_COMBOBOX'.static.Clear(m_WindowName$".ComboBoxMainClanWnd");
    //Class'UIAPI_ITEMWINDOW'.static.Clear("ClanWnd.ClanSkillWnd");
	m_clanID = 0;
	m_clanName = "";
	m_clanRank = 0;
	m_clanLevel = 0;
	m_clanNameValue = 0;
	m_bMoreInfo = 0;
	m_currentShowIndex = 0;
	m_bClanMaster = 0;
	m_bJoin = 0;
	m_bNickName = 0;
	m_bCrest = 0;
	m_bWar = 0;
	m_bGrade = 0;
	m_bManageMaster = 0;
	m_bOustMember = 0;
	m_clanWarListPage = -1;
	i = 0;
J0x16A:
	if( i < 8 )
	{
		zzm_memberList[i].m_array.Remove(0, zzm_memberList[i].m_array.Length);
		zzm_memberList[i].m_sName = "";
		zzm_memberList[i].m_sMasterName = "";
		++i;
		goto J0x16A;
	}
}

function HandleClanInfo(string a_Param)
{
	local string clanMasterName, ClanName;
	local int crestID, SkillLevel, castleID, AgitID, Status, bGuilty, allianceID;

	local string allianceName;
	local int AllianceCrestID, bInWar, clanType, clanRank, clanNameValue, clanID;

	ParseInt(a_Param, "ClanID", clanID);
	ParseInt(a_Param, "ClanType", clanType);
	zzm_CurrentNHType = clanType;
	ParseString(a_Param, "ClanName", ClanName);
	ParseString(a_Param, "ClanMasterName", clanMasterName);
	m_CurrentclanMasterName = clanMasterName;
	if( clanType == 0 )
	{
		m_CurrentclanMasterReal = clanMasterName;
	}
	ParseInt(a_Param, "CrestID", crestID);
	ParseInt(a_Param, "SkillLevel", SkillLevel);
	ParseInt(a_Param, "CastleID", castleID);
	ParseInt(a_Param, "AgitID", AgitID);
	ParseInt(a_Param, "ClanRank", clanRank);
	ParseInt(a_Param, "ClanNameValue", clanNameValue);
	ParseInt(a_Param, "Status", Status);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", allianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	ParseInt(a_Param, "InWar", bInWar);
	if( clanType == 0 )
	{
		m_clanName = ClanName;
		m_clanRank = clanRank;
		m_clanNameValue = clanNameValue;
		m_clanLevel = SkillLevel;
		m_clanID = clanID;
	}
	zzm_memberList[GetIndexFromType(clanType)].m_sName = ClanName;
	zzm_memberList[GetIndexFromType(clanType)].m_sMasterName = clanMasterName;
	if( clanType == 0 )
	{
		zzClanNameText.SetText(ClanName);
		zzClanMasterNameText.SetText(m_CurrentclanMasterReal);
		if( AgitID > 0 )
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".txt_ClanBaseName", GetCastleName(AgitID));            
		}
		else
		{

			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".txt_ClanBaseName", GetSystemString(27));
            
		}
		if( castleID > 0 )
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".txt_ClanCastleName", GetCastleName(castleID));                
		}
		else
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".txt_ClanCastleName", GetSystemString(27));
		}


		if( Status == 3 )
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", GetSystemString(341));            
		}
		else
		{
			if( bInWar == 0 )
			{
				Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", GetSystemString(894));                
			}
			else
			{
				Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", GetSystemString(340));
			}
		}
		zzClanLevelText.SetInt(SkillLevel);
		zzClanPointsText.SetInt(clanNameValue);
		HandleCrestChange();
	}
	RefreshCombobox();
	getmyClanInfo();
}

function HandleClanInfoUpdate(string a_Param)
{
	local int PledgeCrestID, castleID, AgitID, Status, bGuilty, allianceID;

	local string sAllianceName;
	local int AllianceCrestID, InWar, LargePledgeCrestID;

	ParseInt(a_Param, "ClanID", m_clanID);
	ParseInt(a_Param, "CrestID", PledgeCrestID);
	ParseInt(a_Param, "SkillLevel", m_clanLevel);
	ParseInt(a_Param, "CastleID", castleID);
	ParseInt(a_Param, "AgitID", AgitID);
	ParseInt(a_Param, "ClanRank", m_clanRank);
	ParseInt(a_Param, "ClanNameValue", m_clanNameValue);
	ParseInt(a_Param, "Status", Status);
	ParseInt(a_Param, "Guilty", bGuilty);
	ParseInt(a_Param, "AllianceID", allianceID);
	ParseString(a_Param, "AllianceName", sAllianceName);
	ParseInt(a_Param, "AllianceCrestID", AllianceCrestID);
	ParseInt(a_Param, "InWar", InWar);
	ParseInt(a_Param, "LargeCrestID", LargePledgeCrestID);
	InitializeClanInfoWnd();
	if( AgitID > 0 )
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanAgitText", GetCastleName(AgitID));        
	}
	else
	{
		if( castleID > 0 )
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanAgitText", GetCastleName(castleID));            
		}
		else
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanAgitText", GetSystemString(27));
		}
	}
	if( Status == 3 )
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", GetSystemString(341));        
	}
	else
	{
		if( InWar == 0 )
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", GetSystemString(894));            
		}
		else
		{
			Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanStatusText", GetSystemString(340));
		}
	}
	zzClanLevelText.SetInt(m_clanLevel);
	zzClanPointsText.SetInt(m_clanNameValue);
	resetBtnShowHide();
	getmyClanInfo();
	HandleCrestChange();
}

function HandleAddClanMemberMultiple(string a_Param)
{
	local ClanMemberInfo Info;
	local int Count, Index;

	ParseInt(a_Param, "ClanType", Info.clanType);
	Index = GetIndexFromType(Info.clanType);
	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
	Count = zzm_memberList[Index].m_array.Length;
	zzm_memberList[Index].m_array.Length = Count + 1;
	zzm_memberList[Index].m_array[Count] = Info;
	if( Index == m_currentShowIndex )
	{
		ShowList(Info.clanType);
	}
}

function ClearList()
{
	Class'UIAPI_LISTCTRL'.static.DeleteAllItem(m_WindowName$".ClanMemberList");
}

function ShowList(int clanType)
{
	local int Index;

	Index = GetIndexFromType(clanType);
	m_currentShowIndex = Index;
	ClearList();
	AddToList(Index);
}

function int getClanKnighthoodMasterInfo(string NameVal)
{
	local int i, ReturnVal;

	i = 0;
J0x07:
	if( i < zzm_memberList[0].m_array.Length )
	{
		if( zzm_memberList[0].m_array[i].sName == NameVal )
		{
			ReturnVal = i;
		}
		++i;
		goto J0x07;
	}
	return ReturnVal;
}

function AddToList(int idx)
{
	local Color White, Yellow, Blue, BrightWhite, Gold;

	local int i;
	local LVDataRecord Record;

	
	BrightWhite.R = 255;
	BrightWhite.G = 255;
	BrightWhite.B = 255;
	White.R = 170;
	White.G = 170;
	White.B = 170;
	Yellow.R = 235;
	Yellow.G = 205;
	Yellow.B = 0;
	Blue.R = 102;
	Blue.G = 150;
	Blue.B = 253;
	Gold.R = 176;
	Gold.G = 153;
	Gold.B = 121;
	OnLineNum = 0;
    

	Record.LVDataList.Length = 4;
	if( (GetClanTypeFromIndex(m_currentShowIndex)) <= 0 )
	{        
	}
	else
	{
		if( zzm_memberList[m_currentShowIndex].m_sMasterName == "" )
		{
			i = getClanKnighthoodMasterInfo(zzm_memberList[m_currentShowIndex].m_sMasterName);
			Record.LVDataList[0].bUseTextColor = True;
			Record.LVDataList[0].szData = GetSystemString(1445);
			Record.LVDataList[0].TextColor = Gold;
			Record.LVDataList[1].szData = "";
			Record.LVDataList[2].szData = "";
			Class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".ClanMemberList", Record);            
		}
		else
		{
			i = getClanKnighthoodMasterInfo(zzm_memberList[m_currentShowIndex].m_sMasterName);
			Record.LVDataList[0].bUseTextColor = True;
			Record.LVDataList[0].szData = zzm_memberList[m_currentShowIndex].m_sMasterName;
			Record.LVDataList[0].TextColor = Gold;
			Record.LVDataList[1].bUseTextColor = True;
			Record.LVDataList[1].TextColor = White;
			Record.LVDataList[1].szData = string(zzm_memberList[0].m_array[i].Level);
			Record.LVDataList[2].szData = string(zzm_memberList[0].m_array[i].ClassID);
			Record.LVDataList[2].szTexture = GetDetailedClassIconName(zzm_memberList[0].m_array[i].ClassID, 2);
			Record.LVDataList[2].nTextureWidth = 16;
			Record.LVDataList[2].nTextureHeight = 25;
			Record.LVDataList[3].nTextureWidth = 31;
			Record.LVDataList[3].nTextureHeight = 11;
			Record.nReserved1 = 0;
			if( zzm_memberList[0].m_array[i].Id > 0 )
			{
				Record.LVDataList[3].szData = "0";
				Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
				OnLineNum = 
					++OnLineNum;                
			}
			else
			{
				Record.LVDataList[3].szData = "0";
				Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
			}
			Class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".ClanMemberList", Record);
		}
		i = 0;
	}
	i = 0;
J0x466:
	if( i < zzm_memberList[idx].m_array.Length )
	{
		Record.LVDataList[0].bUseTextColor = True;
		Record.LVDataList[0].szData = zzm_memberList[idx].m_array[i].sName;
		if( zzm_memberList[idx].m_array[i].bHaveMaster == 0 )
		{
			Record.LVDataList[0].TextColor = White;            
		}
		else
		{
			Record.LVDataList[0].TextColor = Yellow;
		}
		if( zzm_memberList[idx].m_array[i].sName == m_myName )
		{
			Record.LVDataList[0].TextColor = BrightWhite;
			Record.LVDataList[1].TextColor = BrightWhite;
			if( (GetClanTypeFromIndex(m_currentShowIndex)) == 0 )
			{
				m_indexNum = i;                
			}
			else
			{
				m_indexNum = i + 1;
			}
		}
		Record.LVDataList[1].bUseTextColor = True;
		if( zzm_memberList[idx].m_array[i].sName == m_myName )
		{
			Record.LVDataList[1].TextColor = BrightWhite;            
		}
		else
		{
			Record.LVDataList[1].TextColor = White;
		}
		Record.LVDataList[1].szData = string(zzm_memberList[idx].m_array[i].Level);
		Record.LVDataList[2].szData = string(zzm_memberList[idx].m_array[i].ClassID);
		Record.LVDataList[2].szTexture = GetDetailedClassIconName(zzm_memberList[idx].m_array[i].ClassID, 2);
		Record.LVDataList[2].nTextureWidth = 16;
		Record.LVDataList[2].nTextureHeight = 25;
		Record.LVDataList[3].nTextureWidth = 31;
		Record.LVDataList[3].nTextureHeight = 11;
		Record.nReserved1 = zzm_memberList[idx].m_array[i].clanType;
		if( zzm_memberList[idx].m_array[i].Id > 0 )
		{
			Record.LVDataList[3].szData = "1";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logon";
			OnLineNum = 
				++OnLineNum;            
		}
		else
		{
			Record.LVDataList[3].szData = "2";
			Record.LVDataList[3].szTexture = "L2UI_CH3.BloodHoodWnd.BloodHood_Logoff";
		}
		Class'UIAPI_LISTCTRL'.static.InsertRecord(m_WindowName$".ClanMemberList", Record);
		++i;
		goto J0x466;
	}
	if( (GetClanTypeFromIndex(m_currentShowIndex)) <= 0 )
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanCurrentNum", ((("("$string(OnLineNum))$"/")$string(zzm_memberList[idx].m_array.Length))$")");        
	}
	else
	{
		Class'UIAPI_TEXTBOX'.static.SetText(m_WindowName$".ClanCurrentNum", ((("("$string(OnLineNum))$"/")$string(zzm_memberList[idx].m_array.Length + 1))$")");
	}        
	SetEXPBarInfo();


}


function SetEXPBarInfo()
{
	local ExpBarWnd s_Bar;

	s_Bar = ExpBarWnd(GetScript("ExpBarWnd"));
	s_Bar.AddClanInfo(OnLineNum, m_clanName);
    
}




function bool GetSelectedListCtrlItem(out LVDataRecord Record)
{
	local int Index;

	Index = Class'UIAPI_LISTCTRL'.static.GetSelectedIndex(m_WindowName$".ClanMemberList");
	if( Index >= 0 )
	{
		Record = Class'UIAPI_LISTCTRL'.static.GetRecord(m_WindowName$".ClanMemberList", Index);
		return True;
	}
	return False;
}

function HandleMemberInfoUpdate(string a_Param)
{
	local ClanMemberInfo Info;
	local int i, j, Count;
	local bool bHaveMasterChanged, bMemberChanged;
	local int process_length, process_clanindex;

	bHaveMasterChanged = False;
	bMemberChanged = False;
	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "PledgeType", Info.clanType);
	ParseInt(a_Param, "HaveMaster", Info.bHaveMaster);
	i = 0;
J0xFD:
	if( i < 8 )
	{
		Count = zzm_memberList[i].m_array.Length;
		j = 0;
	J0x127:
		if( j < Count )
		{
			if( zzm_memberList[i].m_array[j].sName == Info.sName )
			{
				if( zzm_memberList[i].m_array[j].bHaveMaster != Info.bHaveMaster )
				{
					bHaveMasterChanged = True;
					zzm_memberList[i].m_array[j] = Info;
				}
				if( zzm_memberList[i].m_array[j].clanType != Info.clanType )
				{
					bMemberChanged = True;
					zzm_memberList[i].m_array.Remove(j, 1);
					process_clanindex = GetIndexFromType(Info.clanType);
					process_length = zzm_memberList[process_clanindex].m_array.Length;
					zzm_memberList[process_clanindex].m_array.Insert(process_length, 1);
					zzm_memberList[process_clanindex].m_array[process_length].sName = Info.sName;
					zzm_memberList[process_clanindex].m_array[process_length].clanType = Info.clanType;
					zzm_memberList[process_clanindex].m_array[process_length].Level = Info.Level;
					zzm_memberList[process_clanindex].m_array[process_length].ClassID = Info.ClassID;
					zzm_memberList[process_clanindex].m_array[process_length].gender = Info.gender;
					zzm_memberList[process_clanindex].m_array[process_length].race = Info.race;
					zzm_memberList[process_clanindex].m_array[process_length].Id = Info.Id;
					zzm_memberList[process_clanindex].m_array[process_length].bHaveMaster = Info.bHaveMaster;
					Class'UIAPI_TEXTBOX'.static.SetText("ClanDrawerWnd.Clan1_CurrentSelectedMemberGrade", "");
					ShowList(Info.clanType);                    
				}
				else
				{
					zzm_memberList[i].m_array[j] = Info;
					ShowList(Info.clanType);
				}
				goto J0x3F8;
			}
			++j;
			goto J0x127;
		}
	J0x3F8:
		if( j < Count )
		{
			goto J0x414;
		}
		++i;
		goto J0xFD;
	}
J0x414:
	if( bHaveMasterChanged && IsShowWindow("ClanDrawerWnd.ClanMemberInfoWnd") )
	{
		if( zzdrawer_Script.m_currentName == Info.sName )
		{
			RequestClanMemberInfo(Info.clanType, Info.sName);
		}
		if( (GetIndexFromType(Info.clanType)) == m_currentShowIndex )
		{
			ShowList(Info.clanType);
		}
		ShowList(m_currentShowIndex);
	}
	if( bMemberChanged && IsShowWindow("ClanDrawerWnd.ClanMemberInfoWnd") )
	{
		ClearList();
		ShowList(Info.clanType);
		RefreshCombobox1(Info.clanType);
	}
}

function RefreshCombobox1(int ClanT)
{
	local int i;

	i = 0;
J0x07:
	if( i < 10 )
	{
		if( Class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName$".ComboBoxMainClanWnd", i) == ClanT )
		{
			Class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName$".ComboBoxMainClanWnd", i);
		}
		++i;
		goto J0x07;
	}
}

function HandleAddClanMember(string a_Param)
{
	local int Count;
	local ClanMemberInfo Info;

	ParseString(a_Param, "Name", Info.sName);
	ParseInt(a_Param, "Level", Info.Level);
	ParseInt(a_Param, "Class", Info.ClassID);
	ParseInt(a_Param, "Gender", Info.gender);
	ParseInt(a_Param, "Race", Info.race);
	ParseInt(a_Param, "ID", Info.Id);
	ParseInt(a_Param, "ClanType", Info.clanType);
	Info.bHaveMaster = 0;
	Count = zzm_memberList[GetIndexFromType(Info.clanType)].m_array.Length;
	zzm_memberList[GetIndexFromType(Info.clanType)].m_array.Length = Count + 1;
	zzm_memberList[GetIndexFromType(Info.clanType)].m_array[Count] = Info;
	if( (GetIndexFromType(Info.clanType)) == m_currentShowIndex )
	{
		ShowList(Info.clanType);
	}
}

function HandleDeleteMember(string a_Param)
{
	local int i, j, k, Count;
	local string sName;

	ParseString(a_Param, "Name", sName);
	i = 0;
J0x1D:
	if( i < 8 )
	{
		Count = zzm_memberList[i].m_array.Length;
		j = 0;
	J0x47:
		if( j < Count )
		{
			if( zzm_memberList[i].m_array[j].sName == sName )
			{
				k = j;
			J0x86:
				if( k < (Count - 1) )
				{
					zzm_memberList[i].m_array[k] = zzm_memberList[i].m_array[k + 1];
					++k;
					goto J0x86;
				}
				zzm_memberList[i].m_array.Length = Count - 1;
				goto J0xF9;
			}
			++j;
			goto J0x47;
		}
	J0xF9:
		if( j < Count )
		{
			goto J0x115;
		}
		++i;
		goto J0x1D;
	}
J0x115:
	if( i == m_currentShowIndex )
	{
		ShowList(i);
	}
}

function RefreshCombobox()
{
	local int i, Index, newIndex, addedCount;

	Index = Class'UIAPI_COMBOBOX'.static.GetSelectedNum(m_WindowName$".ComboBoxMainClanWnd");
	Class'UIAPI_COMBOBOX'.static.Clear(m_WindowName$".ComboBoxMainClanWnd");
	addedCount = -1;
	i = 0;
J0x40:
	if( i < 8 )
	{
		if( zzm_memberList[i].m_sName != "" )
		{
			Class'UIAPI_COMBOBOX'.static.AddStringWithReserved(m_WindowName$".ComboBoxMainClanWnd", ((GetClanTypeNameFromIndex(GetClanTypeFromIndex(i)))@"-")@zzm_memberList[i].m_sName, GetClanTypeFromIndex(i));
			++addedCount;
			if( i == m_currentShowIndex )
			{
				newIndex = addedCount;
			}
		}
		++i;
		goto J0x40;
	}
	i = 0;
J0xDC:
	if( i < 10 )
	{
		if( Class'UIAPI_COMBOBOX'.static.GetReserved(m_WindowName$".ComboBoxMainClanWnd", i) == m_myClanType )
		{
			Class'UIAPI_COMBOBOX'.static.SetSelectedNum(m_WindowName$".ComboBoxMainClanWnd", i);
		}
		++i;
		goto J0xDC;
	}
}

function HandleSubClanUpdated(string a_Param)
{
	local int Id, Type;
	local string sName, sMasterName;

	ParseInt(a_Param, "ClanID", Id);
	ParseInt(a_Param, "ClanType", Type);
	ParseString(a_Param, "ClanName", sName);
	ParseString(a_Param, "MasterName", sMasterName);
	zzm_memberList[GetIndexFromType(Type)].m_sName = sName;
	zzm_memberList[GetIndexFromType(Type)].m_sMasterName = sMasterName;
	RefreshCombobox();
	InitializeClanInfoWnd();
}

function AskJoin()
{
	local UserInfo User;

	if( GetTargetInfo(User) )
	{
		if( User.nID > 0 )
		{
			ShowWindow("InviteClanPopWnd");
		}
	}
}

function HandleClanMyAuth(string a_Param)
{
	ParseInt(a_Param, "ClanMaster", m_bClanMaster);
	ParseInt(a_Param, "Join", m_bJoin);
	ParseInt(a_Param, "NickName", m_bNickName);
	ParseInt(a_Param, "ClanCrest", m_bCrest);
	ParseInt(a_Param, "War", m_bWar);
	ParseInt(a_Param, "Grade", m_bGrade);
	ParseInt(a_Param, "ManageMaster", m_bManageMaster);
	ParseInt(a_Param, "OustMember", m_bOustMember);
	resetBtnShowHide();
	HandleCrestChange();
}

function ResetOpeningVariables()
{
	m_currentactivestatus1 = False;
	m_currentactivestatus2 = False;
	m_currentactivestatus3 = False;
	m_currentactivestatus4 = False;
	m_currentactivestatus5 = False;
	m_currentactivestatus6 = False;
	m_currentactivestatus7 = False;
	m_currentactivestatus8 = False;
}

function int GetIndexFromType(int Type)
{
	switch(Type)
	{
		case 0:
			return 0;
			break;
            
		case 100:
			return 1;
			break;
            
		case 200:
			return 2;
			break;
            
		case 1001:
			return 3;
			break;
            
		case 1002:
			return 4;
			break;
            
		case 2001:
			return 5;
			break;
            
		case 2002:
			return 6;
			break;
            
		case -1:
			return 7;
			break;
            
		default:
			break;
	}
}

function int GetClanTypeFromIndex(int Index)
{
	switch(Index)
	{
		case 0:
			return 0;
			break;
            
		case 1:
			return 100;
			break;
            
		case 2:
			return 200;
			break;
            
		case 3:
			return 1001;
			break;
            
		case 4:
			return 1002;
			break;
            
		case 5:
			return 2001;
			break;
            
		case 6:
			return 2002;
			break;
            
		case 7:
			return -1;
			break;
            
		default:
			break;
	}
}

function string GetClanTypeNameFromIndex(int Index)
{
	switch(Index)
	{
		case 0:
			return GetSystemString(1399);
			break;
            
		case 100:
			return GetSystemString(1400);
			break;
            
		case 200:
			return GetSystemString(1401);
			break;
            
		case 1001:
			return GetSystemString(1402);
			break;
            
		case 1002:
			return GetSystemString(1403);
			break;
            
		case 2001:
			return GetSystemString(1404);
			break;
            
		case 2002:
			return GetSystemString(1405);
			break;
            
		case -1:
			return GetSystemString(1452);
			break;
            
		default:
			break;
	}
}

function HandleSkillList(string a_Param)
{
	local int Count, i, Id, Level;

	ParseInt(a_Param, "Count", Count);
	Class'UIAPI_ITEMWINDOW'.static.Clear("ClanWnd.ClanSkillWnd");
	i = 0;
J0x43:
	if( i < Count )
	{
		ParseInt(a_Param, "SkillID"$string(i), Id);
		ParseInt(a_Param, "SkillLevel"$string(i), Level);
		AddSkill(Id, Level);
		++i;
		goto J0x43;
	}
}

function HandleSkillListAdd(string a_Param)
{
	local int Id, Level, i, Count;
	local ItemInfo Info;

	ParseInt(a_Param, "SkillID", Id);
	ParseInt(a_Param, "SkillLevel", Level);
	Count = Class'UIAPI_ITEMWINDOW'.static.GetItemNum("ClanWnd.ClanSkillWnd");
	i = 0;
J0x67:
	if( i < Count )
	{
		Class'UIAPI_ITEMWINDOW'.static.GetItem("ClanWnd.ClanSkillWnd", i, Info);
		if( Info.ClassID == Id )
		{
			goto J0xC6;
		}
		++i;
		goto J0x67;
	}
J0xC6:
	if( i < Count )
	{
		ReplaceSkill(i, Id, Level);        
	}
	else
	{
		AddSkill(Id, Level);
	}
}

function AddSkill(int Id, int Level)
{
	local ItemInfo Info;

	Info.ClassID = Id;
	Info.Level = Level;
	Info.Name = Class'UIDATA_SKILL'.static.GetName(Info.ClassID, Info.Level);
	Info.IconName = Class'UIDATA_SKILL'.static.GetIconName(Info.ClassID, Info.Level);
	Info.Description = Class'UIDATA_SKILL'.static.GetDescription(Info.ClassID, Info.Level);
	Info.AdditionalName = Class'UIDATA_SKILL'.static.GetEnchantName(Info.ClassID, Info.Level);
	Class'UIAPI_ITEMWINDOW'.static.AddItem("ClanWnd.ClanSkillWnd", Info);
}

function ReplaceSkill(int Index, int Id, int Level)
{
	local ItemInfo Info;

	Info.ClassID = Id;
	Info.Level = Level;
	Info.Name = Class'UIDATA_SKILL'.static.GetName(Info.ClassID, Info.Level);
	Info.IconName = Class'UIDATA_SKILL'.static.GetIconName(Info.ClassID, Info.Level);
	Info.Description = Class'UIDATA_SKILL'.static.GetDescription(Info.ClassID, Info.Level);
	Info.AdditionalName = Class'UIDATA_SKILL'.static.GetEnchantName(Info.ClassID, Info.Level);
	Class'UIAPI_ITEMWINDOW'.static.SetItem("ClanWnd.ClanSkillWnd", Index, Info);
}

function ClearRoyals()
{
	local int i;

	i = 0;
J0x07:
	if( i < 8 )
	{
		zzRoyalIcon[i].HideWindow();
		zzRoyalIcon[i].DisableWindow();
		zzRoyalIcon[i].SetTooltipCustomType(SetTooltip(""));
		++i;
		goto J0x07;
	}
}

function InitializeClanInfoWnd()
{
	local Color Blue, Red, DarkYellow;
	local int i;
	local string ToolTip;
	local int clanType;

	Blue.R = 126;
	Blue.G = 158;
	Blue.B = 245;
	Red.R = 200;
	Red.G = 50;
	Red.B = 80;
	DarkYellow.R = 175;
	DarkYellow.G = 152;
	DarkYellow.B = 120;
	ClearRoyals();
	i = 0;
J0x82:
	if( i < 8 )
	{
		if( zzm_memberList[i].m_sName != "" )
		{
			clanType = GetClanTypeFromIndex(i);
			if( clanType == 0 )
			{
				ToolTip = (((zzm_memberList[i].m_sName$"\\n")$GetSystemString(342))$" : ")$zzm_memberList[i].m_sMasterName;
			}
			if( clanType == -1 )
			{
				ToolTip = zzm_memberList[i].m_sName;
			}
			if( (clanType == 100) || clanType == 200 )
			{
				ToolTip = (((zzm_memberList[i].m_sName$"\\n")$GetSystemString(1438))$" : ")$zzm_memberList[i].m_sMasterName;
			}
			if( (((clanType == 1001) || clanType == 1002) || clanType == 2001) || clanType == 2002 )
			{
				ToolTip = (((zzm_memberList[i].m_sName$"\\n")$GetSystemString(1433))$" : ")$zzm_memberList[i].m_sMasterName;
			}
			if( ToolTip != "" )
			{
				zzRoyalIcon[i].ShowWindow();
				zzRoyalIcon[i].EnableWindow();
				zzRoyalIcon[i].SetTooltipCustomType(SetTooltip(ToolTip));
			}
		}
		++i;
		goto J0x82;
	}
}

function CustomTooltip SetTooltip(string Text)
{
	local CustomTooltip ToolTip;
	local DrawItemInfo Info;

	ToolTip.MinimumWidth = 144;
	ToolTip.DrawList.Length = 1;
	Info.eType = DIT_TEXT;
	Info.t_color.R = 178;
	Info.t_color.G = 190;
	Info.t_color.B = 207;
	Info.t_color.A = byte(255);
	Info.t_strText = Text;
	ToolTip.DrawList[0] = Info;
	return ToolTip;
}

function HandleCrestChange()
{
	if( Class'UIDATA_CLAN'.static.GetCrestTexture(m_clanID, Tex_ClanCrest) )
	{
		clancrest.SetTextureWithObject(Tex_ClanCrest);        
	}
	else
	{
		clancrest.SetTexture("L2UI_CH3.null");
	}
	if( Class'UIDATA_CLAN'.static.GetAllianceCrestTexture(m_clanID, Tex_AllyCrest) )
	{
		allycrest.SetTextureWithObject(Tex_AllyCrest);        
	}
	else
	{
		allycrest.SetTexture("L2UI_CH3.null");
	}
}


// Decompiled with UE Explorer.
defaultproperties
{
    m_WindowName="ClanWnd"
}
