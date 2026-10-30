%% aslab.cls -- document class for the Applied Software Development Lab handouts
%%
%% Copyright (c) Michael Lehn
%% Licensed under CC BY-SA 4.0 (https://creativecommons.org/licenses/by-sa/4.0/)
%%
%% The handouts reproduce the page layout of the original German edition.
%% Every page is composed of regions that are anchored at fixed vertical
%% positions, so that each exercise starts at the same place on the same
%% page as in the original and keeps the same amount of working space.
%%
%% Coordinates are given in PostScript points (bp) measured from the top-left
%% corner of the A4 page, exactly as reported by PDF tools for the original.
%%
%%   \begin{region}[<options>]{<y>} ... \end{region}
%%       Typesets its contents in a box whose first baseline lies at <y>
%%       (the baseline is located by aslab.lua).
%%       Options: x=<bp> (left edge, default 56.69), width=<bp>
%%       (default: text width), pitch=<bp> (baseline distance), top
%%       (<y> denotes the top edge instead of the first baseline).
%%   \nextpage ends a page; regions never break across pages.
%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aslab}[2026/10/30 Applied Software Development Lab handouts]

\newif\ifaslab@titlefooter
\DeclareOption{titlefooter}{\aslab@titlefootertrue}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax

\LoadClass[a4paper]{article}

\RequirePackage{iftex}
\RequireLuaTeX
\RequirePackage[a4paper,left=56.69bp,right=56.69bp,top=56.69bp,
  bottom=40bp,headheight=0pt,headsep=0pt,footskip=0pt,nohead,nofoot]{geometry}
\RequirePackage{fontspec}
\RequirePackage[english]{babel}
\RequirePackage{xcolor}
\RequirePackage{graphicx}
\RequirePackage{calc}
\RequirePackage{enumitem}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{listings}
\RequirePackage{tikz}
\usetikzlibrary{shapes.geometric,arrows.meta,positioning,calc,
  decorations.pathreplacing,fit,backgrounds}
\RequirePackage{lastpage}
\RequirePackage{pgfkeys}
\RequirePackage{amsmath}
\RequirePackage[hidelinks]{hyperref}
\RequirePackage{xurl}

