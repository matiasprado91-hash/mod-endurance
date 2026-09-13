/******************************************************************************
//                                                ????/???????? ???? ???? UI ????????                                                       //
******************************************************************************/

class DuelManager extends UICommonAPI;

CONST DIALOG_ASK_START = 1111;

CONST MAX_PARTY_NUM = 9;

const NDUELSTATUS_HEIGHT = 46;	//???? ???????? ????????.

var int					m_memberInfo[MAX_PARTY_NUM];		// ?? ???? ???? ???????? ???? ?????????? ???? ID?? ?????? ????. 0???? ???????? ???? ???? ??.

// ?????? ????
var WindowHandle		m_TopWnd;
var WindowHandle		m_StatusWnd[MAX_PARTY_NUM];
var NameCtrlHandle		m_PlayerName[MAX_PARTY_NUM];
var TextureHandle		m_ClassIcon[MAX_PARTY_NUM];
var BarHandle			m_BarCP[MAX_PARTY_NUM];
var BarHandle			m_BarHP[MAX_PARTY_NUM];
var BarHandle			m_BarMP[MAX_PARTY_NUM];

var bool				m_bDuelState;

// ?????? ?????? ???????? ????
function OnLoad()
{
	local int idx;
	
	// ?????? (???? ???? ?????????????? ????) ???? ????.
	registerEvent(EV_DuelAskStart);
	registerEvent(EV_DuelReady);
	registerEvent(EV_DuelStart);
	registerEvent(EV_DuelEnd);
	registerEvent(EV_DuelUpdateUserInfo);
	registerEvent(EV_DuelEnemyRelation);
	registerEvent(EV_DialogOK);
	registerEvent(EV_DialogCancel);

	//Init Handle ???? ?????? ???? ??????.
	m_TopWnd = GetHandle("DuelManager");
	
	for (idx=0; idx<MAX_PARTY_NUM; idx++)
	{
		m_StatusWnd[idx] = GetHandle("DuelManager.PartyStatusWnd" $ idx);
		m_PlayerName[idx] = NameCtrlHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".PlayerName" ) ); 
		m_ClassIcon[idx] = TextureHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".ClassIcon" ) );
		m_BarCP[idx] = BarHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barCP" ) );
		m_BarHP[idx] = BarHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barHP" ) );
		m_BarMP[idx] = BarHandle( GetHandle( "DuelManager.PartyStatusWnd" $ idx $ ".barMP" ) );
	}

	Clear();
	m_bDuelState = false;
}

//?????? ???? ????
function OnEvent(int EventID, string param)
{
	local Color white;
	white.R = 255;
	white.G = 255;
	white.B = 255;

	//debug( "DuelManager event " $ EventID $ ", param " $ param );
	switch( EventID )
	{
	case EV_DuelAskStart:
		//debug("DuelAskStart");
		HandleDuelAskStart(param);
		break;
	case EV_DuelReady:
		//debug("DuelReady");
		m_bDuelState = true;
		break;
	case EV_DuelStart:
		//debug("DuelStart");
		break;
	case EV_DuelEnd:
		//debug("DuelEnd");
		m_bDuelState = false;
		Clear();
		m_TopWnd.HideWindow();
		break;
	case EV_DuelUpdateUserInfo:
		HandleUpdateUserInfo( param );
		break;
	case EV_DuelEnemyRelation:
		break;
	case EV_DialogOK:
		HandleDialogOK();
		break;
	case EV_DialogCancel:
		//debug("rejected");
		HandleDialogCancel();
		break;
	default:
		break;
	};
}

//?????? ???? 
function HandleDuelAskStart( string param )
{
	local string	sName;
	local int		type, messageNum;
	local bool bOption;

	bOption = GetOptionBool( "Game", "IsRejectingDuel" );
	
	ParseString( param, "userName", sName );
	ParseInt( param, "type", type );

	if (bOption == true)
	{
		RequestDuelAnswerStart( type, int(bOption), 0 );
	}
	else	
	{
		// ???????????? ???????? ????????, ????????.
		if( type == 0 )			// ???? ????
			messageNum = 1938;
		else if( type == 1 )		// ???? ????
			messageNum = 1939;
	
		DialogSetReservedInt( type );
		DialogSetParamInt( 10*1000 );	
		DialogSetID(DIALOG_ASK_START);
		DialogShow( DIALOG_Progress, MakeFullSystemMsg( GetSystemMessage(messageNum), sName ) );
	}
}

