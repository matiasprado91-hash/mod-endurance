class TargetStatusWnd extends UICommonAPI;

const CONTRACT_HEIGHT = 58;
const EXPAND_HEIGHT = 102;

var bool m_bExpand;
var WindowHandle Me;
var WindowHandle TargetHeader;
var ButtonHandle btnExpand;
var ButtonHandle btnContract;
var int m_TargetLevel;
var int m_targetID;
var bool m_bShow;

var int i_LastCurHP;
var int i_LastMaxHP;
var int i_LastCurCP;
var int i_LastMaxCP;
var bool zzshowHeader;
var Pawn TargetPawn;
var class<Emitter> zztargetEmitterClass;
var Emitter zzdecalEmitter;
var bool DragState;
var Rect GlobalClick;

function OnLoad()
{
    RegisterEvent(980);
    RegisterEvent(990);
    RegisterEvent(230);
    RegisterEvent(190);
    RegisterEvent(210);
    RegisterEvent(240);
    RegisterEvent(200);
    RegisterEvent(220);
    RegisterEvent(300);
    Me = GetHandle("TargetStatusWnd");
    TargetHeader = GetHandle("TargetHeader");
    btnExpand = ButtonHandle(GetHandle("TargetStatusWnd.btnExpand"));
    btnContract = ButtonHandle(GetHandle("TargetStatusWnd.btnContract"));
    m_bShow = false;
    m_targetID = -1;
   
    zztargetEmitterClass = class < Emitter > (DynamicLoadObject("OMGzOMGEffect.target_region_decal", class'Class'));
    return;
}

function OnShow()
{
    m_bShow = true;
    return;
}

function OnHide()
{
    m_bShow = false;
    xxRemoveHPHeader();
xxApplyEffectTarget(true);
    TargetPawn = none;
    return;
}

function OnExitState(name a_PreStateName)
{
    xxRemoveHPHeader();
    TargetPawn = none;
    return;
}

