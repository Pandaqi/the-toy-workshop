# The Toy Factory (Devlog)

@TODO:


* Add the basic deliverables/non-game/gitignore exceptions
* Write devlog bit about "break edges" realization, fixed edges, general idea, etc
* Create different gift types + check correctness
* CLOSE GAME LOOP => Check score, win if good enough, finetune speeds and #gifts a bit for playability.
* Code fixes:
  * Find a way to automatically resize sliders and baskets to _any_ screen size, correctly. Should not be too hard actually.
    * Reposition the X-value of sliders + Y-value of fixed ones ( + update bounds)
    * Just update the baskets to get the entire width now (as all should be reachable)