function HandleDialogOK()
{
	local int dialogID;
	local bool bOption;
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if( dialogID == DIALOG_ASK_START )
		{
			bOption = GetOptionBool( "Game", "IsRejectingDuel" );
			RequestDuelAnswerStart( DialogGetReservedInt(), int(bOption), 1 );
		}
	}
}

function HandleDialogCancel()
{
	local int dialogID;
	local bool bOption;
	if(DialogIsMine())
	{
		dialogID = DialogGetID();
		if( dialogID == DIALOG_ASK_START )
		{
			bOption = GetOptionBool( "Game", "IsRejectingDuel" );
			RequestDuelAnswerStart( DialogGetReservedInt(), int(bOption), 0 );
		}
	}
}



function HandleUpdateUserInfo( string param )
{
	local string sName;
	local int ID, classID, level, currentHP, maxHP, currentMP, maxMP, currentCP, maxCP;
	local int i;
	local bool bFound;

	if( !m_bDuelState )
		return;

	ParseString( param, "userName", sName );
	ParseInt( param, "ID", ID );
	ParseInt( param, "class", classID );
	ParseInt( param, "level", level );
	ParseInt( param, "currentHP", currentHP );
	ParseInt( param, "maxHP", maxHP );
	ParseInt( param, "currentMP", currentMP );
	ParseInt( param, "maxMP", maxMP );
	ParseInt( param, "currentCP", currentCP );
	ParseInt( param, "maxCP", maxCP );

	// ?????? ID ?? ???????? ????????.
	bFound = false;
	for( i=0; i < MAX_PARTY_NUM ; ++i )
	{
		if( m_memberInfo[i] != 0  )
		{
			if( ID == m_memberInfo[i] )
			{
				bFound = true;
				break;
			}
		}
		else 
		{
			break;
		}
	}

	// i ?? ?????? ???????? ?? ???????? ????????.( i?? MAX_PARTY_NUM ???? ??????????. ?????? ????;;; )
	if( !bFound )			// ?????? ????????
	{
		//debug( "match not found(i:" $ i );
		m_memberInfo[i] = ID;
		m_StatusWnd[i].ShowWindow();
		Resize(i+1);
	}

	m_TopWnd.ShowWindow();

	//Name
	m_PlayerName[i].SetName(sName, NCT_Normal,TA_Center);

	//???? ??????
	m_ClassIcon[i].SetTexture(GetClassIconName(classID));
	m_ClassIcon[i].SetTooltipCustomType(xxMakeTooltipSimpleText(GetClassStr(classID) $ " - " $ GetClassType(classID)));

	m_BarCP[i].SetValue( maxCP, currentCP );
	m_BarHP[i].SetValue( maxHP, currentHP );
	m_BarMP[i].SetValue( maxMP, currentMP );
}

//??????
function Clear()
{
	local int i;

	for( i=0 ; i < MAX_PARTY_NUM ; ++i )
	{
		m_StatusWnd[i].HideWindow();
		m_memberInfo[i] = 0;
	}
}

// ???? ?????? ???? ???? ?????? ?????? frame ???? ???????? ????????( count?? ???? ?????? )
function Resize( int count )
{
	local Rect entireRect, statusWndRect;
	entireRect = m_TopWnd.GetRect();
	statusWndRect = m_StatusWnd[0].GetRect();

	m_TopWnd.SetWindowSize( entireRect.nWidth, statusWndRect.nHeight*count );
	m_TopWnd.SetResizeFrameSize( 10, statusWndRect.nHeight*count );
}

//?????? ???????????? ??????
function OnLButtonDown( WindowHandle a_WindowHandle, int X, int Y )
{
	local Rect rectWnd;
	local int idx;
	
	rectWnd = m_TopWnd.GetRect();
	
	if (X > rectWnd.nX + 13 )
	{
		//debug ("abcde" $ X $ rectWnd.nX $idx);
		idx = (Y-rectWnd.nY) / NDUELSTATUS_HEIGHT;
		RequestTargetUser(m_memberInfo[idx]);
	}
}
defaultproperties
{
}
