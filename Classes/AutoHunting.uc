
//================================================================================

// AutoHunting.

//================================================================================
class AutoHunting extends UICommonAPI;
var WindowHandle zzMe;
var ButtonHandle zzBtnattack,zzbtninfo, zzBtnattackoffexpand, zzbotonexpandminimized, zzBtnLongRange, zzBtnShortRange, zzBtnRespectHunt, zzBtnSummon, zzBtnBuff, zzBtnPageDec, zzBtnPageInc;
var AnimTextureHandle zzm_TexAnim1Expand, zzm_TexAnim2Expand;
var bool zzBtnRespectHuntIcon,activateautofarm, zzBtnSummontIcon,m_IsAnimationPlayingExpand;

var WindowHandle zzm_ResultAnimation1Expand, zzm_ResultAnimation2Expand;
 
var AutoSkillWnd scriptsauto;
var AutoPotionsWnd scriptsautos;

function OnLoad()
{
	RegisterEvent( EV_Die ); 
	scriptsauto = AutoSkillWnd(GetScript("AutoSkillWnd"));
	scriptsautos = AutoPotionsWnd(GetScript("AutoPotionsWnd"));
	zzm_TexAnim1Expand = AnimTextureHandle( GetHandle( "AutoHunting.Anim1CircleExpand.Anim1Expand" ));
	zzm_TexAnim2Expand = AnimTextureHandle( GetHandle( "AutoHunting.Anim2CoreExpand.Anim2Expand" ));
	zzBtnRespectHuntIcon = False;
	zzBtnSummontIcon = False;
	activateautofarm = false;
	RegisterEvent( EV_SystemMessage );
	RegisterEvent( EV_Restart );
	zzm_ResultAnimation1Expand = GetHandle( "AutoHunting.Anim1CircleExpand");
	zzm_ResultAnimation2Expand = GetHandle( "AutoHunting.Anim2CoreExpand");
	zzbotonexpandminimized = ButtonHandle ( GetHandle ("AutoHunting.btnDrawer") );
	zzbotonexpandminimized.SetTooltipCustomType(xxMakeTooltipSimpleText("Minimized"));
	xxGetButtonHandle("AutoHunting.btnDrawer").SetTexture("L2UI_CH3.AutoHunting.WinMinButton", "L2UI_CH3.AutoHunting.WinMinButton_down", "L2UI_CH3.AutoHunting.WinMinButton_over");
	zzbtninfo = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.btnInfoHunting") );
	zzbtninfo.SetTooltipCustomType(xxMakeTooltipSimpleText("AutoFarm Information"));
	zzBtnattack = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.Btnattack") );
	zzBtnattack.SetTooltipCustomType(xxMakeTooltipSimpleText("Automatic Skills"));
	zzBtnattackoffexpand = ButtonHandle ( GetHandle ("AutoHunting.BtnattackoffExpand") );
	zzBtnattackoffexpand.SetTooltipCustomType(xxMakeTooltipSimpleText("Auto Farm Off"));
	zzBtnRespectHunt = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnRespectHunt") );
	zzBtnRespectHunt.SetTooltipCustomType(xxMakeTooltipSimpleText("Respect Hunt Off"));
	zzBtnSummon = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnSummon") );
	zzBtnSummon.SetTooltipCustomType(xxMakeTooltipSimpleText("Summon Attack Off"));
	zzBtnLongRange = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnLongRange") );
	zzBtnShortRange = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnShortRange") );
	zzBtnLongRange.SetTooltipCustomType(xxMakeTooltipSimpleText("Click: To Inc Range Max"));
	zzBtnShortRange.SetTooltipCustomType(xxMakeTooltipSimpleText("Click: To Dec Range Max"));
	zzBtnBuff = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnBuff") );
	zzBtnBuff.SetTooltipCustomType(xxMakeTooltipSimpleText("Buff Protection On/Off"));
	zzBtnPageDec = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnDecPage") );
	zzBtnPageDec.SetTooltipCustomType(xxMakeTooltipSimpleText("Dec Bar Skill"));
	zzBtnPageInc = ButtonHandle ( GetHandle ("AutoHunting.DrawerButtons.BtnIncPage") );
	zzBtnPageInc.SetTooltipCustomType(xxMakeTooltipSimpleText("Inc Bar Skill"));
m_IsAnimationPlayingExpand = false;   
// Oculta la animaci??n al inicio
	scriptsauto.cycleON = False;
	xxBtnOnExpand();
	xxBtnOffExpand();
	xxBtnRespectHuntOn();
	xxBtnRespectHuntOff();
	xxBtnSummonOn();
	xxBtnSummonOff();
}







