# Python environment setup

**Goal:** by the end of this guide you will have a self-contained Python
environment for the course and a working `python_environment_check.ipynb`
notebook that demonstrates it. The main path uses **uv** and **JupyterLab** and
is identical on Windows, macOS, and Linux. Two optional appendices cover **VS
Code** and **Miniforge/conda** for people who need them or have time to explore.


## What tools are we using?

- **uv** installs Python and required dependencies/packages into isolated environments.
- **JupyterLab** is the notebook interface we'll use to run Python code and see the results.

Optional:
- **VS Code** is a popular code editor that can also run notebooks, as an alternative to using JupyterLab -- some people find it convenient, but not required. See Appendix A.
- **Miniforge** is a conda-based environment manager and package repository, as an alternative to uv for some cases where a required package isn't available as a normal pip package. See Appendix B.

uv can be used interactively (on demand), but is most useful when a project records the names of its dependencies in a file called `pyproject.toml`.  It can also make a snapshot of the specific versions that you have installed, and that you know are working, in a file called `uv.lock`.  Anyone who has a copy of your `pyproject.toml` can easily install the latest compatable version of the your project's dependencies on their own computer; if they also have a copy of your `uv.lock` then they'll get the exact same version of everything, which helps with *reproducibility*.  


## Step 1 — (Windows only) Use the right terminal

macOS and Linux users: skip to Step 2 and use your normal Terminal app.

On **Windows**, use **Windows Terminal** with a **PowerShell** tab.

- Windows 11 already has Windows Terminal as the default.
- Windows 10: install **Windows Terminal** from the Microsoft Store, then open it
  and pick a **PowerShell** tab (the down-arrow next to the `+` lets you choose).

Two recommendations:

- **Use PowerShell, not `cmd.exe`.** Everything below is PowerShell syntax.
- **Avoid the old Windows console window,** which has some confusing user interfaces.  Windows Terminal is better. 

---

## Step 2 — Install uv

uv is a single self-contained program. After it installs, it puts itself on your
`PATH`, which is how your terminal knows where to find installed software — **but an already-open terminal won't see the change, so you must open a new terminal afterwards.**

(If you've already installed uv in the past, you don't need to install it again -- check the "Verify" section below)

### macOS / Linux

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Then **close the terminal and open a new one.**

### Windows (PowerShell)

