fmt:
	@echo "Formatting..."
	stylua --config-path ./nvim/stylua.toml nvim/
	prettier --write "**/*.{?(c)js?(on),md,yml}"
	shfmt -l -w -i 2 -ci -bn .

lint:
	@echo "Linting..."
	shfmt -l -d -i 2 -ci -bn .
