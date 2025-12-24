# To-Do (The Toy Factory)

POLISHING:

**Also export for WEB + Mention ChromeOS support through Linux/Web build?**

* Add OBG system 
  * Make next OBG system improvements, that is:
    * A single "State" that's all I need to add, which creates and calls everything else in order.
      * Maybe rename to OBG then, just a standard scene to put anywhere it's needed
    * Instant debug players
    * Better PROTECTION against "released/pressed" when in _pause mode_, which means it wasn't triggered, and now things might be confused?
      * Trigger anyway even in pause mode?
      * Or just keep in mind that you can NEVER be sure every press has a release (and vice versa)?
    * Better way to use State for basic score/health management and objectives based on that
    * BUILT-IN TOOL FOR LANGUAGE-BASED GAMES:
      * https://www.reddit.com/r/godot/comments/1hun51u/coding_a_word_scramble_game_dictionary/


OPTIONAL:

* Allow machines to go over ANY path (not just up/down y, fixed x)

DONE:

* SFX
  * [x] New Gift
  * [x] Gift Delivered
  * [x] Gift Lost/Wrong
  * [x] Game Win
  * [x] Machine change direction
  * [x] Machine whirring => louder if going faster
  * [x] Edge snap/return
  * [x] Gift hits edge??
* Animations
  * [x] Gift appear/disappear => Basket also reacts to gift delivery and score change
  * [x] Score change (big one at back)
  * [x] Little popup on direction switch
  * [x] Flash red if going faster
  * [x] Same starry particles trailing gifts as in Sleigh?