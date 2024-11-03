.PHONY: fmt

fmt:
	@printf "\nFormatting...\n"
	@printf "\nFormatting Lua files...\n"
	stylua --config-path nvim/stylua.toml nvim/
	@printf "\nFormatting shell scripts...\n"
	shfmt -l -w -i 2 -bn -ci .