function OnEvent(int Event_ID, string param)
{
	

	if ( Event_ID == EV_Restart )
	{
		xxStopAll();
		activateautofarm = False;

	}

	else if (Event_ID == EV_SystemMessage)
	{
		
		xxHandleSystemMessage(param);
			

	}

	if (Event_ID == EV_Die){
		xxStopAll();
		activateautofarm = False;
	}
}
	
	
	
	
function xxHandleSystemMessage(string zza_Param)
{
	local int zzIndex;
	local string zzMsg;

	ParseInt(zza_Param,"Index",zzIndex);
	ParseString(zza_Param,"Param1",zzMsg);
 /*   if (zzIndex != 1987) 
    {
        return;
    }*/

	if ( -1 != InStr(zzMsg,"Auto Farm Blocked in the Olympics.") || -1 != InStr(zzMsg,"Auto Farm Blocked in the Instance Zone!") )
	{
		xxStopAll();
		activateautofarm = False;
            
	} 
	if ( -1 != InStr(zzMsg,"Auto Farm Blocked in Peace Zone!") )

	{
		xxStopAll();
		activateautofarm = False;
	}
		
		
	if ( -1 != InStr(zzMsg,"Auto Farm Disabled on Teleport!") )

	{
		xxStopAll();
		activateautofarm = False;
	}
		

	if ( -1 != InStr(zzMsg,"Respect Hunt On.") )

	{
		xxBtnRespectHuntOn();
		zzBtnRespectHuntIcon = True;
	}
	if ( -1 != InStr(zzMsg,"Respect Hunt Of.") )

	{
		xxBtnRespectHuntOff();
		zzBtnRespectHuntIcon = False;
	}
		

		
		
	if( -1 != InStr(zzMsg,"Dead, Auto Farm Disabled.") )
	{
		xxStopAll();
		activateautofarm = False;
	}
	if( -1 != InStr(zzMsg,"AutoFarm Disabled.") )
	{
		xxStopAll();
		activateautofarm = False;
	}
	if( -1 != InStr(zzMsg,"Autofarming deactivated") )
	{
		xxStopAll();
		activateautofarm = False;
	}
	if( -1 != InStr(zzMsg,"AutoFarm Disabled.") )
	{
		xxStopAll();
		activateautofarm = False;
	}
	if( -1 != InStr(zzMsg,"Automatic hunting is prohibited in this zone!") )
	{
		xxStopAll();
		activateautofarm = False;
	}
	if( -1 != InStr(zzMsg,"Active AutoFarm.") )
	{
		xxStartAll();
		activateautofarm = True;
	}
	if( -1 != InStr(zzMsg,"Active AutoFarm.") )
	{
		xxStartAll();
		activateautofarm = True;
	}
	if( -1 != InStr(zzMsg,"Autofarming activated") )
	{
		xxStartAll();
		activateautofarm = True;
	}
		

		
		
		
		
	return;


}	
	
	
	
function xxStartAll()
{
	zzm_TexAnim1Expand.SetLoopCount(-1);
	zzm_TexAnim1Expand.Play();
	zzm_TexAnim2Expand.SetLoopCount(-1);
	zzm_TexAnim2Expand.Play();
	xxBtnOnExpand();
	zzm_ResultAnimation1Expand.ShowWindow();
	zzm_ResultAnimation2Expand.ShowWindow();
		
	scriptsauto.cycleON = True;
	scriptsauto.SkillStart();
	
}
	
function xxStopAll()
{
	zzm_TexAnim1Expand.Stop();
	zzm_TexAnim2Expand.Stop();
        
	xxBtnOffExpand();
	zzm_ResultAnimation1Expand.HideWindow();
	zzm_ResultAnimation2Expand.HideWindow();
	scriptsauto.cycleON = False;
	scriptsauto.SkillStop();
	
}	
	
	

function OnShow ()
{
		
	if ( activateautofarm )
	{
		xxStartAll();
	//	OMG("ACTIVO");
		activateautofarm = True;
	}
	else
	{
		xxResetReady();
		//OMG("OFF");
		activateautofarm = False;
	}
		
		

}

