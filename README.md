# SoulsRM source cleanup
Cleanup of the Souls Remastered game source code by Retrobytes Productions, as well as compatibility (specifically the keypress check) for my TC2048 in particular (and every other TC2048 out there, for that matter? Or am I the only one?)

The code has been indented consistently, the sprite bitmap values have been turned into binary for better visualization and editability and the 'END IF's of single-line IFs have been removed for simplicity, given that the ZXBasic compiler allows that. Further code simplification and optimization is ~~planned~~ being performed, as well as corrections to apparent programming oversights.
Four branches will be created, one which compiles with no comp. errors, one which has also been checked and fixed for running bugs, a bug-free optimized version and a final optimized one with all oversights corrected. All versions will be compatible with my TC2048.

The available source code doesn't seem to have any license attached, so neither does this one.

------------------------------------------------------------------------------------------------------------------------------------

Retrobytes productions: https://retrobytesproductions.blogspot.com/

SoulsRM Info: https://retrobytesproductions.blogspot.com/2015/10/enciclopedia-homebrew-souls-remaster.html

Souls + SoulsRM (source code included) Download: https://retrobytesproductions.blogspot.com/2013/06/codigo-graficos-y-sonido-alxinho.html

The Timex Computer 2048: https://en.wikipedia.org/wiki/Timex_Computer_2048

--------------------------------------------------------------------------------------------------------------------------------------

~~Currently struggling with the ZXBasic compiler, which is why there are so many 'END IF's with :rem's before them;~~ Code compiles (with bugs) after particular modifications. Bug report ~~in progress~~ ~~submitted~~ probably being extended and delivered to the ZXBasic forum
