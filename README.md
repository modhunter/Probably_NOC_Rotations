
NOC Rotations
====================

##Status
- Demonk Hunter Havoc
- Monk Windwalker
- Monk Brewmaster
- Hunter Survival (on hiatus)
- Hunter Beastmaster (on hiatus)
- Hunter Marksman (on hiatus)


## Demon Hunter (Havoc) -
====================

### Features
====================

### Hotkeys
====================
- Left Shift - Pause
- Left Control -
- Left Alt -

### Survival
====================

### Rotation
====================
- Basically following the Simcraft suggested priority system

### Issues/Todo
====================
- Make Metamorphosis cast correctly at the ground Automatically using generic unlock
- Add AOE Rotation - sort of done
- Add automatic (toggleable) vengeful retreat & fel rush logic
- Add automatic jump (JumpOrAscendStart()) & cancel (AscendStop()) when doing vengeful retreat and Fel Rush


## Windwalker Monk (6.2)
====================

### Features
====================
- Self Buffs in & out of combat
- Cooldowns
- Chi Stacking on a toggle so that you can have max chi as combat starts
- Castcading Interrupts when cast time is at 30%:
  - Spear Hand Strike
  - Ring of Peace (if talent chosen) when SHS is on CD
  - Leg Sweep (if talent chosen) when SHS is on CD
  - Pandaran racial Quaking Palm (if able to use) when SHS & Ring of Peace are both on CD
  - Paralysis when SHS, Quaking Palm, & Ring of Peace are all on CD
- Queued Spells (use '/mWW <qName (see below)/spellID>')
  - Touch of Karma (/mWW qKarma)
  - Tiger's Lust (/mWW qLust)
  - Healing Sphere (/mWW qSphere)
  - Ring of Peace (/mWW qtFour)
  - Charging Ox Wave (/mWW qtFour)
  - Leg Sweep (/mWW qtFour)
  - Diffuse Magic (/mWW qTfive)
  - Dampen Harm (/mWW qtFive)
- Automatic & smart Storm, Earth, and Fire on mouseover. It will not apply more than 2 clones, will prevent you from castting on your current target, and if you switch to a target with one on, it will cancel the spell. Thanks to Tao for the routine
- Toggle button for turning on/off automatic targetting while in combat & automatic target switching to next nearest target - this is to allow for high efficiency when needed
- Toggle button for switching Nimble Brew on/off.  This may be necessary to use for an encounter where breaking out of a movement-imparing effect will cause excessive raid-wide damage.


### Hotkeys
====================
- Left Shift - Pause
- Left Alt - Touch of Karma
- Left Control - Leg Sweep

### Survival
====================
- Expel Harm <= 80% health
- Chi Wave <= 75% health
- Forifying Brew at < 30% health and when DM & DH buff is not up
- Diffuse Magic at < 50% health and when FB & DH buff is not up
- Dampen Harm at < 50% health and when FB & DM buff is not up
- Healthstone
- Detox yourself if you can be dispelled
- Nimble Brew if you are disoriented/feared/stunned/rooted/snared
- Tiger's Lust if you are disoriented/stunned/rooted/snared
- Self-Healing via Expel Harm while out of combat

### Rotation
====================
- Controlled single-target tests have shown this profile exceeds simcraft by 12%

### Issues/Todo
====================
- Objectmaker ideas:
  - Auto ToD any in-range qualified enemies
  - Better auto SEF to pick enemies quicker instead of relying on legacy checks
  - Auto stop FSK & Chi Torpedo??
  - Auto-place zen sphere on highest health player closest to the boss/target
  - Completely accurate enemies count using range around me to determine true number of qualified enemies
  - Smart chex checking to know # of enemeis that would be affected to pinpoint 3 or 4 chi chex usage
  - Smart RJW/SCK usage using exact info to determine how many enemeis will be hit - idea is that we would only ever use these if it would be beneficial based on enemies that would truly be hit


## Brewmaster Monk (6.2)
====================

### Features
====================
- Self Buffs in & out of combat
- Cooldowns
- Castcading Interrupts when cast time is at 30%:
  - Spear Hand Strike
  - Ring of Peace (if talent chosen) when SHS is on CD
  - Leg Sweep (if talent chosen) when SHS is on CD
  - Pandaran racial Quaking Palm (if able to use) when SHS & Ring of Peace are both on CD
  - Paralysis when SHS, Quaking Palm, & Ring of Peace are all on CD
- Queued Spells (use '/mBM <qName (see below)/spellID>')
  - Guard (/mBM qGuard)
  - Fortifying Brew (/mBM qBrew)
  - Zen Meditation (/mBM qZen)
  - Statue of the Ox (/mBM qOx)
  - Paralysis (mouseover) (/mBM qPara)
  - Ring of Peace (/mBM qtFour)
  - Charging Ox Wave (/mBM qtFour)
  - Leg Sweep (/mBM qtFour)
  - Diffuse Magic (/mBM qTfive)
  - Dampen Harm (/mBM qtFive)
- Multitarget/AOE mode will only engage AOE abilities when both the multitarget toggle is set and there are at least 4 active enemies - this means that you can generally leave multitarget toggled on and not cast Spinning Crane Kick over and over
- Toggle button for turning on/off automatic targetting while in combat & automatic target switching to next nearest target - this is to allow for high efficiency when needed
- Purify always at Heavy Stagger and only when shuffle is at least 25% of health with Moderate Stagger
- Toggle to turn on/off Keg Smash
- Toggle to turn on/off Guard
- Toggle to turn on/off Fortifying Brew
- Auto-enable Sturdy Ox Stance if not in it already

### Hotkeys
====================
- Left Shift - Pause
- Left Control - Dizzying Haze
- Left Alt - Black Ox Statue

### Survival
====================
- Elusive Brew at 10 stacks
- Fortifying Brew <= 35% health
- Guard <= 50% health
- Expel Harm < 85% health
- Chi Wave < 85% health
- Chi Burst < 86% health
- Zen Sphere on focus target if the buff is already present on you
- Zen Sphere on yourself when needed
- Healthstone < 40% health
- Detox yourself if you can be dispelled
- Nimble Brew if you are disoriented/feared/stunned/rooted/snared
- Tiger's Lust if you are disoriented/stunned/rooted/snared
- Self-Healing via Expel Harm while out of combat

### Issues/Todo
====================
- Objectmaker ideas:
  - Auto ToD any in-range qualified enemies
  - Auto-place ox statue in optimal location
  - Auto keg brew throw thing
  - Auto stop FSK & Chi Torpedo
  - Auto-place zen sphere on highest health enemy closest to the boss
