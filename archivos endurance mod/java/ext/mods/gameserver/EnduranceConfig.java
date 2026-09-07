/*
 * Copyleft © 2024-2026 L2Lineternity
 * This file is part of L2Lineternity derived from aCis409/RusaCis3.8
 */
package ext.mods.gameserver;

import ext.mods.Config;
import ext.mods.commons.config.ExProperties;
import ext.mods.commons.logging.CLogger;
import ext.mods.extensions.listener.manager.BypassCommandManager;
import ext.mods.extensions.listener.manager.CreatureListenerManager;

public class EnduranceConfig
{
	private static final CLogger LOGGER = new CLogger(EnduranceConfig.class.getName());
	
	// Core
	public static boolean ENDURANCE_ENABLED;
	public static int MAX_ENDURANCE;
	public static int ENDURANCE_WEAPON_LOSS;
	public static int ENDURANCE_WEAPON_CHANCE;
	public static int ENDURANCE_ARMOR_LOSS;
	public static int ENDURANCE_ARMOR_CHANCE;
	public static int ENDURANCE_REPAIR_ITEM_ID;
	public static long ENDURANCE_REPAIR_BASE_COST;
	public static long ENDURANCE_REPAIR_COST_PER_POINT;
	
	private static final String ENDURANCE_FILE = Config.CONFIG_PATH.resolve("endurance.properties").toString();
	private static boolean DAMAGE_LISTENER_REGISTERED;
	private static boolean REPAIR_LISTENER_REGISTERED;
	
	public static void load()
	{
		final ExProperties endurance = Config.initProperties(ENDURANCE_FILE);
		
		ENDURANCE_ENABLED = endurance.getProperty("EnduranceEnabled", true);
		MAX_ENDURANCE = endurance.getProperty("MaxEndurance", 1000);
		ENDURANCE_WEAPON_LOSS = endurance.getProperty("EnduranceWeaponLoss", 1);
		ENDURANCE_WEAPON_CHANCE = endurance.getProperty("EnduranceWeaponChance", 1);
		ENDURANCE_ARMOR_LOSS = endurance.getProperty("EnduranceArmorLoss", 1);
		ENDURANCE_ARMOR_CHANCE = endurance.getProperty("EnduranceArmorChance", 10);
		ENDURANCE_REPAIR_ITEM_ID = endurance.getProperty("EnduranceRepairItemId", 57);
		ENDURANCE_REPAIR_BASE_COST = endurance.getProperty("EnduranceRepairBaseCost", 0L);
		ENDURANCE_REPAIR_COST_PER_POINT = endurance.getProperty("EnduranceRepairCostPerPoint", 1L);
		
		if (MAX_ENDURANCE < 1)
		{
			LOGGER.warn("MaxEndurance must be greater than 0. Using default value 1000.");
			MAX_ENDURANCE = 1000;
		}
		
		if (ENDURANCE_WEAPON_LOSS < 1)
		{
			LOGGER.warn("EnduranceWeaponLoss must be greater than 0. Using default value 1.");
			ENDURANCE_WEAPON_LOSS = 1;
		}
		
		if (ENDURANCE_ARMOR_LOSS < 1)
		{
			LOGGER.warn("EnduranceArmorLoss must be greater than 0. Using default value 1.");
			ENDURANCE_ARMOR_LOSS = 1;
		}
		
		if (ENDURANCE_WEAPON_CHANCE < 0 || ENDURANCE_WEAPON_CHANCE > 100)
		{
			LOGGER.warn("EnduranceWeaponChance must be between 0 and 100. Using default value 1.");
			ENDURANCE_WEAPON_CHANCE = 1;
		}
		
		if (ENDURANCE_ARMOR_CHANCE < 0 || ENDURANCE_ARMOR_CHANCE > 100)
		{
			LOGGER.warn("EnduranceArmorChance must be between 0 and 100. Using default value 10.");
			ENDURANCE_ARMOR_CHANCE = 10;
		}
		
		if (ENDURANCE_REPAIR_ITEM_ID < 1)
		{
			LOGGER.warn("EnduranceRepairItemId must be greater than 0. Using default value 57.");
			ENDURANCE_REPAIR_ITEM_ID = 57;
		}
		
		if (ENDURANCE_REPAIR_BASE_COST < 0)
		{
			LOGGER.warn("EnduranceRepairBaseCost must not be negative. Using default value 0.");
			ENDURANCE_REPAIR_BASE_COST = 0;
		}
		
		if (ENDURANCE_REPAIR_COST_PER_POINT < 0)
		{
			LOGGER.warn("EnduranceRepairCostPerPoint must not be negative. Using default value 1.");
			ENDURANCE_REPAIR_COST_PER_POINT = 1;
		}
		
		if (ENDURANCE_ENABLED)
		{
			if (!DAMAGE_LISTENER_REGISTERED)
			{
				CreatureListenerManager.getInstance().addHpDamageListener(new EnduranceDamageListener());
				DAMAGE_LISTENER_REGISTERED = true;
			}
			
			if (!REPAIR_LISTENER_REGISTERED)
			{
				BypassCommandManager.getInstance().registerBypassListener(new EnduranceRepairListener());
				REPAIR_LISTENER_REGISTERED = true;
			}
		}
		
		LOGGER.info("EnduranceEnabled: {}", ENDURANCE_ENABLED);
		LOGGER.info("MaxEndurance: {}", MAX_ENDURANCE);
		LOGGER.info("EnduranceWeaponLoss: {}", ENDURANCE_WEAPON_LOSS);
		LOGGER.info("EnduranceWeaponChance: {}%", ENDURANCE_WEAPON_CHANCE);
		LOGGER.info("EnduranceArmorLoss: {}", ENDURANCE_ARMOR_LOSS);
		LOGGER.info("EnduranceArmorChance: {}%", ENDURANCE_ARMOR_CHANCE);
		LOGGER.info("EnduranceRepairItemId: {}", ENDURANCE_REPAIR_ITEM_ID);
		LOGGER.info("EnduranceRepairBaseCost: {}", ENDURANCE_REPAIR_BASE_COST);
		LOGGER.info("EnduranceRepairCostPerPoint: {}", ENDURANCE_REPAIR_COST_PER_POINT);
	}
}