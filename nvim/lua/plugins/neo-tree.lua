---@type LazySpec
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local git = require("neo-tree.git")

      -- Zed-style git colours: modified = amber, new/untracked = green.
      -- These groups otherwise inherit neo-tree's muted diff defaults; link them
      -- to the Diagnostic colours instead, and re-apply on every colorscheme
      -- switch so the mapping survives mocha <-> latte (catppuccin's neo_tree
      -- integration is off, so nothing else defines them).
      local function set_git_highlights()
        vim.api.nvim_set_hl(0, "NeoTreeGitModified", { link = "DiagnosticWarn", default = false })
        vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { link = "DiagnosticOk", default = false })
        vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { link = "DiagnosticOk", default = false })
      end
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("AmbitNeoTreeGitColors", { clear = true }),
        callback = set_git_highlights,
      })
      set_git_highlights()

      -- Neo-tree's first paint can land before before_render has populated the
      -- git lookup, so colours only appear after a manual refresh/reopen. Kick a
      -- one-shot refresh the first time a neo-tree window appears this session.
      local did_first_refresh = false
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "neo-tree",
        group = vim.api.nvim_create_augroup("AmbitNeoTreeFirstRefresh", { clear = true }),
        callback = function()
          if did_first_refresh then
            return
          end
          did_first_refresh = true
          vim.defer_fn(function()
            pcall(function()
              require("neo-tree.sources.manager").refresh("filesystem")
            end)
          end, 100)
        end,
      })

      -- Multi-repo git status. Neo-tree natively computes git status for the
      -- single repo at the cwd only. This workspace is a parent folder holding
      -- many independent repos, so the cwd isn't a repo and nothing gets
      -- coloured. We compute status per nested repo and merge it into the same
      -- `state.git_status_lookup` neo-tree's native colouring already consumes,
      -- so files, sub-directories, AND repo roots all light up (the git module
      -- bubbles each file's status up to its parent directories).
      local CACHE_TTL_NS = 2000 * 1000000
      local full_cache = {} -- repo_path -> { lookup = table, checked_at = ns }
      local dirty_cache = {} -- repo_path -> { dirty = bool, checked_at = ns }

      local function is_git_repo(path)
        local git_dir = path .. "/.git"
        return vim.fn.isdirectory(git_dir) == 1 or vim.fn.filereadable(git_dir) == 1
      end

      -- Full per-file status for an expanded repo (file + sub-dir + root colours).
      local function repo_full(repo_path, base)
        local now = (vim.uv or vim.loop).hrtime()
        local cached = full_cache[repo_path]
        if cached and now - cached.checked_at <= CACHE_TTL_NS then
          return cached.lookup
        end
        -- git.status(base, exclude_directories, path): exclude_directories=false
        -- so status bubbles up to parent dirs (and the repo root).
        local ok, lookup = pcall(git.status, base or "HEAD", false, repo_path)
        lookup = (ok and type(lookup) == "table") and lookup or {}
        full_cache[repo_path] = { lookup = lookup, checked_at = now }
        return lookup
      end

      -- Cheap one-call dirty check for a collapsed repo (just colours its root).
      local function repo_dirty(repo_path)
        local now = (vim.uv or vim.loop).hrtime()
        local cached = dirty_cache[repo_path]
        if cached and now - cached.checked_at <= CACHE_TTL_NS then
          return cached.dirty
        end
        local res = vim.system({ "git", "-C", repo_path, "status", "--porcelain" }, { text = true }):wait()
        local dirty = res.code == 0 and res.stdout ~= ""
        dirty_cache[repo_path] = { dirty = dirty, checked_at = now }
        return dirty
      end

      local function is_expanded(state, path)
        if not (state.tree and state.tree.get_node) then
          return false
        end
        local ok, node = pcall(function()
          return state.tree:get_node(path)
        end)
        return ok and node ~= nil and node:is_expanded() or false
      end

      -- Immediate child directories of `root` that are git repos. Matches this
      -- workspace's flat "parent of repos" layout.
      local function child_repos(root)
        local repos = {}
        local ok, entries = pcall(vim.fn.readdir, root)
        if ok and entries then
          for _, name in ipairs(entries) do
            local child = root .. "/" .. name
            if vim.fn.isdirectory(child) == 1 and is_git_repo(child) then
              repos[#repos + 1] = child
            end
          end
        end
        return repos
      end

      -- Walk up from a path to the git repo that contains it (the path itself,
      -- an ancestor, or nil). Lets the tree colour correctly when it is opened
      -- *inside* a repo subdir, not only at a repo root or the workspace parent.
      local function find_containing_repo(path)
        local dir = path
        while dir and dir ~= "" do
          if is_git_repo(dir) then
            return dir
          end
          local parent = vim.fn.fnamemodify(dir, ":h")
          if parent == dir then
            break
          end
          dir = parent
        end
        return nil
      end

      -- before_render replaces neo-tree's own (single-repo) git wiring; we own
      -- the lookup now. NOTE: this is a *per-source* option, so it must live
      -- under opts.filesystem, not at the top level (top-level is ignored).
      --
      -- Three root shapes are handled so colours appear everywhere:
      --   * root is a repo          -> full per-file status of that repo;
      --   * root is a parent-of-repos (not a repo, has child repos) -> colour
      --     each child repo (full status when expanded, amber marker when not);
      --   * root is inside a repo    -> walk up and show that repo's status.
      local function before_render(state)
        local root = state.path
        if not root then
          state.git_status_lookup = state.git_status_lookup or {}
          return
        end
        local prefix = root .. "/"
        local merged = {}

        -- Merge a repo's per-file status, keeping only entries inside the tree
        -- root (drop the root itself and the ancestor paths that status-bubbling
        -- produces above it).
        local function add_full(repo)
          for path, code in pairs(repo_full(repo, state.git_base)) do
            if path ~= root and vim.startswith(path, prefix) then
              merged[path] = code
            end
          end
        end

        local children = child_repos(root)
        if is_git_repo(root) then
          -- The tree root is itself a repo: full status for the whole subtree.
          add_full(root)
        elseif #children == 0 then
          -- Not a repo and no child repos: we're inside a repo's subtree. Walk
          -- up to that repo so the visible files and directories still colour.
          local container = find_containing_repo(root)
          if container then
            add_full(container)
          end
        end

        -- Parent-of-repos layout (also nested repos under a repo root): colour
        -- each immediate child repo.
        for _, child in ipairs(children) do
          if is_expanded(state, child) then
            add_full(child)
          elseif repo_dirty(child) then
            merged[child] = "M"
          end
        end

        state.git_status_lookup = merged
      end

      opts.enable_git_status = true
      opts.default_component_configs = vim.tbl_deep_extend("force", opts.default_component_configs or {}, {
        name = {
          -- Colour names (files and dirs) by the git status in the lookup above.
          use_git_status_colors = true,
        },
      })

      opts.filesystem = opts.filesystem or {}
      -- Per-source hook: keeps neo-tree's native (single-repo) git wiring OFF so
      -- it can't overwrite our multi-repo lookup.
      opts.filesystem.before_render = before_render
      -- Robust render hook. The per-source `filesystem.before_render` above is
      -- wired via `manager.subscribe(source, ...)` *inside* the source setup, and
      -- on a fresh-start load path that subscription never fires (the lookup
      -- stays empty -> no colours). The global `event_handlers` list, by
      -- contrast, is subscribed during neo-tree.setup() right after it calls
      -- clear_all_events(), so it reliably fires `before_render` on every render.
      -- We filter to the filesystem source and populate the same lookup.
      opts.event_handlers = opts.event_handlers or {}
      table.insert(opts.event_handlers, {
        event = "before_render",
        handler = function(state)
          if state and state.name == "filesystem" then
            before_render(state)
          end
        end,
      })
      opts.filesystem.renderers = opts.filesystem.renderers or {}
      opts.filesystem.renderers.directory = {
        { "indent" },
        { "icon" },
        { "current_filter" },
        {
          "container",
          content = {
            { "name", zindex = 10 },
            { "symlink_target", zindex = 10, highlight = "NeoTreeSymbolicLinkTarget" },
            { "clipboard", zindex = 10 },
            { "diagnostics", errors_only = true, zindex = 20, align = "right", hide_when_expanded = true },
            { "git_status", zindex = 10, align = "right", hide_when_expanded = true },
            { "file_size", zindex = 10, align = "right" },
            { "type", zindex = 10, align = "right" },
            { "last_modified", zindex = 10, align = "right" },
            { "created", zindex = 10, align = "right" },
          },
        },
      }
    end,
  },
}
