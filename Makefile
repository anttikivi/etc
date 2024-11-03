.PHONY: fmt

fmt:
	@printf "\nFormatting...\n"
	@printf "\nRunning Stylua...\n"
	stylua --config-path nvim/stylua.toml nvim/