```powershell
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

`-ExecutionPolicy ByPass` just allows this one downloaded script to run; it does
not change any permanent system setting. Then **close the terminal and open a new
one.**

### Verify (all platforms)

In the **new** terminal:

```bash
uv --version
```

You should see a version number. If instead you get "command not found" /
"not recognized", see *Troubleshooting → uv not found* at the bottom.


## Step 3 — Create the test project

These commands are the same on every platform. We create a new project using version 3.12 of Python, and name it "mfa-env-test".  Then we navigate to the new project folder and add the packages needed for this test.

```bash
uv init --python 3.12 mfa-env-test
cd mfa-env-test
uv add jupyterlab ipykernel numpy pandas matplotlib scipy openpyxl
```

What just happened:

- `uv init` created a project folder with a `pyproject.toml` (for tracking your dependencies/required libraries) and a `.python-version` file. It will download Python 3.12 if you don't already have it.
- `cd` changes the current directory, like double-clicking on a folder in File Explorer or Finder to open it.
- `uv add` created a virtual environment in `.venv/` inside the project folder,
  installed the packages into it, and wrote a `uv.lock` lockfile with exact
  versions.

If you are not familiar with the terminal/command line, and would optionally like to know more, see Appendix C below.


## Step 4 — Run the notebook in JupyterLab (main route)

First, put the **`environment_check.ipynb`** file (provided separately) into this `mfa-env-test` folder.  On Windows, if you want to find where it is, run `explorer .` to open File Explorer in the current folder your terminal is in.  On Mac, the equivalent is `open .`.

From inside the `mfa-env-test` folder:

```bash
uv run jupyter lab
```

`uv run` executes the command **inside your project environment**, so you can use the libraries and dependencies we installed above. JupyterLab opens in your browser, and because it was launched from inside the project, all Python code you run will also run in the context of your project environment.

In JupyterLab:

1. Open `environment_check.ipynb` from the file browser on the left.
2. Run everything: **Run → Run All Cells** (or press Shift+Enter through each cell).

You should see, in order: the path to your project's Python (it will contain `.venv`), a ✅ that it's a uv environment, the list of installed packages, a row of ✅s for the key packages, and a sine/cosine plot. If you see those, you're done — your environment works.

To stop JupyterLab later: go back to the terminal and press **Ctrl+C** (confirm with `y` if asked).


## Step 5 — See what uv has recorded

Look inside the project folder. The two files that matter are:

- **`pyproject.toml`** — the human-readable list of what you asked for.
- **`uv.lock`** — the exact, fully-resolved versions of everything (including
  sub-dependencies).

Anyone you give those two files to can recreate your environment *exactly*, by running this in the same folder:

```bash
uv sync
```

If you want to add a package later: `uv add <name>`. To remove one: `uv remove <name>`. Both update `pyproject.toml` and `uv.lock` for you.

---

# Appendix A — VS Code (optional)

VS Code is a popular editor that can run notebooks inline. It's entirely optional, but if you have got JupyterLab running and want to try something else, you can.


### One-time setup

1. Install **VS Code** (code.visualstudio.com).
2. In VS Code, install two extensions from the Extensions panel (the square icon
   in the left bar): **Python** and **Jupyter** (both by Microsoft).

### Each time

1. Open the project folder: `File → Open Folder…` and pick `mfa-env-test`.
   (Or, from a terminal already in that folder, run `code .`. On macOS, if `code`
   isn't found, open the Command Palette with **Cmd+Shift+P**, run
   *"Shell Command: Install 'code' command in PATH"*, then try again.)
2. Open `environment_check.ipynb`.
3. Top-right of the notebook, click **Select Kernel**. Choose the Python
   interpreter whose path contains `.venv` (it's usually recommended at the top).
   This works because you installed `ipykernel` into the project.  If you don't see the kernel listed, try closing and reopening VS code.
4. **Run All**. You should get the same ✅ results as in JupyterLab — and cell 1's
   path should contain `.venv`, confirming VS Code picked the right environment.


# Appendix B — Miniforge / conda (optional)

While most Python packages are available through uv as above, some have non-Python binary dependencies that must be installed in a different way -- such as some numerical, geospatial and optimisation libraries.  For these, conda is an alternative to uv, but if you can do everything you need with uv, stick with that.

### Why Miniforge and *not* Anaconda or Miniconda

The conda *program* is free and open source, but the default package channels
that ship with **Anaconda** and **Miniconda** now require a paid commercial
licence for larger organisations — and that has been interpreted to include many
universities and research institutes.

**Miniforge** is the community-built installer that ships the same `conda` tool
but points at the free, open **conda-forge** channel by default. It's a drop-in
replacement for everyday use, it's what a growing number of universities now mandate.

### Install

See the installation instructions <https://github.com/conda-forge/miniforge#install>

### Set up conda in your terminal

- **Windows (PowerShell):**
  ```powershell
  conda init powershell
  ```
- **macOS / Linux:**
  ```bash
  conda init "$(basename "$SHELL")"
  ```

Close and reopen the terminal. You'll see `(base)` at the start of your prompt.

### Create an environment and run the same test notebook

```bash
conda create -n mfa-conda python=3.12 jupyterlab ipykernel numpy pandas matplotlib scipy
conda activate mfa-conda
jupyter lab
```

Open the same `environment_check.ipynb`. This time cell 2 should report that it's
running in a **conda / Miniforge** environment (✅), and the path will contain
`envs/mfa-conda`. Everything else behaves the same.


# Appendix C - Terminals and shells (optional background)

You don't need anything in this appendix for the summer school.

But you might like to explore this to understand more about how to use the terminal.

## Terminal vs shell

These two words get used interchangeably but mean different things:

- A **terminal** (or "terminal emulator") is the *window* — the app that shows
  text and takes your keystrokes. On Windows that's **Windows Terminal**; on
  macOS it's **Terminal.app**; on Linux it's GNOME Terminal, Konsole, etc.
- A **shell** is the *program running inside* that window that actually
  interprets your commands. **PowerShell** is a shell. **bash** is a shell.
  **zsh** is a shell. One terminal window can host different shells in different
  tabs.

For basic use, the same commands (like `jupyter lab` or `uv add`) work exactly the same in these different shells, but they differ in how you do more complicated things.

## Why bash

Although powershell works well for basic use on Windows, the Linux shell "bash" is more transferrable:

- **macOS and Linux** ship with bash (or the very similar zsh) as standard.
- **HPC clusters** — you usually interact with via bash over SSH.
- Most **tutorials, READMEs, and Stack Overflow answers** are written assuming
  bash commands (`ls`, `pwd`, `cat`, `grep`, `cp`, `mv`, pipes, and so on).

PowerShell can do all the same things, but its command names and syntax differ,
so bash skills tend to transfer further.

## Optional: a bash shell on Windows via Git Bash

Windows doesn't come with bash, but you can add one easily. **Git for Windows**
bundles a small bash environment called **Git Bash**, which gives you both the
`git` command and a working bash shell with the common Unix utilities. It's a
popular, well-supported way to get a Unix-like command line on Windows without
the heavier installation of WSL (Windows Subsystem for Linux).

### Installing it

Pick whichever suits your machine:

- **Standard installer (simplest, works for most people).** Download from
  <https://git-scm.com/download/win> and run it. The defaults are fine. On many
  machines this can install per-user without administrator rights.
- **No administrator rights?** Use Portable Git from the same website, extract it to a folder you control (e.g. `C:\Users\<you>\Apps\git`), and add that folder's `cmd` subfolder to your *user* PATH.

### Using Git Bash inside Windows Terminal

Once Git for Windows is installed, recent versions add a **Git Bash** profile to
**Windows Terminal** automatically. Open Windows Terminal, click the small
down-arrow next to the `+` tab button, and you should see **Git Bash** listed
alongside PowerShell — pick it to open a bash tab. If you'd like it to be your
default, go to Windows Terminal **Settings → Startup → Default profile** and
choose Git Bash.

If you use **VS Code**, it also detects Git Bash and offers it as an integrated
terminal: open the Command Palette and run **Terminal: Select Default Profile**,
then pick Git Bash.

Learn more:

- Git for Windows: <https://gitforwindows.org/>
- Windows Terminal: <https://aka.ms/terminal>
- VS Code terminal profiles: <https://code.visualstudio.com/docs/terminal/profiles>

## Further reading

The following are self-paced resources if you'd like to learn more:

- **The Unix Shell (Software Carpentry)** — a gentle, hands-on introduction to
  bash for researchers: <https://swcarpentry.github.io/shell-novice/>
- **Version Control with Git (Software Carpentry)** — the companion git
  introduction: <https://swcarpentry.github.io/git-novice/>
- **The Missing Semester of Your CS Education (MIT)** — a broader tour of the
  shell, git, and everyday developer tooling: <https://missing.csail.mit.edu/>
- **explainshell** — paste any shell command and it annotates each part:
  <https://explainshell.com/>
