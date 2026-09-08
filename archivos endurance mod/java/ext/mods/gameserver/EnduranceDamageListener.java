package ext.mods.gameserver;

import java.util.concurrent.ThreadLocalRandom;

import ext.mods.extensions.listener.OnCurrentHpDamageListener;
import ext.mods.gameserver.enums.Paperdoll;
import ext.mods.gameserver.model.actor.Creature;
import ext.mods.gameserver.model.actor.Player;
import ext.mods.gameserver.model.item.instance.ItemInstance;
import ext.mods.gameserver.skills.L2Skill;

public class EnduranceDamageListener implements OnCurrentHpDamageListener
{
    @Override
    public void onCurrentHpDamage(Creature creature, double damageHp, Creature target, L2Skill skill)
    {
        if (!EnduranceConfig.ENDURANCE_ENABLED || !(creature instanceof Player player))
            return;

        if (damageHp <= 0 || target == null || target == player)
            return;

        applyArmorWear(player, Paperdoll.HEAD);
        applyArmorWear(player, Paperdoll.CHEST);
        applyArmorWear(player, Paperdoll.LEGS);
        applyArmorWear(player, Paperdoll.GLOVES);
        applyArmorWear(player, Paperdoll.FEET);
        applyArmorWear(player, Paperdoll.LHAND);
    }

    private void applyArmorWear(Player player, Paperdoll slot)
    {
        final ItemInstance item = player.getInventory().getItemFrom(slot);

        if (item == null || !item.isEnduranceItem() || item.isBroken())
            return;

        if (!chanceSucceeded(EnduranceConfig.ENDURANCE_ARMOR_CHANCE))
            return;

        item.setEndurance(item.getEndurance() - EnduranceConfig.ENDURANCE_ARMOR_LOSS);

        if (item.isBroken() && item.isEquipped())
            player.getInventory().unequipItemInBodySlotAndRecord(item);
    }

    private boolean chanceSucceeded(int chance)
    {
        if (chance <= 0)
            return false;

        if (chance >= 100)
            return true;

        return ThreadLocalRandom.current().nextInt(100) < chance;
    }
}
