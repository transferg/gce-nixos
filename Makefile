.DEFAULT_GOAL = help

export PROJECT_ID = servergeneral-dev
export BUCKET = nixos-image-sg
export NIXPKGS_ALLOW_UNFREE = 1
export BRANCH = unstable

image: ## build gce image
image: export BUCKET_NAME=$(BUCKET)
image: check nixpkgs
	nixpkgs/nixos/maintainers/scripts/gce/create-gce.sh

nixpkgs: ## clone nixpkgs
	git clone --depth=1 --branch nixos-$(BRANCH) https://github.com/NixOS/nixpkgs.git

bucket: ## create bucket nixos-image
	gcloud storage buckets create gs://$(BUCKET)

login: ## login to GCP
	gcloud auth login
	gcloud config set project $(PROJECT_ID)

clean: ## clean
	find . -name \*~ -o -regex '.*#.*' | xargs rm -f

dev: ## develop
	nix develop --impure

help: ## help
	@grep -E '^[a-zA-Z00-9_%-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'

check:
	@if [ "Linux" != "$(shell uname -s)" ]; then \
		echo "error: must be on Linux"; \
		exit 1; \
	fi
