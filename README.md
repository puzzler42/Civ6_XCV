# Civ6_XCV
Civilization 6 Mod: Expanded Culture Victory

---------------------------------------------------------
# Intro

This mod's story began when I was playing a low difficulty multiplayer game with a friend.  It was my first ever multiplayer game of Civ 6 and I wanted to explore as much of the game mechanics as I could.  The problem was that I was suddenly quite close to a culture victory without really trying.  I had built a bunch of wonders and such but I wanted to continue playing.  Of course I could use the "One more turn" function after victory or do a new game with Culture Victory turned off, or play at a higher difficulty, but I didn't like either of those first two choices and didn't feel ready for the third at the time.  Despite my best efforts to sabotage myself for as long as possible in that game I still won too quickly.  If it had been due to skill or concious effort at least I wouldn't have minded, but I just accidently filled up a meter.  This seemed boring to me, so I resolved to put my CS degree to use...

Cut to many games and years later (most of which did NOT involve active work on this) and I have gotten this mod to a point where I feel I can share it.  Since I like being able to find info myself, I figured I should return the favor (besides which I had to research a lot to get this written seeing as how I started with 0 Lua-specific, modding-oriented or Civilization experience and it wouldn't feel right to keep what I learned to myself).

---------------------------------------------------------
# What this mod does

Menu Options:
  -Checkbox to enable/disable mod from game setup screen (so that you don't have to disable the whole mod in the content manager if you want it off)
  -Option to scale the production cost of the victory projects that have been added (field is a percentage, so 100 is default)
In Game changes:
  -Added 3 Projects to the game and to the requirements for cultural victory:
    ~Fight For Form: Upon completion grants the following effects: +3 Appeal in all cities; Double points towards Great Writers, Great Artists, and Great Musicians.  Unlocked by the Cultural Hegemony civic in the future era.
    ~Give Peace A Chance: Upon completion grants the following effects: +1 Movement to all units; All units ignore zones of control; Rock bands are half price. Unlocked by the Smart Power Doctrine civic in the future era.
    ~Knowledge Is Power: Upon completion grants the following effects: +5 Power in all cities; Archaeologists are half price to purchase; Triple tourism from artifacts.  Unlocked by the Information Warfare civic in the future era
    ~All of these require a theater disctrict.
    ~Only one instance of each project is allowed per player.
  -Added notifications when anyone completes one of these projects (both to the player who did so and to their opponents)
  -Altered the notification about other player's impending culture victory to reflect that it is not all they need to win
  -Added logic to the game's AI so that it would know it should do these if it wants a culture victory
  
---------------------------------------------------------
# How some of these are done

-The checkbox and scaling field were a little tricky to figure out but not impossible, and implementing the checkbox's effect wasn't bad either (see the actioncriteria in the modinfo file).  Getting the scaling field to do anything in game was a bit harder.  I wasn't sure I could use a dynamic modifier since the number wasn't in the gameplay database, but in the config database.  I ended up borrowing a kludge-turned-accepted-practice for Civ modding that I learned of and used an lua script to add dummy buildings.  These buildings each have a modifier that alters the production speed by a fixed percent and my script (which CAN read the config data) calculates how many are needed and adds them.  They can't be built directly since they require a specifc religion that is never specified to the game.  They do show up in the city building list panel (though only once per type).

-The messages are also handled by the lua script by adding a function onto the event for city production completion.  I have not managed to figure out how to properly specify the icon used by the notification (I tried quite a few methods and they are unique notifications and types) so the game just grabs an icon more or less at random (this is its response to being unable to determine what to use and is not code I wrote anywhere).

-The altered message is a simple database/text update

-The AI logic is a simple addition of these projects to the AI's list of things it likes to do under circumstances where it thinks it could win a culture victory.

---------------------------------------------------------
# Compatibility

This mod is theoretically compatible with any other mod since it only either adds things or replaces text.  It IS designed to use the table structure implemented after both major expansions.  As of the initial commit/upload I have all available official DLC/expansions.  Situations where it may not work:
  -All theater disctricts are replaced by another type of district
    ~I still have to run some tests as the Greeks to make sure their Acropolis is able to do these projects.  If there are issues, then it may or may not be possible to proof the mod against other mods that replace the theater district.  If there are no issues, this may still be a problem with other mods depending on how they code replacements of the theater district.
  -Another mod changes how culture victories work
    ~Last I checked there were none of these, and if there were why would you try to stack them?  In any case, depending on which mod was initiated first and how the other mod works it MIGHT stck the requirements together or one might overwrite the other.
  -Something changes a table name or structure that is in use
    ~If another expansion is released (unlikely) or some mod/DLC majorly changes existing tables then things may break.
  -One or both expansions are not in use
    ~I have not tested this myself and don't particularly want to.
    
---------------------------------------------------------
# To Do

  -Figure out how to make historic moments and associated era scores happen.  I have art, text and data in place, but there is some list in the game's core files that needs updating to tell the game when to trigger these.  It might be doable by lua.  I could certainly simulate it, by overwriting the existing timeline UI, but that seems like a can of worms I'd rather not open.  I know one other mod has attempted to add custom historic moments and I may try to do an optional integration with that, depending on level of effort and functionality.
  -Get the notification icon fixed.  I don't know why it doesn't want to use a specified icon and it's low on my priority list at present (I don't have a custom icon for it, but consistency would be nice).
  -MAYBE add options to adjust or disable the bonuses from the projects.  It would depend on whether doing so causes other issues (such as with dummy buildings).
  -MAYBE find a way to do the production modifiers without dummy buildings.  It would depend on whether the fix is worse than the issue.
  -Fix production required indicator for projects.  As a result of the dummy buildings solution, the adjusted production cost and/or production per turn are not reflected in the ui except by the fact that the required number of turns changes.
    ~For example: in a marathon game at present version with a modifier at 10%, the production says 6000 needed.  For a city with 6 production per turn one would expect this to take 1000 turns, but with the 10% modifier it takes 100 (as expected since the modifier specifies the percentage of the default production that is required).  So in the UI you end u with a city that at 6 production per turn displayed and 0/6000 production done, 100 turns are needed.  The effect is right but the math done from the UI is off since it doesn't reflect the modifiers anywhere but in the turns required.
    
    
---------------------------------------------------------
# Other thoughts

I don't mind if other people use this stuff in whatever way they like as long as they aren't profiting off it without addition (i.e. if you modify it in some way I don't care if you then make that your own, but don't just repackage and charge people somehow).

I put the code online both in the hope that it will help others as well as serve to provide a backup if I am in future unable to update this mod and someone else wants to.
  
