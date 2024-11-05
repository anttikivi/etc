.PHONY: all fmt lint

all: lint

fmt:
	@printf "\nFormatting...\n"
	@printf "\nFormatting Lua files...\n"
	stylua --config-path nvim/stylua.toml nvim/
	@printf "\nFormatting shell scripts...\n"
	shfmt -l -w -i 2 -bn -ci .
	@printf "\nFormatting whatever it is that's formatted with Prettier...\n"
	@printf "(JSON, Markdown, and YAML files...)\n"
	prettier --write "**/*.{json,md,prettierrc,y?(a)ml}"

lint:
	@printf "\nLinting...\n"
	@printf "\nLinting Lua files...\n"
	stylua --check --config-path nvim/stylua.toml nvim/
	selene --config nvim/selene.toml .
	@printf "\nLinting shell scripts...\n"
	shfmt -l -d -i 2 -bn -ci .
	shellcheck \
		./bin/* \
		./runs/* \
		./utils/colors.sh \
		./utils/update_color_scheme_daemon \
		./utils/update_encrypted_config \
		./zsh/* \
		./bash_profile \
		./bootstrap \
		./color_scheme.sh \
		./directories.sh \
		./install \
		./update \
		./versions.sh \
		./zprofile \
		./zshenv \
		./zshrc
	@printf "\nLinting whatever it is that's checked with Prettier...\n"
	@printf "(formatting for JSON, Markdown, and YAML files...)\n"
	prettier --check "**/*.{json,md,prettierrc,y?(a)ml}"
