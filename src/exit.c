/**
 * Copyright (C) 2022 Masatoshi Fukunaga
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
#include <stdlib.h>
// lua
#include <lauxlib.h>
#include <lua.h>
#include <luaconf.h>

#if defined(LUA_LJDIR)

static void exit_hook(lua_State *L, lua_Debug *ar)
{
    (void)ar;
    lua_pushstring(L, "force exit");
    lua_error(L);
}

static void do_exit(lua_State *L, int code)
{
    (void)code;
    lua_sethook(L, exit_hook,
                LUA_MASKCALL | LUA_MASKRET | LUA_MASKLINE | LUA_MASKCOUNT, 0);
}

#else

static int gExitStatus = 0;

static void exit_hook(lua_State *L, lua_Debug *ar)
{
    if (!lua_getstack(L, 1, ar)) {
        lua_gc(L, LUA_GCCOLLECT, 0);
        exit(gExitStatus);
    }
    lua_pushstring(L, "force exit");
    lua_error(L);
}

static void do_exit(lua_State *L, int code)
{
    gExitStatus = code;
    lua_sethook(L, exit_hook,
                LUA_MASKCALL | LUA_MASKRET | LUA_MASKLINE | LUA_MASKCOUNT, 0);
}

#endif

static int exit_lua(lua_State *L)
{
    int code = EXIT_SUCCESS;

    switch (lua_type(L, 1)) {
    case LUA_TBOOLEAN:
        if (!lua_toboolean(L, 1)) {
            code = EXIT_FAILURE;
        }
    case LUA_TNONE:
    case LUA_TNIL:
        break;

    default:
        code = luaL_checkinteger(L, 1);
    }

#if defined(LUA_LJDIR) || LUA_VERSION_NUM >= 502
    lua_getglobal(L, "os");
    if (lua_istable(L, -1)) {
        lua_pushliteral(L, "exit");
        lua_rawget(L, -2);
        if (lua_isfunction(L, -1)) {
            lua_pushinteger(L, code);
            lua_pushboolean(L, 1);
            lua_call(L, 2, 0);
            return 0;
        }
    }
#endif

    do_exit(L, code);
    return 0;
}

LUALIB_API int luaopen_exit(lua_State *L)
{
    lua_pushcfunction(L, exit_lua);
    return 1;
}