function xxResetReady()
{
	
	
	
	zzm_ResultAnimation1Expand.HideWindow();
	zzm_ResultAnimation2Expand.HideWindow();
	xxBtnSummonOff();
	xxBtnOffExpand();
	xxBtnRespectHuntOff();

	if( zzBtnSummontIcon )
	{
		xxBtnSummonOn();
	}
	else
	{
		xxBtnSummonOff();
	}

	if( zzBtnRespectHuntIcon )
	{
		xxBtnRespectHuntOn();
	}
	
	
	else
	{
		xxBtnRespectHuntOff();
	}




}

function xxOnTeleport()
{

	zzm_TexAnim1Expand.Stop();
	zzm_TexAnim2Expand.Stop();
	xxBtnOffExpand();
	zzm_ResultAnimation1Expand.HideWindow();
	zzm_ResultAnimation2Expand.HideWindow();

}


function xxBtnOnExpand()
{
	zzBtnattackoffExpand.SetTexture( "L2UI_CH3.AutoHuntingWnd.FightON_Auto", "L2UI_CH3.AutoHuntingWnd.FightON_Auto", "L2UI_CH3.AutoHuntingWnd.FightON_Auto" );
	zzBtnattackoffexpand.SetTooltipCustomType(xxMakeTooltipSimpleText("Auto Farm On"));
}

function xxBtnOffExpand()
{
	zzBtnattackoffExpand.SetTexture( "L2UI_CH3.AutoHuntingWnd.fightoff", "L2UI_CH3.AutoHuntingWnd.fightoff", "L2UI_CH3.AutoHuntingWnd.fightoff_auto" );
	zzBtnattackoffexpand.SetTooltipCustomType(xxMakeTooltipSimpleText("Auto Farm Off"));
}

function xxBtnSummonOn()
{
	zzBtnSummon.SetTexture( "L2UI_CH3.autohuntingwnd.raidsbtn-shotd-normalon", "L2UI_CH3.autohuntingwnd.raidsbtn-shotd-normalon", "L2UI_CH3.autohuntingwnd.raidsbtn-shotd-overon" );
	zzBtnSummon.SetTooltipCustomType(xxMakeTooltipSimpleText("Summon Attack On"));
}

function xxBtnSummonOff()
{
	zzBtnSummon.SetTexture( "L2UI_CH3.autohuntingwnd.raidsbtn-shotd-normaloff", "L2UI_CH3.autohuntingwnd.raidsbtn-shotd-normaloff", "L2UI_CH3.autohuntingwnd.raidsbtn-shotd-overoff" );
	zzBtnSummon.SetTooltipCustomType(xxMakeTooltipSimpleText("Summon Attack Off"));
}

function xxBtnRespectHuntOn()
{
	zzBtnRespectHunt.SetTexture( "L2UI_CH3.AutoHuntingWnd.MannerBTNON_NORMAL", "L2UI_CH3.AutoHuntingWnd.MannerBTNON_OVER", "L2UI_CH3.AutoHuntingWnd.MannerBTNON_NORMAL" );
	zzBtnRespectHunt.SetTooltipCustomType(xxMakeTooltipSimpleText("Respect Hunt On"));
}

function xxBtnRespectHuntOff()
{
	zzBtnRespectHunt.SetTexture( "L2UI_CH3.AutoHuntingWnd.mannerbtnoff_normal", "L2UI_CH3.AutoHuntingWnd.mannerbtnoff_over", "L2UI_CH3.AutoHuntingWnd.mannerbtnoff_normal" );
	zzBtnRespectHunt.SetTooltipCustomType(xxMakeTooltipSimpleText("Respect Hunt Off"));
}

function xxBypass( string strBypass)
{
	RequestBypassToServer(strBypass);
}



function openautoskill()
{
    // End:0x2E
	if( IsShowWindow("AutoSkillWnd") )
	{
		HideWindow("AutoSkillWnd");        
	}
	else
	{
		ShowWindowWithFocus("AutoSkillWnd");
	}
	return;
}

	function getsuprainfoaauto()
{
	local UserInfo UserInfo;

	GetPlayerInfo(UserInfo);
    // End:0x162
	
	if( UserInfo.nCurHP <= 0 )	{
	xxStopAll();
}
	
}

