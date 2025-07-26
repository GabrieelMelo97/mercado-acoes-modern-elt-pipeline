.PHONY: help install install-dev test lint format check clean deploy destroy

# Variáveis
PYTHON_VERSION = 3.11
PROJECT_NAME = stock-market-pipeline

help: ## Mostra esta mensagem de ajuda
	@echo "Comandos disponíveis:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Instala dependências do projeto
	@echo "Instalando dependências..."
	uv sync

install-dev: ## Instala dependências de desenvolvimento
	@echo "Instalando dependências de desenvolvimento..."
	uv sync --extra dev

install-all: ## Instala todas as dependências (incluindo Airflow)
	@echo "Instalando todas as dependências..."
	uv sync --extra all

lint: ## Executa linting (ruff)
	@echo "Executando linting..."
	uv run ruff check .

lint-fix: ## Executa linting com correção automática
	@echo "Executando linting com correção automática..."
	uv run ruff check . --fix

format: ## Formata código com black
	@echo "Formatando código..."
	uv run black .

type-check: ## Verifica tipos com mypy
	@echo "Verificando tipos..."
	uv run mypy dags/ dataproc_jobs/

check: lint type-check ## Executa todas as verificações de qualidade
	@echo "Todas as verificações concluídas!"

pre-commit-install: ## Instala hooks do pre-commit
	@echo "Instalando hooks do pre-commit..."
	uv run pre-commit install

pre-commit-run: ## Executa pre-commit em todos os arquivos
	@echo "Executando pre-commit..."
	uv run pre-commit run --all-files

clean: ## Remove arquivos temporários
	@echo "Limpando arquivos temporários..."
	find . -type f -name "*.pyc" -delete
	find . -type d -name "__pycache__" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} +
	find . -type d -name ".pytest_cache" -exec rm -rf {} +
	find . -type d -name ".mypy_cache" -exec rm -rf {} +
	find . -type d -name ".ruff_cache" -exec rm -rf {} +
	rm -rf htmlcov/
	rm -rf .coverage

# Comandos de infraestrutura
tf-init: ## Inicializa Terraform
	@echo "Inicializando Terraform..."
	cd infra && terraform init

tf-plan: ## Exibe plano do Terraform
	@echo "Gerando plano do Terraform..."
	cd infra && terraform plan

tf-apply: ## Aplica mudanças do Terraform
	@echo "Aplicando mudanças do Terraform..."
	cd infra && terraform apply

tf-destroy: ## Destrói infraestrutura
	@echo "Destruindo infraestrutura..."
	cd infra && terraform destroy

# Comandos de desenvolvimento
dev-setup: install-dev pre-commit-install ## Configuração inicial para desenvolvimento
	@echo "Ambiente de desenvolvimento configurado!"

validate: check test ## Valida código antes do commit
	@echo "Validação completa!"

# Comandos do pipeline
upload-erp: ## Faz upload do arquivo ERP para GCS
	@echo "Fazendo upload do arquivo ERP..."
	gsutil cp data/erp_companies.csv gs://datalake-stock-market-bucket/raw/ERP/

# Utilitários
env-info: ## Mostra informações do ambiente
	@echo "Informações do ambiente:"
	@echo "Python: $(shell python --version)"
	@echo "uv: $(shell uv --version)"
	@echo "Diretório: $(shell pwd)"
	@echo "Arquivos Python:"
	@find . -name "*.py" | head -10

add-dep: ## Adiciona nova dependência (usar: make add-dep PACKAGE=nome-do-pacote)
	@echo "Adicionando dependência: $(PACKAGE)"
	uv add $(PACKAGE)

add-dev-dep: ## Adiciona dependência de desenvolvimento
	@echo "Adicionando dependência de desenvolvimento: $(PACKAGE)"
	uv add --dev $(PACKAGE) 