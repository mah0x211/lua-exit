rockspec_format = "3.0"
package = "exit"
version = "dev-1"
source = {
    url = "git+https://github.com/mah0x211/lua-exit.git",
}
description = {
    summary = "calls the ISO C function exit and lua_close to terminate the host program.",
    homepage = "https://github.com/mah0x211/lua-exit",
    license = "MIT/X11",
    maintainer = "Masatoshi Fukunaga",
}
dependencies = {
    "lua >= 5.1",
}
build_dependencies = {
    "luarocks-build-hooks >= 0.8.0",
}
build = {
    type = "hooks",
    before_build = "$(extra-vars)",
    extra_variables = {
        CFLAGS = "-Wall -Wno-trigraphs -Wmissing-field-initializers -Wreturn-type -Wmissing-braces -Wparentheses -Wno-switch -Wunused-function -Wunused-label -Wunused-parameter -Wunused-variable -Wunused-value -Wuninitialized -Wunknown-pragmas -Wshadow -Wsign-compare",
    },
    conditional_variables = {
        EXIT_COVERAGE = {
            CFLAGS = "--coverage",
            LIBFLAG = "--coverage",
        },
    },
    modules = {
        exit = {
            sources = "src/exit.c",
        },
    },
}
