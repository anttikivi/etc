-- vim: ft=lua tw=80

ignore = {
  "122", -- Setting a read-only field of a global variable.
  "631", -- max_line_length, some lines are just long.
}

-- Global objects defined by the C code
read_globals = {
  "vim",
}
