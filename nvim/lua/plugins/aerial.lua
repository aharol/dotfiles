---@type LazySpec
return {
  -- AstroNvim pins aerial to `version = "^2.2"` (see lazy_snapshot.lua). On
  -- Neovim 0.12 that range is broken: 0.12 removed the `all` parameter from
  -- `Query:iter_matches`, so query captures are always lists of nodes. aerial
  -- <=2.7.0 still calls `iter_matches(..., { all = false })` and treats each
  -- capture as a single node, so the treesitter backend crashes with
  -- "attempt to call method 'type' (a nil value)" on every parse.
  -- Upstream fixed this in 3.1+/4.0 ("remove use of deprecated
  -- iter_matches({all = false})"). Drop the semver ceiling so lazy follows
  -- master (still pinned to an exact commit by lazy-lock.json).
  "stevearc/aerial.nvim",
  version = false,
}