function OnEvent(int Event_ID, string param)
{
    switch(Event_ID)
    {
        // End:0x18
        case 980:
            xxHandleTargetUpdate();
            // End:0xAA
            break;
        // End:0x65
        // End:0x7B
        case 300:
            HandleReceiveTargetLevelDiff(param);
            // End:0xAA
            break;
        // End:0x80
        case 230:
        // End:0x85
        case 190:
        // End:0x8A
        case 210:
        // End:0x8F
        case 240:
        // End:0x94
        case 200:
        // End:0xA7
        case 220:
            HandleTargetStatusUpdate(param);
            // End:0xAA
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnClickButton(string strID)
{
    switch(strID)
    {
        // End:0x1D
        case "btnClose":
            OnCloseButton();
            // End:0x52
            break;
        // End:0x35
        case "btnExpand":
            SetExpandMode(false);
            // End:0x52
            break;
        // End:0x4F
        case "btnContract":
            SetExpandMode(true);
            // End:0x52
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLButtonDown(WindowHandle a_WindowHandle, int X, int Y)
{
    local Rect rectWnd;

    rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("TargetStatusWnd");
    // End:0x59
 /*   if(script_ContextMenuWnd.Me.IsShowWindow())
    {
        script_ContextMenuWnd.Me.HideWindow();
    }*/
    // End:0xF8
    if(((X >= (rectWnd.nX + 30)) && X <= ((rectWnd.nX + rectWnd.nWidth) - 30)) && Y <= (rectWnd.nY + 25))
    {
        GlobalClick.nX = X - rectWnd.nX;
        GlobalClick.nY = Y - rectWnd.nY;
        GotoState('DragON');
        DragState = true;
    }
    return;
}

function OnDefaultPosition()
{
    GotoState('None');
    DragState = false;
    return;
}

function OnRButtonDown(int X, int Y)
{
    local Rect rectWnd;
    local UserInfo Info;
    local int PlayerID, contextX, contextY;

    rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("TargetStatusWnd");
    // End:0x17F
    if((X >= rectWnd.nX) && X <= ((rectWnd.nX + rectWnd.nWidth) - 10))
    {
        GetUserInfo(m_targetID, Info);
        PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
        // End:0x17F
        if((((m_targetID > 0) && PlayerID != m_targetID) && !Info.bNpc) && !Info.bPet)
        {
            contextX = (X - rectWnd.nX) - 30;
            contextY = (Y - rectWnd.nY) - 40;
            // End:0x10D
            if(contextY < 0)
            {
                contextY = 0;
            }
          //  script_ContextMenuWnd.Me.ShowWindow();
          //  script_ContextMenuWnd.Me.SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", contextX, contextY);
         //   script_ContextMenuWnd.contextTypeSelect(1, m_targetID);
        }
    }
    return;
}

function OnCloseButton()
{
    RequestTargetCancel();
    PlayConsoleSound(EInterfaceSoundType(6));
    return;
}

function SetExpandMode(bool bExpand)
{
    local int nWndWidth, nWndHeight;
    local UserInfo Info;

    GetTargetInfo(Info);
    Me.GetWindowSize(nWndWidth, nWndHeight);
    m_bExpand = bExpand;
    m_targetID = -1;
    xxHandleTargetUpdate();
    // End:0x82
    if(bExpand)
    {
        btnExpand.ShowWindow();
        btnContract.HideWindow();
        Me.SetWindowSize(nWndWidth, 102);        
    }
    else
    {
        btnExpand.HideWindow();
        btnContract.ShowWindow();
        Me.SetWindowSize(nWndWidth, 58);
    }
    return;
}

function HandleTargetStatusUpdate(string param)
{
    local int ServerID;

    // End:0x38
    if(m_bShow)
    {
        ParseInt(param, "ServerID", ServerID);
        // End:0x38
        if(m_targetID == ServerID)
        {
            xxHandleTargetUpdate();
        }
    }
    return;
}

function HandleReceiveTargetLevelDiff(string param)
{
    ParseInt(param, "LevelDiff", m_TargetLevel);
    xxHandleTargetUpdate();
    return;
}

function xxHandleTargetUpdate()
{
    local Rect rectWnd;
    local string strTmp;
    local int targetID, PlayerID, PetID, clanType, ClanNameValue;

    local bool bIsServerObject, bIsHPShowableNPC;
    local string Name;
    local Color TargetNameColor;
    local int ServerObjectNameID;
    local UIEventManager.EServerObjectType ServerObjectType;
    local bool bShowCPBar, bShowHPBar, bShowMPBar, bShowPledgeInfo, bShowPledgeTex, bShowPledgeAllianceTex;

    local string PledgeName, PledgeAllianceName;
    local Texture PledgeCrestTexture, PledgeAllianceCrestTexture;
    local Color PledgeNameColor, PledgeAllianceNameColor;
    local bool bShowNpcInfo;
    local array<int> arrNpcInfo;
    local bool IsTargetChanged;
    local UserInfo Info, myInfo;
    local Color WhiteColor;

    WhiteColor.R = 0;
    WhiteColor.G = 0;
    WhiteColor.B = 0;
    targetID = Class'NWindow.UIDATA_TARGET'.static.GetTargetID();
    // End:0x69
    if(targetID < 1)
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd");
        return;
    }
    // End:0x80
    if(m_targetID != targetID)
    {
        IsTargetChanged = true;
    }
    m_targetID = targetID;
    GetTargetInfo(Info);
    GetPlayerInfo(myInfo);
    // End:0xCE
    if(IsTargetChanged && Info.nID > 0)
    {
xxApplyEffectTarget(false, Info);
        xxRemoveHPHeader();
    }
    rectWnd = Class'NWindow.UIAPI_WINDOW'.static.GetRect("TargetStatusWnd");
    PledgeName = GetSystemString(431);
    PledgeAllianceName = GetSystemString(591);
    PledgeNameColor.R = 128;
    PledgeNameColor.G = 128;
    PledgeNameColor.B = 128;
    PledgeAllianceNameColor.R = 128;
    PledgeAllianceNameColor.G = 128;
    PledgeAllianceNameColor.B = 128;
    TargetNameColor = Class'NWindow.UIDATA_TARGET'.static.GetTargetNameColor(m_TargetLevel);
    bIsServerObject = Class'NWindow.UIDATA_TARGET'.static.IsServerObject();
    // End:0x288
    if(bIsServerObject)
    {
        ServerObjectNameID = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectNameID(m_targetID);
        // End:0x1DC
        if(ServerObjectNameID > 0)
        {
            Name = Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectName(ServerObjectNameID);
        }
        Class'NWindow.UIAPI_NAMECTRL'.static.SetName("TargetStatusWnd.UserName", Name, NCT_Normal,TA_Center);
        ServerObjectType = Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectType(m_targetID);
        // End:0x285
        if(int(ServerObjectType) == 2)
        {
            // End:0x285
            if(Class'NWindow.UIDATA_STATICOBJECT'.static.GetStaticObjectShowHP(m_targetID))
            {
                bShowHPBar = true;
                UpdateHPBar(Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectHP(m_targetID), Class'NWindow.UIDATA_STATICOBJECT'.static.GetServerObjectMaxHP(m_targetID));
            }
        }        
    }
    else
    {
        // End:0x2E9
        if(Len(Info.Name) < 1)
        {
            Name = Class'NWindow.UIDATA_PARTY'.static.GetMemberName(m_targetID);
            Class'NWindow.UIAPI_NAMECTRL'.static.SetName("TargetStatusWnd.UserName", Name, NCT_Normal,TA_Center);            
        }
        else
        {
            PlayerID = Class'NWindow.UIDATA_PLAYER'.static.GetPlayerID();
            PetID = Class'NWindow.UIDATA_PET'.static.GetPetID();
            bIsHPShowableNPC = Class'NWindow.UIDATA_TARGET'.static.IsHPShowableNPC();
            // End:0x536
            if(((((Info.bNpc && !Info.bPet) && Info.bCanBeAttacked) || (PlayerID > 0) && m_targetID == PlayerID) || (Info.bNpc && Info.bPet) && m_targetID == PetID) || Info.bNpc && bIsHPShowableNPC)
            {
                // End:0x458
                if(IsAllWhiteID(Info.nClassID))
                {
                    Name = Info.Name;
                    Class'NWindow.UIAPI_NAMECTRL'.static.SetName("TargetStatusWnd.UserName", Name, NCT_Normal,TA_Center);
                    // End:0x455
                    if(!IsNoBarID(Info.nClassID))
                    {
                        bShowHPBar = true;
                        UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                        AddHPHeader();
                    }                    
                }
                else
                {
                    Name = Info.Name;
                    Class'NWindow.UIAPI_NAMECTRL'.static.SetNameWithColor("TargetStatusWnd.UserName", Name, NCT_Normal,TA_Center, TargetNameColor);
                    bShowHPBar = true;
                    UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                    AddHPHeader();
                    // End:0x51B
                    if(!(Info.bNpc && !Info.bPet) && Info.bCanBeAttacked)
                    {
                        bShowMPBar = true;
                        UpdateMPBar(Info.nCurMP, Info.nMaxMP);
                    }
                    // End:0x533
                    if(Info.nMaxMP < 1)
                    {
                        bShowMPBar = false;
                    }
                }                
            }
            else
            {
                Name = Info.Name;
                // End:0x5A0
                if(!Info.bNpc)
                {
                    bShowCPBar = true;
                    bShowHPBar = true;
                    AddHPHeader();
                    UpdateCPBar(Info.nCurCP, Info.nMaxCP);
                    UpdateHPBar(Info.nCurHP, Info.nMaxHP);
                }
                Class'NWindow.UIAPI_NAMECTRL'.static.SetName("TargetStatusWnd.UserName", Name, NCT_Normal,TA_Center);
            }
            // End:0x8AE
            if(m_bExpand)
            {
                // End:0x629
                if(Info.bNpc)
                {
                    // End:0x626
                    if(Class'NWindow.UIDATA_NPC'.static.GetNpcProperty(Info.nClassID, arrNpcInfo))
                    {
                        bShowNpcInfo = true;
                        // End:0x626
                        if(IsTargetChanged)
                        {
                            UpdateNpcInfoTree(arrNpcInfo);
                        }
                    }                    
                }
                else
                {
                    bShowPledgeInfo = true;
                    // End:0x8AE
                    if(Info.nClanID > 0)
                    {
                        PledgeName = Class'NWindow.UIDATA_CLAN'.static.GetName(Info.nClanID);
                        PledgeNameColor.R = 176;
                        PledgeNameColor.G = 152;
                        PledgeNameColor.B = 121;
                        // End:0x778
                        if(((PledgeName != "") && Class'NWindow.UIDATA_USER'.static.GetClanType(m_targetID, clanType)) && Class'NWindow.UIDATA_CLAN'.static.GetNameValue(Info.nClanID, ClanNameValue))
                        {
                            // End:0x70D
                            if(clanType == -1)
                            {
                                PledgeNameColor.R = 209;
                                PledgeNameColor.G = 167;
                                PledgeNameColor.B = 2;                                
                            }
                            else
                            {
                                // End:0x744
                                if(ClanNameValue > 0)
                                {
                                    PledgeNameColor.R = 0;
                                    PledgeNameColor.G = 130;
                                    PledgeNameColor.B = byte(255);                                    
                                }
                                else
                                {
                                    // End:0x778
                                    if(ClanNameValue < 0)
                                    {
                                        PledgeNameColor.R = byte(255);
                                        PledgeNameColor.G = 0;
                                        PledgeNameColor.B = 0;
                                    }
                                }
                            }
                        }
                        // End:0x7D8
                        if(Class'NWindow.UIDATA_CLAN'.static.GetCrestTexture(Info.nClanID, PledgeCrestTexture))
                        {
                            bShowPledgeTex = true;
                            Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTextureWithObject("TargetStatusWnd.texPledgeCrest", PledgeCrestTexture);                            
                        }
                        else
                        {
                            bShowPledgeTex = false;
                        }
                        strTmp = Class'NWindow.UIDATA_CLAN'.static.GetAllianceName(Info.nClanID);
                        // End:0x8AE
                        if(Len(strTmp) > 0)
                        {
                            PledgeAllianceName = strTmp;
                            PledgeAllianceNameColor.R = 176;
                            PledgeAllianceNameColor.G = 155;
                            PledgeAllianceNameColor.B = 121;
                            // End:0x8A6
                            if(Class'NWindow.UIDATA_CLAN'.static.GetAllianceCrestTexture(Info.nClanID, PledgeAllianceCrestTexture))
                            {
                                bShowPledgeAllianceTex = true;
                                Class'NWindow.UIAPI_TEXTURECTRL'.static.SetTextureWithObject("TargetStatusWnd.texPledgeAllianceCrest", PledgeAllianceCrestTexture);                                
                            }
                            else
                            {
                                bShowPledgeAllianceTex = false;
                            }
                        }
                    }
                }
            }
        }
    }
    // End:0x8FF
    if(!Class'NWindow.UIAPI_WINDOW'.static.IsShowWindow("TargetStatusWnd"))
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd");
        SetExpandMode(m_bExpand);
    }
    HandleStatusBar(bShowCPBar, "CP");
    HandleStatusBar(bShowHPBar, "HP");
    HandleStatusBar(bShowMPBar, "MP");
    HandleBarPos(bShowCPBar);
    // End:0xCF9
    if(bShowPledgeInfo)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.txtPledge");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.txtAlliance");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.txtPledgeName");
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.txtPledgeAllianceName");
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TargetStatusWnd.txtPledgeName", PledgeName);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetText("TargetStatusWnd.txtPledgeAllianceName", PledgeAllianceName);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("TargetStatusWnd.txtPledgeName", PledgeNameColor);
        Class'NWindow.UIAPI_TEXTBOX'.static.SetTextColor("TargetStatusWnd.txtPledgeAllianceName", PledgeAllianceNameColor);
        // End:0xB5F
        if(bShowPledgeTex)
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.texPledgeCrest");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("TargetStatusWnd.txtPledgeName", rectWnd.nX + 63, rectWnd.nY + 64);            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.texPledgeCrest");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("TargetStatusWnd.txtPledgeName", rectWnd.nX + 45, rectWnd.nY + 64);
        }
        // End:0xC6D
        if(bShowPledgeAllianceTex)
        {
            Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.texPledgeAllianceCrest");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("TargetStatusWnd.txtPledgeAllianceName", rectWnd.nX + 63, rectWnd.nY + 78);            
        }
        else
        {
            Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.texPledgeAllianceCrest");
            Class'NWindow.UIAPI_WINDOW'.static.MoveTo("TargetStatusWnd.txtPledgeAllianceName", rectWnd.nX + 45, rectWnd.nY + 78);
        }        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.txtPledge");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.texPledgeCrest");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.txtPledgeName");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.txtAlliance");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.texPledgeAllianceCrest");
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.txtPledgeAllianceName");
    }
    // End:0xE76
    if(bShowNpcInfo)
    {
        Class'NWindow.UIAPI_WINDOW'.static.ShowWindow("TargetStatusWnd.NpcInfo");
        Class'NWindow.UIAPI_TREECTRL'.static.ShowScrollBar("TargetStatusWnd.NpcInfo", false);        
    }
    else
    {
        Class'NWindow.UIAPI_WINDOW'.static.HideWindow("TargetStatusWnd.NpcInfo");
    }
    return;
}

