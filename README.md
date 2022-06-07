# lua-exit

[![test](https://github.com/mah0x211/lua-exit/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-exit/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-exit/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-exit)

calls the ISO C function exit and lua_close to terminate the host program.

## Installation

```sh
luarocks install exit
```

## exit( [code] )

calls the ISO C function exit and lua_close to terminate the host program.

**Params**

- `code:boolean|number`: default `true`.
  - if code is `true`, the returned status is `EXIT_SUCCESS`;
  - if code is `false`, the returned status is `EXIT_FAILURE`;
  - if code is a `number`, the returned status is this number.

