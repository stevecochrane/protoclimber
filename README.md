# protoclimber

This is a prototype of some climbing mechanics for a 2D platformer that I
worked on between May and December of 2016, using
[HaxeFlixel](https://haxeflixel.com/). In July 2025 I was going through some
old projects and decided to dust this off, update it to the latest version of
HaxeFlixel so that it compiles again, and publish it.

## How to Play

You can play the HTML5 build, though it's unfinished and I think it might
actually be impossible to complete in its current state. I'll try to make some
small tweaks to the tilemap to fix this. There is no sound.

To play, use the left and right arrow keys to move while on the ground, and
hold and release X to jump. You can hold down the button to charge a higher
jump, though it takes more stamina. Press a direction while in the air over
grippable surfaces to climb the wall, and hold any direction to climb in that
direction. Watch your stamina (green bar in the bottom left) because once you
run out of stamina, you lose your grip and fall. You can also jump off the
wall, if you have enough stamina left to do it.

## Inspiration / Thoughts

At the time I had been working on a very large, very unfinished 2D platformer
called The Mountaineers that I will hopefully also dust off and get working
again soon. It had grown rather large and unwieldy, making it slow to
experiment with new mechanics, so I decided to break off just the parts that I
needed for a minimal prototype and go from there.

I wanted climbing to feel strategic, not just a means to get from point A to
point B. There are a lot of small optimizations you can make to climb further.
I had ideas for moving surfaces and hazards and such to add more of a timing
element, maybe even a turn-based feel, but I ran out of time and moved on.

## Branch Info

I wasn't sure what direction this would take so whenever I tried a new idea, I
started a new Git branch and logged changes. That gave me flexibility if I
wanted to test multiple ideas in parallel, or go back to an earlier idea.

- proto-1
  - Press Z to move left (left-hand movement) and X to move right (right-head
  movement).
  - Hold Up to move up or Down to move down with each Z or X button press.
  - Inspired by the movement of Toobin'.
  - It's nice how this mirrors the left and right hands, but being able to hold
  one direction and move in the other direction seems wrong.
- proto-2
  - Hold a direction and press X to move in that direction. Z has no effect
  now.
  - Loses the feeling of using two hands, but much easier to mentally grasp,
  and frees up the Z button for something else.
- proto-3
  - Adds a stamina bar that depletes with each button press, and regenerates
  slowly over time.
  - Inspired by the temperature meter in Excitebike.
  - At the moment it's too easy to get stuck and this should really regenerate
  faster if it stays.
  - This would also need some polish like a visual indication that your
  character is too tired to move.
- proto-4
  - Adds a charged jump mechanic, where if you hold the jump button down, a new
  meter is charged, and at a full charge the jump is twice as strong.
- proto-5
  - Adds the ability to slowly climb in any direction by holding down that
  direction.
  - Moving in bursts or with the charged jump now consumes more stamina as a
  result (and arguably should consume even more).
- proto-6
  - Adds the ability to grab onto and let go of the wall with the B button.
  - Since there is no ground movement yet, all you can do once you've let go is
  grab onto the wall again.
  - The player now maintains their current X velocity from when they let go of
  the wall until they hit the ground.
- proto-7
  - To this point, the player could immediately start moving in a direction as
  soon as they grab on to the wall, which doesn't feel right.
  - Now after grabbing the wall, directional controls are non-functional until
  a short time after the player has stopped sliding down.
- proto-8
  - Added the ability to move and jump while on the ground.
- proto-9
  - Hitting the A button while climbing now takes you off of the wall.
- proto-10
  - There are now areas on the wall where the player cannot climb.
  - Pressing the B button to grab the wall when over these zones has no effect.
  - Attempting to climb onto these no-climbing zones will stop you at the
  border.
- proto-11
  - Stamina is now only restored when on the ground, and the rate of stamina
  gain has increased.
  - Stamina now gradually decreases when climbing the wall, even when not
  boosting.
  - If you run out of stamina while climbing you now fall off the wall.
- proto-12
  - Climbing movement is now grid-based. Pressing an arrow key while climbing
  will move you one tile in that direction.
  - When grabbing on to the wall you are now snapped to the tile grid.
  - Stamina is now drained with each move. It also continues to drain even when
  still, but this idle stamina drain is now much slower.
- proto-13
  - The player now has air control, just like on the ground.
  - The air control implementation isn't sophisticated yet so it's overriding
  the charged jump's horizontal movement, so that will need refinement later.
- proto-14
  - The player now has to hold a direction to climb in that direction.
  - The player now has a simple animation when climbing where they rock back
  and forth a bit.
  - Climbing in eight directions is now supported.
- proto-15
  - Added a slight delay between movement steps that makes climbing feel a
  little more deliberate.
- proto-16
  - Replaced the stamina bar, which used to be a range of 0 to 100 values, to a
  segmented bar with 0 to 18 values. This is hopefully easier to parse.
  - For now, stamina is back to an instant recharge when you touch the ground,
  with no drain while on the wall, but that might be restored later.
- proto-17
  - The B button now does nothing, and you can instead hold Up to grab on to
  the wall. More conventional this way.
- proto-18
  - Holding the A button now charges a jump. If fully charged (0.5 seconds) the
  player jumps 1.5x the normal jump height.
  - To allow for this, jumping now happens on the release of the jump button
  rather than the initial press.
- proto-19
  - The player can no longer start charging a jump while in midair.
  - If the A button is held down when in midair, a charged jump starts as soon
  as the player hits the ground.
- proto-20
  - Added a new 'AvalancheGenerator' object that drops 'Avalanche' objects from
  the top of the screen, which hurt the player on contact.
  - Added a new 'HazardCircle' object that flies in a circle and hurts the
  player on contact.
- proto-21
  - Greatly expanded the tilemap so now the level is about 11 screens tall.
  This is a first draft and it could still use refinement.