function HandleBarPos(bool isCpBar)
{
    // End:0xAA
    if(!isCpBar)
    {
        GetHandle("TargetStatusWnd.barHP").SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 13, 27);
        GetHandle("TargetStatusWnd.HP_BG").SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 11, 27);        
    }
    else
    {
        GetHandle("TargetStatusWnd.barHP").SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 13, 40);
        GetHandle("TargetStatusWnd.HP_BG").SetAnchor("TargetStatusWnd", "TopLeft", "TopLeft", 11, 40);
    }
    return;
}

function HandleStatusBar(bool Show, string wnd)
{
    // End:0x54
    if(Show)
    {
        ShowWindow("TargetStatusWnd.bar" $ wnd);
        ShowWindow(("TargetStatusWnd." $ wnd) $ "_BG");        
    }
    else
    {
        HideWindow("TargetStatusWnd.bar" $ wnd);
        HideWindow(("TargetStatusWnd." $ wnd) $ "_BG");
    }
    return;
}

function HandleUpdateCPHPMP(string param)
{
    local int ServerID, currentCP, maxCP, currentHP, MaxHP, currentMP,
	    MaxMP;

    // End:0x152
    if(m_bShow)
    {
        ParseInt(param, "ServerID", ServerID);
        // End:0x152
        if(m_targetID == ServerID)
        {
            // End:0x64
            if(ParseInt(param, "CurrentCP", currentCP))
            {
                UpdateBar("CP", currentCP, -1);
            }
            // End:0x92
            if(ParseInt(param, "MaxCP", maxCP))
            {
                UpdateBar("CP", -1, maxCP);
            }
            // End:0xC4
            if(ParseInt(param, "CurrentHP", currentHP))
            {
                UpdateBar("HP", currentHP, -1);
            }
            // End:0xF2
            if(ParseInt(param, "MaxHP", MaxHP))
            {
                UpdateBar("HP", -1, MaxHP);
            }
            // End:0x124
            if(ParseInt(param, "CurrentMP", currentMP))
            {
                UpdateBar("MP", currentMP, -1);
            }
            // End:0x152
            if(ParseInt(param, "MaxMP", MaxMP))
            {
                UpdateBar("MP", -1, MaxMP);
            }
        }
    }
    return;
}

