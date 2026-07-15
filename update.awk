# given a yaml file with the following structure...
#
# ```yaml
# inputs:
#   version:
#     default: SOME_VERSION
#   checksum:
#     default: SOME_CHECKSUM
# ```
#
# ...surgically update those defaults with a given VERSION and CHECKSUM.
#
# we could do this much more easily using `yq` or nushell, however those approaches
# destroy file formatting, comments, etc.
#
# this AWK-based approach, while ugly, will only touch the characters it needs to.

BEGIN {
  inputs = 0
  version = 0
  checksum = 0
  skip = 0
}

$0 == "" { inputs = 0; version = 0; checksum = 0; }
$1 == "inputs:" { inputs = 1 }
$1 == "version:" { version = 1; checksum = 0 }
$1 == "checksum:" { checksum = 1; version = 0 }

inputs == 1 && version == 1 && $1 == "default:" {
  printf("    default: '%s'\n", VERSION)

  # we've outputted a new value; don't print it again down below.
  skip = 1
}

inputs == 1 && checksum == 1 && $1 == "default:" {
  printf("    default: '%s'\n", CHECKSUM)

  # we've outputted a new value; don't print it again down below.
  skip = 1
}

skip == 0 { printf("%s\n", $0) }
1 == 1 { skip = 0 }
