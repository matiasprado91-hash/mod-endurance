class AutoSkillWnd extends UICommonAPI;

const TIMER_ID = 6500;
const TIMER_SPOIL = 6501;
const MAX_SKILLS = 7;
const DELAY_SKILL = 100;

var WindowHandle Me;
var ItemWindowHandle iSkill[7];
var ItemInfo infItem[7];
var string bSkillON[7];
var bool cycleON;
var bool isSpoilMode;
var bool targetSpoiled;
var int skillNum;
var int lastSubClassID;

function OnEvent(int a_EventID, string a_Param)
{
    switch(a_EventID)
    {
        // End:0x18
        case 99968:
            ClearOnChangeSub();
            // End:0x3C
            break;
        // End:0x2B
        case 980:
            targetSpoiled = false;
            // End:0x3C
            break;
        // End:0x39
        case 40:
            ClearAll();
            // End:0x3C
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnLoad()
{
    local int i;

    RegisterEvent(99968);
    RegisterEvent(980);
    RegisterEvent(40);
    Me = GetHandle("AutoSkillWnd");
    HideWindow("AutoSkillWnd");
    i = 0;
    
    J0x3F:

    // End:0x84 [Loop If]
    if(i < 7)
    {
        iSkill[i] = ItemWindowHandle(GetHandle("AutoSkillWnd." $ string(i)));
        ++i;
        // [Loop Continue]
        goto J0x3F;
    }
    isSpoilMode = false;
    ClearAll();
    return;
}

function OnEnterState(name a_PreStateName)
{
    LoadSkillConfig();
    return;
}

function OnTimer(int TimerID)
{
    switch(TimerID)
    {
        // End:0x26
        case 6500:
            // End:0x23
            if(cycleON)
            {
                SkillUse(skillNum);
            }
            // End:0x29
            break;
        // End:0xFFFF
        default:
            break;
    }
    return;
}

function OnRClickItemWithHandle(ItemWindowHandle a_hItemWindow, int Index)
{
    local int i;
    local ItemInfo Clear;

    a_hItemWindow.Clear();
    i = 0;
    J0x16:

    // End:0x8A [Loop If]
    if(i < 7)
    {
        // End:0x80
        if(iSkill[i].GetItemNum() != 1)
        {
            // End:0x5C
            if(infItem[i].ClassID == 42)
            {
                isSpoilMode = false;
            }
            bSkillON[i] = "false";
            infItem[i] = Clear;
        }
        ++i;
        // [Loop Continue]
        goto J0x16;
    }
    SaveSkillConfig();
    return;
}

function OnDropItem(string a_WindowID, ItemInfo a_ItemInfo, int X, int Y)
{
    OnDropSkill(a_WindowID, a_ItemInfo);
    SaveSkillConfig();
    return;
}

function OnDropSkill(string a_WindowID, ItemInfo a_ItemInfo)
{
    local int i;
    //local EItemType EItemType;
    //local EEtcItemType EEtcItemType;

    i = int(a_WindowID);
    // End:0x31
	if(a_ItemInfo.ClassID == 42)
{
	if(isSpoilMode)
	{
		return;
	}
	isSpoilMode = true;
}
if((a_ItemInfo.Level > 0) || (a_ItemInfo.ItemSubType == 3) && isValidAction(a_ItemInfo.ClassID))
{
	AddSkill(i, a_ItemInfo);
}
    return;
}

function bool isValidAction(int ClassID)
{
    switch(ClassID)
    {
        // End:0x0B
        case 1:
        // End:0x10
        case 3:
        // End:0x15
        case 4:
        // End:0x1A
        case 5:
        // End:0x1F
        case 6:
        // End:0x24
        case 7:
        // End:0x29
        case 8:
        // End:0x2E
        case 9:
        // End:0x33
        case 10:
        // End:0x38
        case 11:
        // End:0x3D
        case 12:
        // End:0x42
        case 13:
        // End:0x47
        case 14:
        // End:0x4C
        case 24:
        // End:0x51
        case 25:
        // End:0x56
        case 26:
        // End:0x5B
        case 28:
        // End:0x60
        case 29:
        // End:0x65
        case 30:
        // End:0x6A
        case 31:
        // End:0x6F
        case 33:
        // End:0x74
        case 34:
        // End:0x79
        case 35:
        // End:0x7E
        case 40:
        // End:0x83
        case 50:
        // End:0x88
        case 51:
        // End:0x8D
        case 55:
        // End:0x92
        case 56:
        // End:0x97
        case 57:
        // End:0x9C
        case 58:
        // End:0xA1
        case 59:
        // End:0xA6
        case 60:
        // End:0xAB
        case 21:
        // End:0xB0
        case 23:
        // End:0xB5
        case 52:
        // End:0xBC
        case 53:
            return false;
        // End:0xFFFF
        default:
            return true;
            break;
    }
   
}

function AddSkill(int i, ItemInfo a_ItemInfo)
{
    local ItemInfo tmpItem;

    // End:0x39
    if(iSkill[i].GetItem(0, tmpItem) && tmpItem.ClassID == 42)
    {
        isSpoilMode = false;
    }
    iSkill[i].Clear();
    iSkill[i].AddItem(a_ItemInfo);
    infItem[i] = a_ItemInfo;
    bSkillON[i] = "true";
    return;
}

function SkillStart()
{
    Me.KillTimer(6500);
    Me.SetTimer(6500, 10);
    
}

function SkillStop()
{
    Me.KillTimer(6500);
    
}

function SkillUse(int i)
{
    local string bSkill;
    local UserInfo targetinfo;

    bSkill = bSkillON[i];
    skillNum++;
    // End:0x2B
    if(skillNum >= 7)
    {
        skillNum = 0;
    }
    // End:0x1FE
    if(((bSkillON[i] == "true") && GetTargetInfo(targetinfo)) && (targetinfo.nCurHP > 0) || (infItem[i].ClassID == 42) && infItem[i].ItemSubType != 3)
    {
        // End:0x1BE
        if((infItem[i].ClassID > 0) && infItem[i].ItemSubType != 3)
        {
            // End:0x1A5
            if(((infItem[i].ClassID == 254) || infItem[i].ClassID == 302) || infItem[i].ClassID == 42)
            {
                // End:0x163
                if((!targetSpoiled && targetinfo.nCurHP > 0) && infItem[i].ClassID != 42)
                {
                    UseSkill(infItem[i].ClassID);                    
                }
                else
                {
                    // End:0x1A2
                    if((targetinfo.nCurHP <= 0) && infItem[i].ClassID == 42)
                    {
                        UseSkill(infItem[i].ClassID);
                    }
                }                
            }
            else
            {
                UseSkill(infItem[i].ClassID);
            }            
        }
        else
        {
            DoAction(infItem[i].ClassID);
        }
        Me.KillTimer(6500);
        Me.SetTimer(6500, 100);
    }
    return;
}

function ClearOnChangeSub()
{
    ClearAll();
    skillNum = 0;
    SaveSkillConfig();
    return;
}

function int GetMyClassID()
{
    local UserInfo Info;

    GetPlayerInfo(Info);
    return Info.nSubClass;
    
}

function ClearAll()
{
    local int i;
    local ItemInfo clsInfo;

    i = 0;
    J0x07:

    // End:0x56 [Loop If]
    if(i < 7)
    {
        iSkill[i].Clear();
        infItem[i] = clsInfo;
        bSkillON[i] = "false";
        ++i;
        // [Loop Continue]
        goto J0x07;
    }
    skillNum = 0;
    isSpoilMode = false;
    return;
}

function LoadSkillConfig()
{
    local int i;
    local ItemInfo SkillInfo;
    local UserInfo UserInfo;
    local string param;

    // End:0x12
    if(!GetPlayerInfo(UserInfo))
    {
        return;
    }
    ClearAll();
    i = 0;
    J0x1F:

    // End:0x144 [Loop If]
    if(i < 7)
    {
        SkillInfo.ClassID = 0;
        SkillInfo.Name = "";
        SkillInfo.Level = 1;
        param = GetOptionString("AutoSkill_" $ UserInfo.Name, "Skill_" $ string(i));
        ParseInt(param, "ID", SkillInfo.ClassID);
        // End:0xE1
        if(ParseString(param, "icon", SkillInfo.IconName))
        {
            SkillInfo.Name = "Action";
            SkillInfo.ItemSubType = 3;            
        }
        else
        {
            SkillInfo.ItemSubType = 2;
            SkillInfo.IconName = Class'UIDATA_SKILL'.static.GetIconName(SkillInfo.ClassID, 1);
        }
        // End:0x128
        if(SkillInfo.ClassID <= 0)
        {
            // [Explicit Continue]
            goto J0x13A;
        }
        OnDropSkill(string(i), SkillInfo);
        J0x13A:

        i++;
        // [Loop Continue]
        goto J0x1F;
    }
    return;
}

function SaveSkillConfig()
{
    local int i;
    local UserInfo UserInfo;

    // End:0x12
    if(!GetPlayerInfo(UserInfo))
    {
        return;
    }
    i = 0;
    J0x19:

    // End:0x107 [Loop If]
    if(i < 7)
    {
        // End:0xAD
        if(infItem[i].ItemSubType == 3)
        {
            SetINIString("AutoSkill_" $ UserInfo.Name, "Skill_" $ string(i), (("ID=" $ string(infItem[i].ClassID)) $ " icon=") $ infItem[i].IconName, "Option");
            // [Explicit Continue]
            goto J0xFD;
        }
        SetINIString("AutoSkill_" $ UserInfo.Name, "Skill_" $ string(i), "ID=" $ string(infItem[i].ClassID), "Option");
        J0xFD:

        ++i;
        // [Loop Continue]
        goto J0x19;
    }
    RefreshINI("Option.ini");
    return;
}
defaultproperties
{
}
