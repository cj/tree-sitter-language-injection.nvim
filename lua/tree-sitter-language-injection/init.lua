local runtime_path = vim.api.nvim_list_runtime_paths()[1]
local after_path = runtime_path .. "/after"
local queries_path = runtime_path .. "/after/queries"

local queries = {
	python = {
		injections = [[
;; query
; extends
;; STRING SQL INJECTION
((string_content) @injection.content
  (#match? @injection.content "^\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n")
  (#set! injection.language "sql"))

;; STRING SALDB INJECTION
((string_content) @injection.content
  (#match? @injection.content "^\n*( )*-{2,}( )*[sS][uU][rR][qQ][lL]( )*\n")
  (#set! injection.language "surrealdb"))

;; STRING HTML INJECTION
((string_content) @injection.content
  (#match? @injection.content "^\n*( )*-{2,}( )*[hH][tT][mM][lL]( )*\n")
  (#set! injection.language "html"))
		]],
	},
	typescript = {
		injections = [[
;; query
; extends
;; STRING SQL INJECTION
((template_string) @injection.content
  (#match? @injection.content "^`\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n")
  (#set! injection.language "sql"))

;; STRING SURREALDB INJECTION
((template_string) @injection.content
  (#match? @injection.content "^`\n*( )*-{2,}( )*[sS][uU][rR][qQ][lL]( )*\n")
  (#set! injection.language "surrealdb"))
		]],
	},
	javascript = {
		injections = [[
;; query
; extends
;; STRING SQL INJECTION
((template_string) @injection.content
  (#match? @injection.content "^`\n*( )*-{2,}( )*[sS][qQ][lL]( )*\n")
  (#set! injection.language "sql"))

;; STRING SURREALDB INJECTION
((template_string) @injection.content
  (#match? @injection.content "^`\n*( )*-{2,}( )*[sS][uU][rR][qQ][lL]( )*\n")
  (#set! injection.language "surrealdb"))
		]],
	},
}

local function write(lang, file, content)
	local lang_path = queries_path .. "/" .. lang
	if vim.fn.isdirectory(lang_path) == 0 then
		vim.fn.mkdir(lang_path)
	end

	local file_path = lang_path .. "/" .. file .. ".scm"
	if vim.fn.filereadable(file_path) == 0 then
		local file_handle = io.open(file_path, "w")
		io.output(file_handle)
		io.write(content)
		io.close(file_handle)
	end
end

local function init()
	if vim.fn.isdirectory(after_path) == 0 then
		vim.fn.mkdir(after_path)
	end
	if vim.fn.isdirectory(queries_path) == 0 then
		vim.fn.mkdir(queries_path)
	end
	for lang, value in pairs(queries) do
		for file, content in pairs(value) do
			write(lang, file, content)
		end
	end
end

local function setup()
	init()
end

return { setup = setup }