function OnClickButton (string strID)
{

	switch (strID)
	{
		case "Btnattack":
	//ExecuteCommand(".autofarm");
		xxBypass("_infosettings");
			openautoskill();
			break;
		case "btnInfoHunting":
			ExecuteCommand(".autofarm");
		//	xxBypass("_infosettings");
		//	xxBypass("_bpUI autofarm info");
		//	xxBypass("_LotusUI FarmInfo");
			break;
 
 
	case "Btnattackoffexpand":
		if( activateautofarm == false )
	{
		   xxGetAnimTextureHandle("AutoHunting.Anim1CircleExpand.Anim1Expand").SetLoopCount(-1);
         // m_TexAnim1Expand.Play();
		  xxGetAnimTextureHandle("AutoHunting.Anim1CircleExpand.Anim1Expand").Play();
		  xxGetAnimTextureHandle("AutoHunting.Anim2CoreExpand.Anim2Expand").Play();
           xxGetAnimTextureHandle("AutoHunting.Anim2CoreExpand.Anim2Expand").SetLoopCount(-1);
       //   m_TexAnim2Expand.Play();
          xxBtnOnExpand();
          ShowWindow("AutoHunting.Anim1CircleExpand");
		  ShowWindow("AutoHunting.Anim2CoreExpand");
		  activateautofarm = true;
		  xxBypass("_autofarm");
	}else{

	   xxGetAnimTextureHandle("AutoHunting.Anim1CircleExpand.Anim1Expand").Stop();
                    xxGetAnimTextureHandle("AutoHunting.Anim2CoreExpand.Anim2Expand").Stop();
                    m_IsAnimationPlayingExpand = false;
                    xxBtnOffExpand();


		HideWindow("AutoHunting.Anim1CircleExpand");
HideWindow("AutoHunting.Anim2CoreExpand");


		activateautofarm = false;
		xxBypass("_autofarm");


	}
	break;
		case "BtnLongRange":
			//xxBypass("_radiusAutoFarm inc_radius");
			//xxBypass("_bpUI autofarm increaseMaxRange");
			xxBypass("_radiusAutoFarm inc_radius");
			break;
		case "BtnShortRange":
			//xxBypass("_radiusAutoFarm dec_radius");
			//xxBypass("_bpUI autofarm decreaseMaxRange");
			xxBypass("_radiusAutoFarm dec_radius");
			break;
		case "BtnRespectHunt":
		//	xxBypass("_enableRespectHunt");
		//	xxBypass("_bpUI autofarm respectHuntToogle");
		// xxBypass("_LotusUI AutoRespect");
			break;
		case "BtnIncPage":
			xxBypass("_pageAutoFarm inc_page");
			break;
		case "BtnDecPage":
			xxBypass("_pageAutoFarm dec_page");
			break;
		case "btnDrawer":
			xxminiexpand();
			break;
		case "BtnSummon":
			xxBypass("_enableSummonAttack");
			break;
		case "BtnBuff":
			xxBypass("_enableBuffProtect");
			break;
		default:
	}
}

function xxminiexpand()
{
    // End:0xFF
	if( IsShowWindow("AutoHunting.DrawerButtons") )
	{
		xxGetButtonHandle("AutoHunting.btnDrawer").SetTexture("L2UI_CH3.AutoHunting.WinExpandButton", "L2UI_CH3.AutoHunting.WinExpandButton_down", "L2UI_CH3.AutoHunting.WinExpandButton_over");
		zzbotonexpandminimized.SetTooltipCustomType(xxMakeTooltipSimpleText("Expand"));
		HideWindow("AutoHunting.DrawerButtons");
		HideWindow("AutoSkillWnd");  

	}
	else
	{
		xxGetButtonHandle("AutoHunting.btnDrawer").SetTexture("L2UI_CH3.AutoHunting.WinMinButton", "L2UI_CH3.AutoHunting.WinMinButton_down", "L2UI_CH3.AutoHunting.WinMinButton_over");
		zzbotonexpandminimized.SetTooltipCustomType(xxMakeTooltipSimpleText("Minimized"));
		ShowWindow("AutoHunting.DrawerButtons");
	}
	return;
}




function CustomTooltip xxSetTooltip(string Text)
{
	local CustomTooltip TooltipInfo;
	TooltipInfo.MinimumWidth = 145;
	TooltipInfo.DrawList.Length = 1;
	TooltipInfo.DrawList[0].eType = DIT_TEXT;
	TooltipInfo.DrawList[0].nOffSetX = 1;
	TooltipInfo.DrawList[0].t_bDrawOneLine = True;
	TooltipInfo.DrawList[0].t_color.R = 255;
	TooltipInfo.DrawList[0].t_color.G = 255;
	TooltipInfo.DrawList[0].t_color.B = 255;
	TooltipInfo.DrawList[0].t_color.A = 255;
	TooltipInfo.DrawList[0].t_strText = Text;
	return TooltipInfo;
}
defaultproperties
{
}
