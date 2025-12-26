# Santa's Toy Workshop (Devlog)

Welcome to the devlog for my game [Santa's Toy Workshop](/gamiverses/themed/christmas/santas-toy-workshop/). I will briefly talk about the process of making this game, any interesting problems I faced (or solutions I came up with), and whatever else seems fun to track or talk about.

## What's the idea?

With Christmas coming up, I started thinking about Christmas video games to make. More specifically, Christmas _One Button Games_, a special type of game I invented in which every player gets exactly one random button. I felt that something about "delivering presents" was probably the most intuitive and easy thing to go for here. But how exactly? That's when my mind saw two solutions.

* You control the _sleigh_ together, delivering packages by landing on rooftops.
* You are in the _toy factory_, with conveyor belts/machines, and gifts need to end in the right basket.

I made idea 1 first, which became the game [Sleigh](/gamiverses/themed/christmas/sleigh/). Once done, I had a bit of time left and wanted to try idea 2 as well.

I don't know where it came from, but my mind came up with the following "core game loop".

* Gifts fall from the top.
* All players are one "machine" (just a position in the world, really) that moves up and down.
* There are edges _between_ those machines.
* By angling those edges, you can make the gifts roll to the right side and land into the right basket at the bottom.

For example, say a gift falls down that needs to be delivered to the _right_. Then the left player goes _up_, or the right player goes _down_, which makes the edge between them angle downward to the right. The gift will land on it, roll along, and (hopefully) end in the right basket.

I thought this was a very unique and promising method for creating a One Button Game. Everyone would have their own clear position/machine with easy single-button control. At the same time, you really need to work together, because every edge has _two players_ (on either side) controlling what it looks like.

And so I started making this.

## Practical Insights

The core code for such a mechanic is very simple and up-and-running quickly. Unfortunately, like most cases, it showed some practical mistakes (or "oversights") with my idea.

* OBGs need to support different player counts (usually 2--8 players). So ... what do we do on low player counts? Just remove machines and connect over vast distances? Include all machines anyway and you simply control multiple of them? 
* The left and right edge are annoying here. The player most on the left and right will have a more boring game, because they only control _one edge_. (Player 1 is only connected to player 2 on their right, for example.) Additionally, having a gap there means you have NO control over what happens there anymore.
* The biggest of them all: **if all players are connected with edges ... then gifts can never fall down!** Like ... doh! But I needed to see it in front of me to realize this. Gifts can never reach any basket, because the entire screen is covered horizontally in solid edges one way or another.

So, first things first, I tried to solve these in the most elegant ways possible. (Two birds with one stone kind of thing.)

* I decided to create _all_ machines from the start. (In fact, I create a bit more than we'll ever need, because it makes placement look nicer.) We simply only "activate" those needed for the current number of players, and we activate the machines such that they are spaced out evenly (left to right).
* I decided to simply add a "fixed" point at the left and right edge. The first and last player simply connect to that as well, giving them two edges like everyone else. That fixed point is not controlled by anyone and does not move.
* I added some simple code to **disable/enable edges** on the fly.

The question now, of course, is _how_ do you disable/enable the edges. By _holding_ your button? By quickly pressing it? Anything else?

After some experimentation, I settled on the control scheme I thought was both simplest and most fun.

* PRESS your button to switch direction. (Your machine automatically moves up/down, this flips it.)
* HOLD your button to speed up. (You move much faster, allowing you to get to the exact position you want.)
* Edges automatically "break" if two players are **too far apart**. That is, the angle between them is too great, causing their edge to be severed. That's how gifts can fall through.

I was quite happy with that third solution, to be honest. It freed up the buttons to be used for more useful things (i.e. the other bullet points), while being a very intuitive and interesting rule. You now have to work together even better to "break" edges at the right times, and make sure they're solid at other times. But it's not _too_ complicated, because all you need to do is "stay closer together".

## Finishing The Core Game

The beauty of OBGs is that the unique game idea _is_ basically the entire game. As such, once I had the above working (machines, edges, gifts fall down and in baskets) ... the game was nearly done. Yes, it looked like ugly gray rectangles right now, but the actual mechanics and difficult logic of the game was done.

All I needed to add was ...

* Gifts can be different "types".
* Baskets display which type they want: you only score for delivering the right one.
* Keep a general score, and if high enough, you win!

And some finetuning here. For example, 

* **Clean up** gifts that fall off screen (I forgot this at first and wondered why the game became very laggy if left open a while!)
* Add an arrow with the direction of your slider right now for clarity
* "Smoothen" slider speed. That is, don't _instantly_ go to max speed or break back to normal speed when a button is released. There's a subtle transition of ~0.5s, which makes it feel better and more fluid.
* Create fixed "arrangements" for the sliders depending on player count. (With 2 players, use slider X and Y. With 3 players, use slider X, Y and Z.) Randomly picking the slider positions just creates a visual mess _and_ potentially an unplayable game if, say, all sliders activated are on the same side of the screen. In such cases, it's just much easier to manually pick the only options for the "map layout" and make sure they're good ones.
* Make an edge flash red when it's about to break (or come back)
* Show the game score in a big and bold font plastered across the background.
* Show the contents of individual baskets => I switched to saying "Each basket needs X gifts inside, if so, you win". It just fit the game idea better than a single unified objective or an objective based on score. I know this because it simplified my code and made all puzzle pieces simply fall in the right place. For example, it was very easy to just show a counter _per basket_, as opposed to finding some space on the screen for a single counter _for all presents_.
* Perhaps most importantly, **rescale** the game so it works with any screen size. 

I could've chosen a fixed "factory layout" and just made everything fit those dimensions. Whenever possible, however, I want to make it "flexible" so that it truly adapts to the native resolution of your screen. In a way, if your screen is slightly taller than that of another family, you are playing a slightly easier game because you have more time before gifts fall to the bottom :p

More specifically, this means ...

* I listen to a signal for when the screen size changes. (This includes the very first "size change" on game load; the initial size.)
* If so, the x-position (horizontally) of all sliders is immediately updated to fit the new width. (The edges between them are recalculated every frame anyway, so they'll adapt automatically to wherever the sliders go.)
* The y-position of the _fixed sliders_ updates to ensure they stay in the center.
* And the baskets at the bottom resize themselves to fill the entire bottom too.

## Polishing

Polishing in this case means creating nice images, sound effects, animations, etcetera.

Because it's such a simple game, which is also quite similar to the previous One Button Games I made, I could mostly copy over work from the previous games. 

* Simple sound effects for gifts appearing and being delivered, simple click effect for changing machine direction, etc.
* Simple pop-up/flash animations for the most important things happening
* A trail of stars behind gifts to make them look a bit nicer and fit into the environment better. (I wanted to add a drop shadow too, but the only shader for that I could find also DISPLACED the sprite slightly, making things not-perfectly-center-aligned anymore, which just looked odd and annoying. I'll figure that one out later.)
* I found some sound effects for the edges "snapping" and "stretching" ( = about to snap soon), which are just modified rubber band sounds.
* I added **tutorial images**. I had done text tutorials before, so I wanted to test the _image_ capability now. (Also, I'd already done the translations for all text in the game, so I didn't want to add tutorial text and have to translate more :p)
* And so forth, and so forth.

There's really not much interesting to say here. That is, unfortunately, what polishing feels like to me and many other developers. You're just doing the basic stuff that every game needs to look and feel better, with only a handful of custom/unique/creative polishing steps depending on the game itself. But anyway, after a few hours, it is done and the game looks much more professional.

I had hoped to use this game to improve my OBG system even further. Unfortunately, in the end, this game was too simplistic to really challenge the system or make it interesting enough. I decided to just finish this idea just before Christmas was done, and decide to overhaul the OBG system for the _next_ game. 

Overhaul is perhaps a strong word. This being only the 4th game I made with this system/framework, I simply have lots of missing features and bits of code that could be much cleaner now that I understand the problem space better.

{{% example %}}
I decoupled all the OBG systems at first. Every little bit of functionality (spawn player, listen to input, show instructions, etc) is its own tiny self-contained script/resource. Because that's nice and clean, yes, great. But ... it also meant that I had to add 5+ premade scenes into any game to "turn it into a One Button Game". To activate the system, so to speak. And after doing that 4 times, you think to yourself "I should just bundle these parts into one overarching manager script, so I only need to add this ONE THING and I'm done".
{{% /example %}}

As such, this 4th game didn't actually grow the system or my understanding of how to make better One Button Games. But that's fine. It's just a simple little (vaguely Christmassy) game that anyone can understand and play, but requires real collaboration to play _well_.

Until the next devlog,

Pandaqi