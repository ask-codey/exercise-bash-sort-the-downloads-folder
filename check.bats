#!/usr/bin/env bats
# Checks your sorted downloads folder: every file in its place, and nothing lost or replaced.
# Run it from this folder with:  bats check.bats
# You don't need to change this file.

setup() {
  cd "$BATS_TEST_DIRNAME"
}

# The files that match a find test, one per line, sorted, with the folder they're in.
files() {
  find downloads "$@" -type f 2>/dev/null | sort
}

# The same list on one line, for a message.
one_line() {
  tr '\n' ' ' | sed 's/ $//'
}

@test "the downloads folder is still here" {
  if [[ ! -d downloads ]]; then
    echo "There's no downloads folder here. Download the exercise again to get it back, and run the check from the folder that holds downloads."
    return 1
  fi
}

@test "1) photos, music and documents are folders in downloads" {
  for d in photos music documents; do
    if [[ ! -d "downloads/$d" ]]; then
      echo "There's no folder named $d in downloads yet. mkdir makes one, and several at once: mkdir followed by each name."
      return 1
    fi
  done
}

@test "2) receipts has a folder for each quarter, q1 to q4" {
  for q in q1 q2 q3 q4; do
    if [[ ! -d "downloads/receipts/$q" ]]; then
      echo "downloads/receipts/$q isn't there yet. mkdir -p makes receipts and a folder inside it in one go, and braces can name all four quarters at once."
      return 1
    fi
  done
}

@test "3) all nine photos are in photos" {
  stray="$(files \( -name '*.jpg' -o -name '*.png' \) -not -path 'downloads/photos/*' -not -path 'downloads/documents/bus-pass.png' | one_line)"
  if [[ -n "$stray" ]]; then
    echo "These photos aren't in photos yet: $stray. A wildcard such as *.jpg moves them all; echo the pattern first to see what it matches."
    return 1
  fi
  n="$(files -path 'downloads/photos/*' \( -name '*.jpg' -o -name '*.png' \) | wc -l | tr -d ' ')"
  if [[ "$n" != 9 ]]; then
    echo "photos holds $n photos, and it should hold 9: the eight .jpg photos and the screenshot of the bakery sign. The bus pass goes in documents, not photos."
    return 1
  fi
}

@test "4) the bus pass is documents/bus-pass.png" {
  old="$(files -name 'Screenshot 2026-10-02*' | one_line)"
  if [[ -n "$old" ]]; then
    echo "The bus pass still has its old name, at $old. mv renames a file as it moves it: give it the new address, documents/bus-pass.png. The old name has spaces, so put it in quotes."
    return 1
  fi
  if [[ ! -f downloads/documents/bus-pass.png ]] || ! grep -q 'bus pass' downloads/documents/bus-pass.png; then
    echo "There's no bus-pass.png in documents yet. It's the screenshot from October 2, Screenshot 2026-10-02 at 09.14.55.png."
    return 1
  fi
}

@test "5) all three songs are in music" {
  stray="$(files -name '*.mp3' -not -path 'downloads/music/*' | one_line)"
  n="$(files -path 'downloads/music/*' -name '*.mp3' | wc -l | tr -d ' ')"
  if [[ -n "$stray" ]]; then
    echo "These songs aren't in music yet: $stray. One mv with *.mp3 moves them all."
    return 1
  fi
  if [[ "$n" != 3 ]]; then
    echo "music holds $n .mp3 files, and it should hold 3: song-for-the-road.mp3, rainy-day-mix.mp3 and podcast-episode-12.mp3."
    return 1
  fi
}

@test "6) every receipt is in its quarter's folder" {
  n="$(files -name 'receipt-*.pdf' | wc -l | tr -d ' ')"
  if [[ "$n" != 12 ]]; then
    echo "The downloads folder holds $n receipts, and it should hold 12. Look for one that was renamed by mistake: ls each folder."
    return 1
  fi
  while read -r f; do
    name="$(basename "$f")"
    month="$(echo "$name" | cut -d- -f3)"
    want="downloads/receipts/q$(( (10#$month - 1) / 3 + 1 ))"
    if [[ "$(dirname "$f")" != "$want" ]]; then
      echo "$name is from month $month, so it belongs in $want, not in $(dirname "$f"). [ ] matches one character from a range: 0[1-3] is January to March."
      return 1
    fi
  done < <(files -name 'receipt-*.pdf')
}

@test "7) last year's lease is still documents/lease.pdf" {
  if [[ ! -f downloads/documents/lease.pdf ]]; then
    echo "documents/lease.pdf, last year's lease, isn't there any more. Download the exercise again to get it back."
    return 1
  fi
  if ! grep -q 'September 2025' downloads/documents/lease.pdf; then
    echo "documents/lease.pdf isn't last year's lease any more: a move or a copy replaced it. There's no undo, so download the exercise again, and use mv -n or mv -i when you sort into documents."
    return 1
  fi
}

@test "8) the new lease is documents/lease-2026.pdf" {
  if [[ ! -f downloads/documents/lease-2026.pdf ]] || ! grep -q 'September 2026' downloads/documents/lease-2026.pdf; then
    echo "There's no lease-2026.pdf in documents yet. Move the new lease, downloads/lease.pdf, into documents with that name, so it sits beside last year's."
    return 1
  fi
}

@test "9) resume.docx and its backup, resume.docx.bak, are in documents" {
  if [[ ! -f downloads/documents/resume.docx ]]; then
    echo "There's no resume.docx in documents yet."
    return 1
  fi
  if [[ ! -f downloads/documents/resume.docx.bak ]]; then
    echo "There's no resume.docx.bak in documents yet. cp makes a copy and keeps the original; braces can name both: resume.docx{,.bak}."
    return 1
  fi
  if ! cmp -s downloads/documents/resume.docx downloads/documents/resume.docx.bak; then
    echo "resume.docx.bak isn't an exact copy of resume.docx. Make it with cp, not touch: touch makes an empty file."
    return 1
  fi
}

@test "10) the other documents are in documents" {
  for f in bus-schedule.pdf biology-syllabus.pdf history-reading-list.pdf; do
    if [[ ! -f "downloads/documents/$f" ]]; then
      echo "$f isn't in documents yet."
      return 1
    fi
  done
}

@test "11) nothing is left loose in downloads" {
  loose="$(find downloads -maxdepth 1 -type f 2>/dev/null | sort | one_line)"
  if [[ -n "$loose" ]]; then
    echo "Still loose in downloads: $loose. Every file belongs in a folder."
    return 1
  fi
}