function UpdateBar(string Str, int Current, int Max)
{
    local int tmpCur, tmpMax;

    Class'NWindow.UIAPI_BARCTRL'.static.GetValue("TargetStatusWnd.bar" $ Str, tmpMax, tmpCur);
    // End:0x78
    if(Current >= 0)
    {
        Class'NWindow.UIAPI_BARCTRL'.static.SetValue("TargetStatusWnd.bar" $ Str, tmpMax, Current);        
    }
    else
    {
        Class'NWindow.UIAPI_BARCTRL'.static.SetValue("TargetStatusWnd.bar" $ Str, Max, tmpCur);
    }
    return;
}

function UpdateCPBar(int CP, int maxCP)
{
    // End:0x1A
    if((CP < 0) || maxCP <= 0)
    {
        return;
    }
    Class'NWindow.UIAPI_BARCTRL'.static.SetValue("TargetStatusWnd.barCP", maxCP, CP);
    return;
}

function UpdateHPBar(int HP, int MaxHP)
{
    // End:0x1A
    if((HP < 0) || MaxHP <= 0)
    {
        return;
    }
    Class'NWindow.UIAPI_BARCTRL'.static.SetValue("TargetStatusWnd.barHP", MaxHP, HP);
    
headerseta(MaxHP, HP);
    return;
}

