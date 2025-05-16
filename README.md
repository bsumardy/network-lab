# 🧪 Network Automation Lab — CI/CD + Automation Setup

This repository is part of an evolving network automation project using **Ansible**, **Containerlab**, and **GitHub Actions**. The current focus is implementing a robust CI/CD pipeline to validate and deploy network configurations in a simulated lab environment.

---

## ✅ Current Milestone: CI/CD for Ansible + Containerlab Integration

### ✔️ What's Done

- **Ansible Automation Structure**
  - `ansible/` directory with playbooks and templates
  - Core playbooks:
    - `playbook.yml`: master automation playbook
    - `push-config.yml`: push generic configs to devices
    - `push-frr.yml`: push FRR configurations

- **GitHub Actions Integration**
  - Workflow defined in `.github/workflows/sanity-check.yml`
  - Validates:
    - `ansible-lint` compliance
    - Playbook syntax
    - `requirements.txt` format (system packages excluded)
  - CI status: **✅ Passing**

- **Containerlab Topology Validation**
  - Topology launched via `create_topo.sh`
  - Ansible connects to each node and pushes config
  - OSPF neighbor relationships checked via SSH
  - Added 30s delay to ensure interfaces/OSPF stabilize before validation

---

## 📁 Project Structure
```
.
├── ansible/
│ ├── inventory.ini # Inventory file
│ ├── playbook.yml # Main playbook
│ ├── push-config.yml # Push base configs
│ ├── push-frr.yml # Push FRR routing configs
│ ├── roles/ # Ansible roles
│ └── templates/ # Jinja2 templates
├── containerlab/
│ ├── topo.clab.yaml # Topology definition
│ └── configs/ # Node-specific config outputs
├── scripts/
│ ├── create_topo.sh # Brings up the topology
│ └── validate_lab.sh # Validates node config and OSPF state
├── .github/
│ └── workflows/
│ └── sanity-check.yml # CI pipeline for linting and validation
├── requirements.txt
```

---

## 🚀 How to Run Locally

# 1. Activate your Python virtual environment
source iaac-env/bin/activate

# 2. Install Python dependencies
pip install -r requirements.txt

# 3. Launch the containerlab topology
bash scripts/create_topo.sh

# 4. Run a playbook
ansible-playbook -i ansible/inventory.ini ansible/push-config.yml

# 5. Validate node config and routing
bash scripts/validate_lab.sh

# ⚙️ GitHub Actions (CI)
Each push to main or any branch runs the following:
- ansible-lint for YAML and task best practices
- Playbook syntax validation (ansible-playbook --syntax-check)
- Ensures all scripts are executable and topology is valid
- Runs automated config push + OSPF neighbor validation

# ✅ Latest Status: GREEN

# 🔜 Next Milestones
 - Extend FRR config automation to include BGP scenarios
 - Integrate NetBox as a dynamic inventory + source-of-truth
 - Auto-generate diagrams from containerlab topology
 - Add Batfish for static analysis and config validation
