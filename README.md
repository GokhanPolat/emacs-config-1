emacs-config
============

My personal emacs config.

*Featuring:*

 * [`vim` emulation](https://bitbucket.org/lyro/evil/wiki/Home) including custom textobjects, motions, and operators
 * Extensive version tracking backup system
 * Persistence of:
   * File locations
   * File major modes
   * Registers
   * Minibuffer histories
   * Kill ring
   * Jump list
 * Everything that can be made fuzzy ([Sublime style](https://github.com/lewang/flx)) has been made fuzzy, including:
   * [Helm](https://github.com/emacs-helm/helm) (fuzzy file finder, goto definition, etc.)
   * [Company](https://github.com/company-mode/company-mode) (code autocomplete)
   * [Icicles](https://www.emacswiki.org/emacs/Icicles) (minibuffer completion)
   * [Ivy](https://github.com/abo-abo/swiper) (minibuffer completion)
   * Isearch
 * Extremely agressive file autoloading, and fast startup times (~1.0s)
 * An emphasis on correct code and robustness

Portability
===========

This config should be pretty portable, as long as your OS is UNIX-y. I currently run it on various Arch Linux, Fedora, and Ubuntu builds, as well as Raspberry Pis, Android phones, and Cygwin installations.

One thing that it most certainly does _not_ support is older Emacs versions. Right now, the minimum version is 24.4, and yes, that has bit me a few times. However, given that I arrived on the Emacs scene only just before the release of 24.4, I have a lack of motivation to backport to older Emacsen.

Supported Languages
===================

I actively work in the following languages:

  * Python/SAGE
  * C++
  * JS/HTML/CSS
  * Octave
  * Elisp (duh)
  * LaTeX

So expect those languages to be well supported. Of course, this config supports other languages as well. Drop by my [major mode support table](https://github.com/PythonNut/emacs-config/wiki/Major-Mode-project) to see what languages this config supports. I think you'll be surprised.