function UpdateMPBar(int MP, int MaxMP)
{
    // End:0x1A
    if((MP < 0) || MaxMP <= 0)
    {
        return;
    }
    Class'NWindow.UIAPI_BARCTRL'.static.SetValue("TargetStatusWnd.barMP", MaxMP, MP);
    return;
}

function headerseta(int zzMaxHp, int zzHp)
{
	local int zzNewSize;

	zzNewSize = 76;
    // End:0x30
	if ( zzHP < zzMaxHP )
	{
		zzNewSize = (zzHP * 76) / zzMaxHP;
	}
	GetHandle("TargetHeader.barHP").SetWindowSize(zzNewSize, 4);
	return;
}

function UpdateNpcInfoTree(array<int> arrNpcInfo)
{
    local int i, SkillID, SkillLevel;
    local string strNodeName;
    local XMLTreeNodeInfo infNode;
    local XMLTreeNodeItemInfo infNodeItem;
    local XMLTreeNodeInfo infNodeClear;
    local XMLTreeNodeItemInfo infNodeItemClear;

    Class'NWindow.UIAPI_TREECTRL'.static.Clear("TargetStatusWnd.NpcInfo");
    infNode.strName = "root";
    strNodeName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("TargetStatusWnd.NpcInfo", "", infNode);
    // End:0xB6
    if(Len(strNodeName) < 1)
    {
        Debug("ERROR: Can't insert root node. Name: " $ infNode.strName);
        return;
    }
    i = 0;
    J0xBD:

    // End:0x2FA [Loop If]
    if(i < arrNpcInfo.Length)
    {
        SkillID = arrNpcInfo[i];
        SkillLevel = arrNpcInfo[i + 1];
        infNode = infNodeClear;
        infNode.nOffSetX = int(float(i / 2) % float(8)) * 18;
        // End:0x162
        if((float(i / 2) % float(8)) == float(0))
        {
            // End:0x153
            if(i > 0)
            {
                infNode.nOffSetY = 3;                
            }
            else
            {
                infNode.nOffSetY = 0;
            }            
        }
        else
        {
            infNode.nOffSetY = -15;
        }
        infNode.strName = "" $ string(i / 2);
        infNode.bShowButton = 0;
        infNode.ToolTip = SetNpcInfoTooltip(SkillID, SkillLevel);
        strNodeName = Class'NWindow.UIAPI_TREECTRL'.static.InsertNode("TargetStatusWnd.NpcInfo", "root", infNode);
        // End:0x22B
        if(Len(strNodeName) < 1)
        {
            Log("ERROR: Can't insert node. Name: " $ infNode.strName);
            return;
        }
        infNode.ToolTip.DrawList.Remove(0, infNode.ToolTip.DrawList.Length);
        infNodeItem = infNodeItemClear;
        infNodeItem.eType = XTNITEM_TEXTURE;
        infNodeItem.u_nTextureWidth = 15;
        infNodeItem.u_nTextureHeight = 15;
        infNodeItem.u_nTextureUWidth = 32;
        infNodeItem.u_nTextureUHeight = 32;
        infNodeItem.u_strTexture = Class'NWindow.UIDATA_SKILL'.static.GetIconName(SkillID, SkillLevel);
        Class'NWindow.UIAPI_TREECTRL'.static.InsertNodeItem("TargetStatusWnd.NpcInfo", strNodeName, infNodeItem);
        i += 2;
        // [Loop Continue]
        goto J0xBD;
    }
    return;
}

