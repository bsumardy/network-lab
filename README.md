**Network Automation Lab — Initial CI/CD Setup**
This repository is part of an ongoing project to automate a network lab environment using Ansible, Containerlab, and GitHub Actions. At this stage, we have completed the foundational CI/CD setup and automated validation of Ansible playbooks.

**Current Milestone: CI/CD Pipeline for Ansible**
✔️ What’s Done
Ansible directory structure is in place (ansible/)

Core playbooks:

playbook.yml

push-config.yml

push-frr.yml

GitHub Actions Workflow:

Lints Ansible code using ansible-lint

Checks playbook syntax

Validates requirements.txt (excluding problematic system packages)

Code is passing all syntax and lint checks ✅

📁 Project Structure (Relevant Parts)

.
├── ansible/
│   ├── inventory.ini       # (Inventory definition)
│   ├── playbook.yml        # Main automation playbook
│   ├── push-config.yml     # Push configs to network devices
│   ├── push-frr.yml        # Push FRR configs
│   └── roles/, templates/  # Ansible role and template structure
├── .github/
│   └── workflows/
│       └── sanity-check.yml  # CI workflow for lint & syntax check
├── requirements.txt

**How to Run Locally**

# Activate your virtual environment
source iaac-env/bin/activate

# Install requirements
pip install -r requirements.txt

# Run a playbook manually (with inventory)
ansible-playbook -i ansible/inventory.ini ansible/push-config.yml

⚙️ GitHub Actions
Each push to main or any branch triggers:

ansible-lint check

Syntax validation for all playbooks in ansible/*.yml

Note: Playbooks that target hosts like leaf1 require an actual inventory setup. Currently, CI uses implicit localhost for syntax checking.

🚧 Next Milestones
Push Ansible Configs to FRR-enabled nodes

Integrate NetBox for source-of-truth

Automate topology creation using Containerlab

Add testing & validation with Batfish