%% ---------------------------------------------------------------- fonts --
\setmainfont{TeX Gyre Heros}
\setsansfont{TeX Gyre Heros}
\setmonofont{Fira Mono}
\newfontfamily\emojifont{Noto Color Emoji}[Renderer=HarfBuzz]
\newcommand*\emoji[1]{{\mdseries\emojifont\symbol{"#1}}}
\renewcommand\familydefault{\sfdefault}
\renewcommand\normalsize{\fontsize{11bp}{12bp}\selectfont}
\renewcommand\small{\fontsize{10bp}{11bp}\selectfont}
\renewcommand\footnotesize{\fontsize{9bp}{10bp}\selectfont}
\renewcommand\scriptsize{\fontsize{8bp}{9bp}\selectfont}
\renewcommand\large{\fontsize{13.2bp}{15bp}\selectfont}
\renewcommand\Large{\fontsize{18bp}{21bp}\selectfont}
\normalsize

\setlength\parindent{0pt}
\setlength\parskip{0pt}
\setlength\topskip{0pt}
\setlength\emergencystretch{2em}
\raggedbottom
\pagestyle{empty}
\frenchspacing
\hyphenpenalty=1000
\exhyphenpenalty=1000

%% --------------------------------------------------------------- colors --
\definecolor{aslabblue}{HTML}{004D7F}
\definecolor{aslabgray}{HTML}{929292}
\definecolor{codebg}{HTML}{D5D5D5}
\definecolor{codeorange}{HTML}{CD7923}
\definecolor{codecyan}{HTML}{34BBC8}
\definecolor{codepurple}{HTML}{5230E1}
\definecolor{codered}{HTML}{C33720}
\definecolor{codemagenta}{HTML}{D53BD3}
\definecolor{codegreen}{HTML}{34BC26}
\definecolor{hlgreen}{HTML}{C6EFCE}
\definecolor{linkblue}{HTML}{1F5FA8}

%% ------------------------------------------------------- document data --
\newcommand*\coursetitle{Applied Software Development Lab}
\newcommand*\handoutnumber{}
\newcommand*\handouttitle{}
\newcommand*\sethandout[2]{%
  \renewcommand*\handoutnumber{#1}\renewcommand*\handouttitle{#2}%
  \hypersetup{pdftitle={\coursetitle: Lab Handout #1 -- #2},
    pdfauthor={Michael Lehn},
    pdfsubject={Applied Software Development Lab, Ulm University},
    pdfkeywords={ATmega328P, AVR, bare-metal programming, teaching materials}}}
\newcommand*\runningright{Lab Handout \handoutnumber}
\newcommand*\footerleft{\textcopyright\ Michael Lehn \textbar\ CC BY-SA 4.0}

%% ------------------------------------------------------ page decoration --
%% Header baseline 45.02bp, footer baseline 797.24bp (as in the original).
\newcommand*\aslab@put[3]{\put(\strip@pt\dimexpr#1bp\relax,
  -\strip@pt\dimexpr#2bp\relax){#3}}
\AddToHook{shipout/foreground}{%
  \unitlength=1pt\relax
  \ifnum\value{page}>1
    \aslab@put{56.69}{45.02}{\small\coursetitle}%
    \aslab@put{56.69}{45.02}{\makebox[\textwidth][r]{\small\runningright}}%
  \fi
  \ifnum\value{page}>1 \aslab@footer\else
    \ifaslab@titlefooter\aslab@footer\fi\fi}
\newcommand*\aslab@footer{%
  \aslab@put{56.69}{797.24}{\small\color{aslabgray}\footerleft}%
  \aslab@put{56.69}{797.24}{\makebox[\textwidth][r]{\footnotesize
    \thepage\ of \pageref*{LastPage}}}}

%% ------------------------------------------------------------- regions --
%% The text area starts at 56.69bp below the top edge.  Every region is
%% emitted as a zero-height box at the top of the text area and shifted
%% down to its anchor, so regions do not influence each other.
\newdimen\aslab@x \newdimen\aslab@w \newdimen\aslab@y \newdimen\aslab@pitch
\newdimen\aslab@prevbottom \aslab@prevbottom=0pt
\newdimen\aslab@pagebottom \aslab@pagebottom=792bp
\newif\ifaslab@top
\newbox\aslab@box
\directlua{dofile(kpse.find_file("aslab.lua"))}
\pgfkeys{/aslab/region/.cd,
  x/.code={\aslab@x=#1bp\relax},
  width/.code={\aslab@w=#1bp\relax},
  right/.code={\aslab@w=\dimexpr 538.59bp-\aslab@x-#1bp\relax},
  pitch/.code={\aslab@pitch=#1bp\relax},
  top/.code={\aslab@toptrue},
  free/.code={\def\aslab@free{1}},
}
\newenvironment{region}[2][]{%
  \par
  \aslab@x=56.69bp \aslab@w=\textwidth \aslab@pitch=12bp \aslab@topfalse
  \def\aslab@free{0}%
  \pgfkeys{/aslab/region/.cd,#1}%
  \aslab@y=#2bp\relax
  \def\aslab@ylabel{#2}%
  \setbox\aslab@box\vbox\bgroup
    \hsize=\aslab@w \linewidth=\hsize \columnwidth=\hsize
    \textwidth=\hsize
    \normalsize\baselineskip=\aslab@pitch\relax
    \parindent=0pt \parskip=0pt
    \everypar{}%
    \ignorespaces
}{%
    \par
  \egroup
  \aslab@place
  \ignorespacesafterend
}
\newcommand*\aslab@place{%
  \begingroup
  % distance from the top of the box to its first baseline, and the rest
  \dimen0=\directlua{tex.sprint(aslab.firstbaseline(\number\aslab@box))}sp
  \dimen2=\dimexpr\ht\aslab@box+\dp\aslab@box-\dimen0\relax
  \ifaslab@top
    \dimen4=\dimexpr\aslab@y-56.69bp\relax % top edge
  \else
    \dimen4=\dimexpr\aslab@y-56.69bp-\dimen0\relax
  \fi
  % overlap checks (positions in bp from the top of the page)
  \dimen6=\dimexpr\dimen4+56.69bp\relax % top edge on page
  \ifnum\aslab@free=0
    \ifdim\dimen6<\dimexpr\aslab@prevbottom-0.5bp\relax
      \PackageWarningNoLine{aslab}{Region overlap on page \thepage\space
        at y=\aslab@ylabel bp: previous region ends
        \the\dimexpr\aslab@prevbottom-\dimen6\relax\space below this
        region's top}%
    \fi
  \fi
  \dimen8=\dimexpr\dimen6+\dimen0+\dimen2\relax
  \ifdim\dimen8>\aslab@pagebottom
    \PackageWarningNoLine{aslab}{Region at y=\aslab@ylabel bp on page
      \thepage\space extends below the text area}%
  \fi
  \ifnum\aslab@free=0 \global\aslab@prevbottom=\dimen8 \fi
  \immediate\write-1{ASLAB REGION page=\thepage\space y=\aslab@ylabel\space
    top=\the\dimen6\space bottom=\the\dimen8}%
  \nointerlineskip
  \vbox to 0pt{\kern\dimen4
    \moveright\dimexpr\aslab@x-56.69bp\relax\copy\aslab@box\vss}%
  \nointerlineskip
  \endgroup
}
%% \nextpage ends the current page; it also resets the overlap tracker.
\newcommand\nextpage{\par\null\newpage\global\aslab@prevbottom=0pt
  \null\nointerlineskip}
\AtBeginDocument{\null\nointerlineskip}

%% Absolute placement of a graphic or any box: top-left corner at (x,y).
%% \placeat{x}{y}{material}
\newcommand\placeat[3]{\par\nointerlineskip
  \vbox to 0pt{\kern\dimexpr#2bp-56.69bp\relax
    \moveright\dimexpr#1bp-56.69bp\relax\hbox{#3}\vss}\nointerlineskip}
%% \placegraphic{x}{y}{width}{file}: image with its bounding box as in the
%% original (top-left corner and width in bp).
\newcommand\placegraphic[5][]{\par\nointerlineskip
  \vbox to 0pt{\kern\dimexpr#3bp-56.69bp\relax
    \moveright\dimexpr#2bp-56.69bp\relax
    \hbox{\includegraphics[width=#4bp,#1]{#5}}\vss}\nointerlineskip}

%% ------------------------------------------------------- figure styles --
\tikzset{
  flowbox/.style={rectangle, draw, rounded corners, minimum width=5cm,
    minimum height=1.2cm, text centered, align=center, fill=gray!10},
  flowjump/.style={diamond, aspect=2, draw, minimum width=5.5cm,
    text centered, align=center, fill=aslabblue!10, inner sep=1mm},
  flowarrow/.style={thick, ->, >=stealth},
}
%% \placefigure{x}{y}{width}{tikz file}: TikZ figure scaled to a given width,
%% top-left corner at (x,y).
%% With the optional argument <height>, the figure is scaled to fit into
%% width x height while keeping its aspect ratio.
\newcommand\placefigure[5][]{\placeat{#2}{#3}{\aslab@fit{#4}{#1}{\input{#5}}}}
\newbox\aslab@figbox
\newcommand\aslab@fit[3]{%
  \setbox\aslab@figbox\hbox{#3}%
  \if\relax\detokenize{#2}\relax
    \pgfmathsetmacro\aslab@scale{#1/(0.996264*\wd\aslab@figbox)}%
  \else
    \pgfmathsetmacro\aslab@scale{min(#1/(0.996264*\wd\aslab@figbox),
      #2/(0.996264*(\ht\aslab@figbox+\dp\aslab@figbox)))}%
  \fi
  \scalebox{\aslab@scale}{\box\aslab@figbox}}
%% Figure caption line (10bp) with its baseline at (x,y).
\newcommand\figcaption[3]{\begin{region}[x=#1,free]{#2}\small #3\end{region}}
%% An empty line (the original uses empty paragraphs for vertical spacing).
\newcommand\blank[1][\baselineskip]{\par\vskip#1\relax}

%% ------------------------------------------------------------- headings --
\newcommand*\maketitleblock{%
  \begin{region}[pitch=22.5]{75.26}%
    {\Large\bfseries\color{aslabblue}\coursetitle\par}%
    {\Large\color{aslabblue}Lab Handout \handoutnumber: \handouttitle\par}%
  \end{region}}
\newcommand\heading[1]{{\bfseries\color{aslabblue}#1\par}}
\newcommand\subheading[1]{{\bfseries #1\par}}

%% ----------------------------------------------------------- inline code --
\newcommand*\aslab@codestrut{\vrule width 0pt height 0.78em depth 0.26em\relax}
\NewDocumentCommand\code{v}{{\setlength\fboxsep{0.6bp}%
  \colorbox{codebg}{\aslab@codestrut\ttfamily\hyphenchar\font=-1 #1}}}
\NewDocumentCommand\codearg{m}{{\setlength\fboxsep{0.6bp}%
  \colorbox{codebg}{\aslab@codestrut\ttfamily #1}}}
\NewDocumentCommand\tcode{v}{{\ttfamily #1}}
\newcommand*\key[1]{\codearg{#1}}
%% Hyperlink set in the body font, as in the original
\newcommand*\link[2][]{\href{#2}{\textcolor{linkblue}{\if\relax\detokenize{#1}\relax
  \nolinkurl{#2}\else#1\fi}}}
\urlstyle{same}

%% ----------------------------------------------------------------- lists --
\setlist{nosep,topsep=0pt,partopsep=0pt,parsep=0pt,itemsep=0pt}
%% "- item" lists as used for learning objectives and short enumerations
\newlist{dashlist}{itemize}{2}
\newcommand*\aslab@dash{{\fontsize{13.2bp}{12bp}\selectfont -}}
\setlist[dashlist,1]{label={\aslab@dash},leftmargin=12bp,labelsep=*,
  labelindent=0pt,align=left}
\setlist[dashlist,2]{label={\aslab@dash},leftmargin=12bp,labelsep=*,
  align=left}
%% numbered exercise lists: bold "1." with the text at +18bp
\newlist{tasks}{enumerate}{2}
\setlist[tasks,1]{label={\bfseries\arabic*.},leftmargin=18bp,labelsep=*,
  align=left,labelindent=0pt}
\setlist[tasks,2]{label={(\alph*)},leftmargin=18bp,labelsep=*,align=left,
  labelindent=0pt}
\newlist{steps}{enumerate}{1}
\setlist[steps]{label={(\alph*)},leftmargin=18bp,labelsep=*,align=left,
  labelindent=0pt}
\newlist{bullets}{itemize}{2}
\setlist[bullets]{label={\textbullet},leftmargin=18bp,labelsep=*,align=left}

%% ----------------------------------------------------- code environments --
\lstdefinestyle{aslab}{basicstyle=\ttfamily,columns=fixed,
  basewidth=0.6em,keepspaces=true,showstringspaces=false,upquote=true,
  aboveskip=0pt,belowskip=0pt,xleftmargin=0pt,frame=none,
  breaklines=false,tabsize=8,extendedchars=true,
  literate={–}{{--}}1 {→}{{$\rightarrow$}}1 {ä}{{\"a}}1 {ö}{{\"o}}1
    {ü}{{\"u}}1}
\lstset{style=aslab}
%% A plain verbatim block in the body font size.
\lstnewenvironment{codeblock}[1][]{\lstset{style=aslab,#1}}{}

\endinput