function CustomTooltip SetNpcInfoTooltip(int Id, int Level)
{
    local CustomTooltip ToolTip;
    local DrawItemInfo Info, infoClear;
    local ItemInfo item;

    item.Name = Class'NWindow.UIDATA_SKILL'.static.GetName(Id, Level);
    item.Description = Class'NWindow.UIDATA_SKILL'.static.GetDescription(Id, Level);
    ToolTip.DrawList.Length = 1;
    Info = infoClear;
    Info.eType = DIT_TEXT;
    Info.t_bDrawOneLine = true;
    Info.t_strText = item.Name;
    ToolTip.DrawList[0] = Info;
    // End:0x171
    if(Len(item.Description) > 0)
    {
        ToolTip.MinimumWidth = 144;
        ToolTip.DrawList.Length = 2;
        Info = infoClear;
        Info.eType = DIT_TEXT;
        Info.nOffSetY = 6;
        Info.bLineBreak = true;
        Info.t_color.R = 178;
        Info.t_color.G = 190;
        Info.t_color.B = 207;
        Info.t_color.A = byte(255);
        Info.t_strText = item.Description;
        ToolTip.DrawList[1] = Info;
    }
    return ToolTip;

}

function bool IsAllWhiteID(int m_targetID)
{
    local bool bIsAllWhiteName;

    bIsAllWhiteName = false;
    switch(m_targetID)
    {
        // End:0x17
        case 12778:
        // End:0x1F
        case 13031:
        // End:0x27
        case 13032:
        // End:0x2F
        case 13033:
        // End:0x37
        case 13034:
        // End:0x3F
        case 13035:
        // End:0x52
        case 13036:
            bIsAllWhiteName = true;
            // End:0x55
            break;
        // End:0xFFFF
        default:
            break;
    }
    return bIsAllWhiteName;
 
}

