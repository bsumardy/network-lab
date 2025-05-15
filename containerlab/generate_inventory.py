import subprocess
import yaml
import os

TOPOLOGY_FILE = "containerlab/topo.clab.yaml"
OUTPUT_FILE = "inventory.yml"

def get_inspect_data():
    result = subprocess.run(
        ["containerlab", "inspect", "-t", TOPOLOGY_FILE],
        capture_output=True,
        text=True
    )
    if result.returncode != 0:
        print("Error running containerlab inspect:")
        print(result.stderr)
        exit(1)
    return yaml.safe_load(result.stdout)

def generate_inventory(inspect_data):
    inventory = {
        "all": {
            "vars": {
                "ansible_httpapi_use_proxy": False,
                "ansible_user": "root",
                "ansible_password": "root",
                "ansible_ssh_common_args": "-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
            },
            "children": {
                "routers": {
                    "hosts": {}
                }
            }
        }
    }

    for node in inspect_data:
        name = node["name"]
        ssh_port = node["ssh"]
        inventory["all"]["children"]["routers"]["hosts"][name] = {
            "ansible_host": "127.0.0.1",
            "ansible_port": ssh_port
        }

    return inventory

def save_inventory(inventory):
    with open(OUTPUT_FILE, "w") as f:
        yaml.dump(inventory, f, default_flow_style=False)
    print(f"✅ Inventory written to: {OUTPUT_FILE}")

if __name__ == "__main__":
    print("🔍 Inspecting containerlab topology...")
    data = get_inspect_data()
    print("🛠️ Generating Ansible inventory...")
    inventory = generate_inventory(data)
    save_inventory(inventory)
