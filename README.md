> An Org-babel “language” whose execution produces PNGs from LaTeX snippets;
> useful for shipping **arbitrary** LaTeX results in HTML or to **inline** such snippets
> in Emacs! (•̀ᴗ•́)و

<div align="center">

[![badge:Emacs](https://img.shields.io/badge/Emacs-23%2F26%2F28-green?logo=gnu-emacs)](https://www.gnu.org/software/emacs)
[![badge:Org](https://img.shields.io/badge/Org-9.3.6-blue?logo=gnu)](https://orgmode.org)

[![badge:license](https://img.shields.io/badge/license-GNU_3-informational?logo=read-the-docs)](https://www.gnu.org/licenses/gpl-3.0.en.html)
[![badge:https://github.com/alhassy/ob-latex-as-png](https://img.shields.io/twitter/url?url=https://github.com/alhassy/ob-latex-as-png)](https://twitter.com/intent/tweet?text=This%20looks%20super%20neat%20%28%E2%80%A2%CC%80%E1%B4%97%E2%80%A2%CC%81%29%D9%88%3A:&url=https://github.com/alhassy/ob-latex-as-png)
[![badge:contributions](https://img.shields.io/badge/contributions-welcome-green)](https://github.com/alhassy/ob-latex-as-png/issues)

[![badge:author](https://img.shields.io/badge/author-musa_al--hassy-purple?logo=nintendo-3ds)](https://alhassy.github.io/)
[![badge:](https://img.shields.io/badge/-buy_me_a%C2%A0coffee-gray?logo=buy-me-a-coffee)](https://www.buymeacoffee.com/alhassy)

</div>


# Table of Contents

1.  [Screenshot 1: Fancy Writing](#Screenshot-1-Fancy-Writing)
2.  [Screenshot 2: Bubble Diagrams](#Screenshot-2-Bubble-Diagrams)
3.  [Hint: Always redisplay images after `C-c C-c`](#Hint-Always-redisplay-images-after-C-c-C-c)
4.  [Enjoy!](#Enjoy)


# Screenshot 1: Fancy Writing

<div align="center">

![img](./Emacs_Org-mode.png)

</div>

<details> <summary>:rose: Click to see Source!</summary>

    #+PROPERTY: header-args:latex-as-png :results raw value replace
    #+begin_src latex-as-png
    \input GoudyIn.fd
    \def\fncy#1{\fontsize{50}{60}\selectfont{\usefont{U}{GoudyIn}{xl}{n} #1}}

    \hspace{0.15\textwidth}\fncy{EMACS}
    \newline
    \fncy{ORG}\raisebox{0.5em}{$\sim$}\fncy{MODE}
    #+end_src

</details>

Note: The [Goudy Initalen](https://www.tug.org/FontCatalogue/goudyinitialen/) font exists in uppercase only.


# Screenshot 2: Bubble Diagrams

<div align="center">

![img](./bubble_diagram.png)

</div>

<details> <summary>:rocket: Click to see Source!</summary>

    #+PROPERTY: header-args:latex-as-png :results raw value replace
    #+begin_src latex-as-png :file example.pdf :resolution 120
       \smartdiagram[bubble diagram]{Emacs,Org-mode, \LaTeX, Pretty Images, HTML}
    #+end_src

</details>


# Hint: Always redisplay images after `C-c C-c`

Place the following incantation in your init (•̀ᴗ•́)و)

    ;; Always redisplay images after C-c C-c (org-ctrl-c-ctrl-c)
    (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images)


# Enjoy!

<div align="center">

![Thank you](https://camo.githubusercontent.com/4fd95715cff5db944532897c286e526780e90660/68747470733a2f2f6d65646961332e67697068792e636f6d2f6d656469612f53396f4e4743314534325654324a527973762f67697068792e676966)

</div>
