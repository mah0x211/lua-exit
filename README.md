# lua-exit

[![test](https://github.com/mah0x211/lua-exit/actions/workflows/test.yml/badge.svg)](https://github.com/mah0x211/lua-exit/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/mah0x211/lua-exit/branch/master/graph/badge.svg)](https://codecov.io/gh/mah0x211/lua-exit)

lua-exit is a module that provides a function to terminate the host program after garbage collection.


**NOTE**: 

this module is used for testing purposes only.  
it is not recommended to use it in production.

- In Lua 5.2 or later, just calls the function `os.exit(code, true)`. If `os.exit` is not available, it falls back to the following behavior.
- In Lua 5.1, sets the hook function to do garbage collection before exiting the program. The hook function throws an error until the stack level becomes 0. If the stack level becomes 0, it calls the C function `exit(code)`. 　it is necessary to do garbage collection before exiting the program.
- In LuaJIT, it same as Lua 5.2 but it cannot call the C function `exit(code)`.


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

