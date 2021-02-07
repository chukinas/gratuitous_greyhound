# Overview

Ubiquitous Language, as defined in Domain-Driven Design, is ....

# Dreadnought's Ubiquitous Language

## ARENA
that which includes everything that has "physical" dimension in the game world. It includes ships (units), terrain, paths, etc.

## (COMMAND) PATH
the sum total of all COMMANDs issued to a ship. It specifies the ship's ROUTE and ACTIONs. Question
should this be called the command queue instead? Then path can go back to being just about movement.

## ROUTE
a sub-set of PATH, this controls a UNIT's movement.

## ACTION
a part of PATH, an action lets a unit do something special, like boost its firepower or -rate, for some duration.

## SEGMENT
The game is broken up into discrete time chunks, each of which is an SEGMENT and has a duration of one PERIOD.

## PERIOD
The time it takes to complete a single SEGMENT. Mneumonic: This term is borrowed from the vocabulary of frequency, where 'period' is the inverse of frequency, or the time it takes to complete a single cycle.

## COMMAND
e.g. `Right, Speed 3, 45deg`, or `Straight, Speed 1`. In the earlier phases of development, a command has a duration of 1 PERIOD. Later, commands may have higher durations, but probably always in PERIOD multiples.

## (COMMAND) CARD
something like a poker deck playing card, showing a COMMAND. This COMMAND CARD can be drag-and-dropped onto a ship's PATH SEGMENT to change its PATH.

## (COMMAND) DECK
A collection of CARDS. Each UNIT starts with its own COMMAND DECK. Each of a DECK's CARDs is in *one* of the following states at any one time
draw deck, path, river, discard, destroyed. Question
should there be a discard pile at all? If yes, should there be some mechanism to shuffle it back into the draw deck?

## (PC, or PLAYER CHARACTER) UNIT
A large ship or squadron of smaller ships that a Player Character (PC) can issue COMMANDs to.

## NPC, or NON-PLAYER CHARACTER UNIT
a unit that does not have a command deck, but is either guided automatically by a PC UNIT's AI, or initiated via COMMAND. Examples include spotter teams, fighter-bomber aircraft.

## ABSOLUTE SEGMENT NUMBERING
Segments are 1-indexed. That is, the very first segment is #1.

## RELATIVE SEGMENT NUMBERING
The current segment is +0. The next SEGMENT is +1, and so on. The segment before the current one is -1, and so on.

## "NEXT X SEGMENTS"
This refers to the RELATIVE SEGMENTS 1 thru X.

## "WITHIN X SEGMENTS"
This refers to RELATIVE SEGMENTS 0 thru X.

## FUTURE SEGMENTS
Segments with a relative number greater than 0.

## INERTIA RATING
Larger units have more inertia and require more planning. A unit's INERTIA RATING is an integer between 1 and 5. New commands cannot be issued to segments within...

## INERTIAL ZONE
Those segments within [INERTIA RATING]. These segments are "locked", meaning they can no longer have Commands issued to them.

## PLANNING ZONE
All future segments not in the Inertial Zone.
