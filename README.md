# Exercise: Sort the Downloads Folder

Exercise code for the lesson **Exercise: Sort the Downloads Folder** in Bash in Depth on [ask-codey.com](https://www.ask-codey.com).

`downloads/` is a messy Downloads folder: phone photos, two screenshots, songs, a lease, a resume, school papers and a year of receipts, all in one pile. Sort it into folders with `mkdir`, `mv` and `cp`, using wildcards and braces to move many files at once. A check script tells you which parts are done.

## Before you start

You need a terminal (the Terminal app on a Mac, Ubuntu on Linux or in WSL on Windows) and **bats**, the tool that runs the check. If `bats --version` doesn't print a version yet, install it:

```bash
sudo apt install bats       # Ubuntu, and Ubuntu in WSL
brew install bats-core      # a Mac, with Homebrew
```

## What's here

- `downloads/`: the folder to sort. Every file is a small stand-in with one line of text, not a real photo or PDF.
- `check.bats`: checks your sorted folder. You don't need to change it.

## Run it

Open a terminal in this folder (the one with `check.bats` in it), then go into the pile:

```bash
cd downloads
ls
```

## The job

1. **Make the folders.** `photos` and `music` in `downloads` (`documents` is already there), and `receipts` with four folders inside it, `q1` to `q4`, one for each quarter of the year.
2. **The bus pass.** The screenshot from October 2, `Screenshot 2026-10-02 at 09.14.55.png`, is your bus pass. Put it in `documents`, named `bus-pass.png`.
3. **Photos.** Every other `.jpg` and `.png` goes in `photos`.
4. **Music.** Every `.mp3` goes in `music`.
5. **Receipts.** Each receipt goes in its quarter's folder: January to March in `q1`, April to June in `q2`, July to September in `q3`, October to December in `q4`. The month is the number after `2026-` in the receipt's name.
6. **The new lease.** `documents` already has last year's `lease.pdf`. Keep it, and put the new `lease.pdf` beside it as `lease-2026.pdf`.
7. **Your resume.** Before you edit it, keep a copy: `resume.docx.bak`, beside `resume.docx`. Both go in `documents`.
8. **The rest.** The other `.pdf` files go in `documents`. When you're done, nothing is left loose in `downloads`: only folders.

## Check your work

From this folder (not from inside `downloads`):

```bash
bats check.bats
```

At first almost every check fails: that is expected. Each part you finish turns its check into a ✓. A failing check's message says what's still out of place and gives a hint.

## The rules

- Use the terminal: `mkdir`, `mv`, `cp`, wildcards and braces.
- Don't edit, empty or delete any file, and don't change `check.bats`.
- Nothing may be replaced. If last year's lease gets replaced by mistake, there's no undo: download the exercise again and start over.

## Tips

- `echo` a wildcard before you use it: it prints exactly the names the real command will get.
- Order matters. Sort the bus pass, the receipts and the lease before you move "every other `.pdf`".
- `mv -i` asks before it replaces a file, and `mv -n` never replaces one.
- A name with spaces needs quotes, or let Tab type it for you.

## Hand it in

When it works, push your solution to a public repo of your own on GitHub, then paste that repo's address into **Submit your exercise** on the lesson page at [ask-codey.com](https://www.ask-codey.com). That's what completes the lesson. The lesson page shows the Git commands, step by step.
