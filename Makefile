.DEFAULT_GOAL = help

export PROJECT_ID = servergeneral-dev
export BUCKET = nixos-image
export NIXPKGS_ALLOW_UNFREE = 1
export BRANCH = unstable

image: ## build gce image
image: export BUCKET_NAME=$(BUCKET)
image: nixpkgs
	nixpkgs/nixos/maintainers/scripts/gce/create-gce.sh

nixpkgs: ## clone nixpkgs
	git clone --depth=1 --branch nixos-$(BRANCH) https://github.com/NixOS/nixpkgs.git

init: ## initialize bucket and other dependencies
	gcloud storage buckets create gs://nixos-image

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