function bool IsNoBarID(int m_targetID)
{
    local bool bIsNoBarName;

    bIsNoBarName = false;
    switch(m_targetID)
    {
        // End:0x22
        case 13036:
            bIsNoBarName = true;
            // End:0x25
            break;
        // End:0xFFFF
        default:
            break;
    }
    return bIsNoBarName;

}

function CustomTooltip SetTooltip(string Text)
{
    local CustomTooltip TooltipInfo;

    TooltipInfo.DrawList.Length = 4;
    TooltipInfo.DrawList[0].eType = DIT_TEXT;
    TooltipInfo.DrawList[0].nOffSetX = 1;
    TooltipInfo.DrawList[0].t_bDrawOneLine = true;
    TooltipInfo.DrawList[0].t_color.R = byte(255);
    TooltipInfo.DrawList[0].t_color.G = byte(255);
    TooltipInfo.DrawList[0].t_color.B = byte(255);
    TooltipInfo.DrawList[0].t_color.A = byte(255);
    TooltipInfo.DrawList[0].t_strText = Text;
    return TooltipInfo;

}

function xxApplyEffectTarget(bool isClear, optional UserInfo zzinfo )
{	
	local Actor zztmpActor;
	local Pawn zza_Pawn;
	local Vector zzV;
			
	if ( !GetPlayerActor(zztmpActor) )
	{
		return;
	}

	if ( zzdecalEmitter != None )
	{
		zzdecalEmitter.NDestroy();
		zzdecalEmitter = None;
	}
	if ( isClear )
	{
		return;
	}
		
	zzV = zzinfo.Loc;

	if ( zztmpActor.CreatureID == zzinfo.nID )
	{
		zzV = zztmpActor.Location;
	}

	foreach zztmpActor.CollidingActors(Class'Pawn',zza_Pawn,100.0,zzV)
	{
		
		if ( zza_Pawn.CurRideType != 0 && zza_Pawn.RidePawn != None )
		{
			continue;	// is mount so skip
		}
		if ( zza_Pawn.CreatureID == zzinfo.nID  )
		{
			zzV.X = 0.0;
			zzV.Y = 0.0;
			zzV.Z = zza_Pawn.CollisionHeight + 7;
			
			
			
			
			zzdecalEmitter = zza_Pawn.Spawn(zztargetEmitterClass, zza_Pawn,,zzV,);
		} 
		else 
		{
		}
	}	
}


function AddHPHeader()
{
     // End:0x0D
	if( !zzshowHeader )
	{
		return;
	}
	GotoState('HeaderShow');
	TargetHeader.ShowWindow();
	return;
}

function xxRemoveHPHeader()
{
	GotoState('None');
	TargetHeader.HideWindow();
	return;
}

state HeaderShow
{
	event OnTick()
	{

        // End:0x1D
		if(TargetHeader.IsShowWindow())
		{
			xxcalculateheadershot(TargetHeader);
		}

	}


	stop;
}

state DragON
{
    function OnTick()
    {
        local LineagePlayerController Controller;
        local Rect Rect;
        local int MouseX, MouseY;

        Rect = Me.GetRect();
        // End:0x27
        if(!GetPlayerController(Controller))
        {
            return;
        }
        MouseX = int(Controller.Player.WindowsMouseX);
        MouseY = int(Controller.Player.WindowsMouseY);
        Me.MoveTo(MouseX - GlobalClick.nX, MouseY - GlobalClick.nY);
        // End:0xB2
        if(!IsKeyDown(EInputKey(1)))
        {
            GotoState('None');
            DragState = false;
        }
        return;
    }
    stop;
}
defaultproperties
{
}
